//
//  LDInitiativeMsgHandle.h
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kGetConfigParamNotification;

@interface LDInitiativeMsgHandle : NSObject

+ (BOOL)handleMessage:(NSString *)message messageID:(NSString *)messageID messageError:(NSString *)messageError;

@end
