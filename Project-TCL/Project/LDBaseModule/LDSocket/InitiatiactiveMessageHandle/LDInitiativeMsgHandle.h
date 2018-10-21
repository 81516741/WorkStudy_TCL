//
//  LDInitiativeMsgHandle.h
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//  这个类的作用是用来处理服务器主动推动的消息的，也处理自发请求回
//  的数据（如自动登录），也可以作为拦截器，处理一些消息

#import <Foundation/Foundation.h>

extern NSString * const kAutoLoginFailureNotification;

@interface LDInitiativeMsgHandle : NSObject

+ (BOOL)handleMessage:(NSString *)message messageID:(NSString *)messageID messageError:(NSString *)messageError;

@end
