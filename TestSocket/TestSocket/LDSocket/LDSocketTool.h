//
//  LDSocketTool.h
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/6.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LDSocketToolBlock)(id data);

@protocol LDSocketDistributeProtocol
@optional
- (void)receiveMessage:(id)message messageIDPrefix:(NSString *)messageIDPrefix success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
@end

@interface LDSocketTool : NSObject<LDSocketDistributeProtocol>

@property (nonatomic,strong) NSMutableDictionary *  requestBlocks;

+ (instancetype)shared;
+ (BOOL)connectServer:(NSString *)host port:(NSString *)port success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)sendMessage:(NSString *)message messageID:(NSString *)messageID success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;

+ (void)sendHandshakeMessageSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)sendHeartMessageSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;

@end
