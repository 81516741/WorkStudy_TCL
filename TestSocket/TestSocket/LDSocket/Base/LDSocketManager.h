//
//  LDSocketManager.h
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/3.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LDSocketManager;
@protocol LDSocketManagerConnectProtocol <NSObject>
@optional
- (void)receiveConnectServiceResult:(id)result manager:(LDSocketManager *)manager;
@end

@protocol LDSocketManagerSendMessageProtocol <NSObject>
@optional
- (void)receiveMessageResult:(id)result manager:(LDSocketManager *)manager;
@end

@interface LDSocketManager : NSObject
+ (instancetype)shared;
+ (NSString *)host;
+ (NSInteger)port;
+ (BOOL)connectServer:(NSString *)host port:(NSInteger) port delegate:(id<LDSocketManagerConnectProtocol>)delegate;
+ (void)sendMessage:(NSString *)message delegate:(id<LDSocketManagerSendMessageProtocol>)delegate;
+ (void)startSSL;
@end
