//
//  MQTTManager.m
//  SwiftData
//
//  Created by 吕哲明 on 2019/4/16.
//  Copyright © 2019 lingda. All rights reserved.
//

#import "MQTTManager.h"
@interface MQTTManager () <MQTTClientModelDelegate>
@property (nonatomic, copy) NSString* updataTopic;
@end
@implementation MQTTManager
+ (instancetype)sharedInstance {
    static MQTTManager *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[MQTTManager alloc]init];
        MQTTClientModelStance.delegate = user;
        MQTTClientModelStance.isTestServer = TRUE;
    });
    return user;
}

#pragma mark - 绑定
- (void)bindWithUserName:(NSString *)username password:(NSString *)password {
    
    [MQTTClientModelStance bindWithUserName:username password:password cliendId:nil isSSL:YES];
    
}

- (void)disconnect {
    [MQTTClientModelStance disconnect];
}

- (void)reConnect {
    if (MQTTClientModelStance.mySessionManager.state != MQTTSessionManagerStateConnected && MQTTClientModelStance.mySessionManager.state != MQTTSessionManagerStateConnecting) {
        [MQTTClientModelStance reConnect];
    }
    else {
        NSLog(@"已经连接，不需要重连");
    }
}


#pragma mark - 订阅topic
- (void)subscribeTopic:(NSString *)topic {
//    NSString *device_id = [PropertyUtil getCurrentDeviceID];
//    NSString * topicStr = [NSString stringWithFormat:@"/tsound/S1/event/%@",device_id];
//    [MQTTClientModelStance subscribeTopic:topicStr];
//    _updataTopic =topicStr;
    [MQTTClientModelStance subscribeTopic:topic];
}


#pragma mark - 取消订阅
- (void)unsubscribeTopic:(NSString *)topic {
//    [MQTTClientModelStance unsubscribeTopic:_updataTopic];
    [MQTTClientModelStance unsubscribeTopic:topic];
    
}

#pragma mark - 命令
//开关
- (void)sendDataWithDict:(NSDictionary *)dict{
    if (_myTopic.length<1) {
        NSLog(@" -------- Topic为空 --------");
        return;
    }
    [MQTTClientModelStance sendDataToTopic:_myTopic dict:dict];
}

#pragma mark - MQTTClientModelDelegate
- (void)MQTTClientModel_handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    
//    NSArray *array = [topic componentsSeparatedByString:@"/"];
    NSString *str = [[NSString alloc]initWithBytes:&(((UInt8 *)[data bytes])[0]) length:data.length encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [self dictionaryWithJsonString:str];
    NSLog(@"dict:%@ --------- \n",dict);
    
//    __weak typeof(self) weakSelf = self;
    //解析
    NSString * headerNotification = @"";
    NSDictionary * payloadDic =[NSDictionary new];
    if (dict[@"event"]) {
        NSDictionary *eventDic = dict[@"event"];
        if (eventDic[@"header"]) {
            NSDictionary *headerDic = eventDic[@"header"];
            if (headerDic[@"name"]&&headerDic[@"namespace"]) {
                headerNotification=[NSString stringWithFormat:@"%@/%@",headerDic[@"namespace"],headerDic[@"name"]];
            }
            if (eventDic[@"payload"]) {
                payloadDic =eventDic[@"payload"];
            }
        }
    }
    if (headerNotification.length<1&&[payloadDic count]==0) {
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:headerNotification object:payloadDic];
    }
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
