//
//  HTTPManager.m
//  btc
//
//  Created by lingda on 2017/8/25.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDHTTPManager.h"
#import "LDHTTPModel.h"
#import "LDHTTPConst.h"

@implementation LDHTTPManager

- (void)sendMessage:(LDHTTPModel *)message success:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure
{
    switch (message.httpType) {
        case LDHTTPTypeGet:
            [self getMessage:message success:success failure:failure];
            break;
        case LDHTTPTypePost:
            [self postMessage:message success:success failure:failure];
            break;
        case LDHTTPTypeUploadImage:
            [self uploadImageMessage:message success:success failure:failure];
            break;
        default://默认get
            [self getMessage:message success:success failure:failure];
            break;
    }
    
}

- (void)getMessage:(LDHTTPModel *)message success:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure
{
    NSURLSessionDataTask * task = [self.AFNHTTPManager GET:message.url parameters:message.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        message.dataOrigin = responseObject;
        @try {
            if (success) {
                success(message);
            }
        } @catch (NSException *exception) {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        message.errorOfAFN = error;
        @try {
            if (failure) {
                failure(message);
            }
        } @catch (NSException *exception) {
        }
    }];
    task.taskDescription = message.taskDescription;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
}

- (void)postMessage:(LDHTTPModel *)message success:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure
{
    NSURLSessionDataTask * task = [self.AFNHTTPManager POST:message.url parameters:message.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        message.dataOrigin = responseObject;
        @try {
            if (success) {
                success(message);
            }
        } @catch (NSException *exception) {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        message.errorOfAFN = error;
        @try {
            if (failure) {
                failure(message);
            }
        } @catch (NSException *exception) {
        }
    }];
    task.taskDescription = message.taskDescription;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)uploadImageMessage:(LDHTTPModel *)message success:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure
{
    NSURLSessionDataTask * task = [self.AFNHTTPManager POST:message.url parameters:message.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary * imageDic in message.imageParameters) {
            [formData appendPartWithFileData:imageDic[kLDHTTPImageUploadImageDataKey] name:imageDic[kLDHTTPImageUploadImageNameKey] fileName:imageDic[kLDHTTPImageUploadFileNameKey] mimeType:imageDic[kLDHTTPImageUploadMimeTypeKey]];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度:%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        message.dataOrigin = responseObject;
        @try {
            if (success) {
                success(message);
            }
        } @catch (NSException *exception) {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        message.errorOfAFN = error;
        @try {
            if (failure) {
                failure(message);
            }
        } @catch (NSException *exception) {
        }
    }];
    task.taskDescription = message.taskDescription;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}


- (void)cancelHTTPTask:(NSString *)taskDescription
{
    for (NSURLSessionDataTask * task in self.AFNHTTPManager.tasks) {
        if ([task.taskDescription isEqualToString:taskDescription]) {
            [task cancel];
            NSLog(@"\n---取消了taskDescription为:%@ 的请求---",task.taskDescription);
        }
    }
}

#pragma mark - 网络监听
- (void)startMonitorNetworkState:(void (^)(AFNetworkReachabilityStatus status))block
{
    [[LDHTTPManager shared].AFNNetwordManager startMonitoring];
    [[LDHTTPManager shared].AFNNetwordManager setReachabilityStatusChangeBlock:block];
}

- (BOOL)networkReachable
{
    if ([LDHTTPManager shared].AFNNetwordManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 单例的初始方法
static LDHTTPManager * _instance;
+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.AFNHTTPManager = [AFHTTPSessionManager manager];
        _instance.AFNHTTPManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_instance.AFNHTTPManager.requestSerializer setTimeoutInterval:38];
        
        _instance.AFNNetwordManager = [AFNetworkReachabilityManager sharedManager];
        
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        _instance.AFNHTTPManager.securityPolicy = securityPolicy;
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (NSMutableArray<LDHTTPUpdateTokenModel *> *)updateTokenRequests
{
    if(_updateTokenRequests == nil){
        _updateTokenRequests = [NSMutableArray array];
    }
    return _updateTokenRequests;
    return nil;
}

- (void)setUpdateToken:(BOOL)updateToken
{
    _updateToken = updateToken;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * 10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.updateToken = false;
    });
}

@end
