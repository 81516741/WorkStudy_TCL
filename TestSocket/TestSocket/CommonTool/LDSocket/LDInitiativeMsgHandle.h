//
//  LDInitiativeMsgHandle.h
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kGetConfigParamNotification;

void notiSendMsg(NSString * name,id obj);
void notiReceiveMsg(id observer,SEL selector,NSString * name);

@interface LDInitiativeMsgHandle : NSObject

+ (void)handleMessage:(NSString *)msg;

@end
