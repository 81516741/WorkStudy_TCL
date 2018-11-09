//
//  LDSocketTool.h
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/6.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDInitiativeMsgHandle.h"
extern NSString * const kLoginStateChangeNotification;
typedef void(^LDSocketToolBlock)(id data);

@protocol LDSocketDistributeProtocol

@optional
- (void)receiveLoginModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix messageError:(NSString *)messageError success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
- (void)receiveHomeModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix messageError:(NSString *)messageError success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;

@end
@interface LDSocketTool : NSObject<LDSocketDistributeProtocol>

@property (nonatomic,strong) NSMutableArray *  requestBlocks;
/**
 是否处于登录状态  0登录  1未登录
 */
@property(copy, nonatomic) NSString * loginState;
/**
 本地密码正确
 */
@property(assign, nonatomic) NSInteger autoLoginErrorCount;
/**
 自动登录是否失败 默认为YES
 */
@property(assign, nonatomic) BOOL isAutoLoginFailure;

+ (instancetype)shared;
+ (BOOL)connectServer:(NSString *)host port:(NSString *)port success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)sendMessage:(NSString *)message messageID:(NSString *)messageID success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)startConnectAndHeart;
+ (void)sendHearMessge;
#pragma mark - 工具方法 LDSocketTool分类也会用到的
+ (NSString *)dicToStr:(NSDictionary *)dic;
+ (NSDictionary *)strToDic:(NSString *)str;

@end


