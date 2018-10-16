//
//  HTTPTool.m
//  btc
//
//  Created by lingda on 2017/8/25.
//  Copyright © 2017年 btc. All rights reserved.


#import "LDHTTPTool.h"
#import "LDHTTPManager.h"
#import "NSString+tcl_parseXML.h"

NSMutableDictionary * taskDescriptions;

@implementation LDHTTPTool

#pragma mark - public method
+ (void)getIPAndPortSuccess:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure
{
    NSLog(@"\n---【发送获取IP 和 端口的请求】---");
    LDHTTPModel * model = [LDHTTPModel new];
    model = [LDHTTPTool decorate:model httpType:LDHTTPTypeGet url:@"http://ds.zx.test.tcljd.net:8500/distribute-server/get_as_addr?method=get_as&clienttype=4&userid=2004050&replyproto=xml" parameters:nil];
    [LDHTTPTool sendModel:model success:^(LDHTTPModel *responseObject) {
        responseObject.data = [responseObject.dataOrigin tcl_hostAndPort];
        if (success) {
            success(responseObject);
        }
    } failure:failure];
}
+(void)sendModel:(LDHTTPModel *)model success:(void (^)(LDHTTPModel * responseObject))success failure:(void (^)(LDHTTPModel * responseObject))failure
{
    if (taskDescriptions == nil) {
        taskDescriptions = [NSMutableDictionary dictionary];
    }
    if (model.VCName != nil  && model.taskDescription != nil) {
        [taskDescriptions setObject:model.VCName forKey:model.taskDescription];
    }
    //打印请求信息
    NSLog(@"\n[发起请求的类:%@][请求描述:%@][请求URL:%@][请求参数:%@]",model.VCName,model.taskDescription,[model.url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[model.parameters description]);
    [LDHTTPTool cancelHTTPTask:model.taskDescription];//每次请求前先取消相同描述的请求
    [[LDHTTPManager shared] sendMessage:model success:^(LDHTTPModel *responseObject) {
        responseObject.dataOrigin = [[NSString alloc] initWithData:(NSData *)responseObject.dataOrigin encoding:NSUTF8StringEncoding];
        //打印回调信息
        NSLog(@"\n[发起请求的类:%@][请求描述:%@][请求URL:%@][请求参数:%@][服务器返回的数据:%@]",responseObject.VCName,responseObject.taskDescription,[responseObject.url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[responseObject.parameters description],responseObject.dataOrigin);
        if ([[responseObject.dataOrigin tcl_errorCode] isEqualToString:@"0"] ||
            [[responseObject.dataOrigin tcl_errorCode] isEqualToString:@"0"]) {
            if (success) {
              success(responseObject);
            }
        } else {
            if (failure) {
              failure(responseObject);
            }
        }
        
    } failure:^(LDHTTPModel * responseObject) {
        NSLog(@"\n服务器返回的错误:%@",responseObject.errorOfAFN);
        NSString * errorStr = responseObject.errorOfAFN.userInfo[NSLocalizedDescriptionKey];
        if([errorStr isEqualToString:@"cancelled"]) {
            NSLog(@"\n[发起请求的类:%@][请求描述:%@][请求取消]",responseObject.VCName,responseObject.taskDescription);
            if (failure) {
                responseObject.errorOfMy = @"请求取消";
                failure(responseObject);
            }
            return ;
        }
        if (failure) {
            responseObject.errorOfMy = [responseObject.errorOfAFN description];
            failure(responseObject);
        }
    }];
}


+(void)cancelHTTPTask:(NSString *)taskDescription
{
    [[LDHTTPManager shared] cancelHTTPTask:taskDescription];
}

+(void)cancelHTTPTasksByViewControllerName:(NSString *)viewControllerName
{
    [taskDescriptions enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:viewControllerName]) {
            [LDHTTPTool cancelHTTPTask:key];
            [taskDescriptions removeObjectForKey:key];
        }
    }];
}

+ (void)updateHttpModel:(LDHTTPModel *)httpModel token:(NSString *)tokenNew
{
    NSString * tokenOld = httpModel.token;
    //1.更新原来的请求参数中的token
    if (httpModel.parameters != nil) {//参数是放在parameters里面的
        NSMutableDictionary * parameters = httpModel.parameters;
        NSString * signValueStrOld = @"jsonString";
        NSString * signValueStrNew = [signValueStrOld stringByReplacingOccurrencesOfString:tokenOld withString:tokenNew];
        [parameters setObject:signValueStrNew forKey:@"sign"];
        httpModel.parameters = parameters;
    } else {//参数是拼接在URL后面的
        NSString * tokenOldEncode = [tokenOld stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * tokenNewEncode = [tokenNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        httpModel.url = [httpModel.url stringByReplacingOccurrencesOfString:tokenOldEncode withString:tokenNewEncode];
    }
}

+ (NSArray *)imageParamsArr:(NSDictionary *)imageDic
{
    __block int i = 0;
    NSMutableArray * imageParamsArr = [NSMutableArray array];
    [imageDic enumerateKeysAndObjectsUsingBlock:^(NSString * imageName, UIImage * image, BOOL * stop) {
        NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
        NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
        NSString * name = imageName;
        NSString * filename = [NSString stringWithFormat:@"picture%d.png",i++];
        NSString * mimeType = @"image/png";
        
        [paramsDic setValue:imageData forKey:kLDHTTPImageUploadImageDataKey];
        [paramsDic setValue:name forKey:kLDHTTPImageUploadImageNameKey];
        [paramsDic setValue:filename forKey:kLDHTTPImageUploadFileNameKey];
        [paramsDic setValue:mimeType forKey:kLDHTTPImageUploadMimeTypeKey];
        
        [imageParamsArr addObject:paramsDic];
    }];
    return imageParamsArr;
}

+(NSString *)jsonStringFrom:(NSDictionary *)dic
{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (LDHTTPModel *)decorate:(LDHTTPModel *)model httpType:(LDHTTPType)httpType url:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSAssert(model != nil, @"网络请求model不能为nil");
    model.httpType = httpType;
    model.url = url;
    if (parameters) {
        NSString * token = parameters[kLDHTTPRequestTokenKey];
        if (token.length > 0) {
            model.token = token;
        }
        model.parameters = @{@"sign":[self jsonStringFrom:parameters]};
    }
    return model;
}

@end
