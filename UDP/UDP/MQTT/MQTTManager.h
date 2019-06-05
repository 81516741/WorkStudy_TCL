//
//  MQTTManager.h
//  SwiftData
//
//  Created by 吕哲明 on 2019/4/16.
//  Copyright © 2019 lingda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTClientModel.h"

#define MQTTManagerStance [MQTTManager sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface MQTTManager : NSObject

@property (nonatomic, copy) NSString* myTopic;

+ (instancetype)sharedInstance;


#pragma mark - 登录 解绑
- (void)bindWithUserName:(NSString *)username password:(NSString *)password;

- (void)disconnect;

- (void)reConnect;

#pragma mark - 订阅命令
/**
 订阅设备inf、res、sys三种topic
 */
- (void)subscribeTopic:(NSString *)topic;

#pragma mark - 取消订阅
/**
 取消订阅设备inf、res、sys三种topic
 */
- (void)unsubscribeTopic:(NSString *)topic;

#pragma mark - 传消息
- (void)sendDataWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
