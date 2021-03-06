//
//  LDSocketTool.h
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/6.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDInitiativeMsgHandle.h"

typedef void(^LDSocketToolBlock)(id data);

@protocol LDSocketDistributeProtocol

@optional
- (void)receiveLoginModuleMessage:(id)message messageIDPrefix:(NSString *)messageIDPrefix success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
- (void)receiveHomeModuleMessage:(id)message messageIDPrefix:(NSString *)messageIDPrefix success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;

@end



@interface LDSocketTool : NSObject<LDSocketDistributeProtocol>

@property (nonatomic,strong) NSMutableArray *  requestBlocks;

+ (instancetype)shared;
+ (BOOL)connectServer:(NSString *)host port:(NSString *)port success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)sendMessage:(NSString *)message messageID:(NSString *)messageID success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;

+ (void)sendHandshakeMessageSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)sendHeartMessageSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;

#pragma mark - 工具方法 LDSocketTool分类也会用到的
+ (NSString *)dicToStr:(NSDictionary *)dic;
+ (NSDictionary *)strToDic:(NSString *)str;

@end


