//
//  HTTPManager.h
//  btc
//
//  Created by lingda on 2017/8/25.
//  Copyright © 2017年 btc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@class LDHTTPModel,LDHTTPUpdateTokenModel;
@interface LDHTTPManager : NSObject
@property (nonatomic,strong)  AFHTTPSessionManager * AFNHTTPManager;
@property (strong ,nonatomic) AFNetworkReachabilityManager * AFNNetwordManager;
/**
 * 单例
 */
+ (instancetype)shared;
/**
 * 发送HTTP网络请求
 */
- (void)sendMessage:(LDHTTPModel *)message success:(void (^)(LDHTTPModel * responseObject))success failure:(void (^)(LDHTTPModel * responseObject))failure;
/**
 * 取消请求
 */
- (void)cancelHTTPTask:(NSString *)taskDescription;


/**
 监听网络状态
 */
- (void)startMonitorNetworkState:(void (^)(AFNetworkReachabilityStatus status))block;

/**
 网络是否可以用
 */
@property (assign ,nonatomic)BOOL networkReachable;

//token过期重获token然后将之前的请求重发时用
@property (strong ,nonatomic)NSMutableArray<LDHTTPUpdateTokenModel *> * updateTokenRequests;
//当更新了token这里会设为yes，目前默认10分钟后自动设置为false
@property (assign ,nonatomic)BOOL updateToken;
@property (copy ,nonatomic)NSString * tokenNew;

@end
