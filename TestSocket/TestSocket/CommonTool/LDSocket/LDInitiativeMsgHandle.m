//
//  LDInitiativeMsgHandle.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDInitiativeMsgHandle.h"

NSString * const kGetParamNotification = @"kGetParamNotification";

@implementation LDInitiativeMsgHandle

void notiSendMsg(NSString * name,id obj) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
}

void notiReceiveMsg(id observer,SEL selector,NSString * name) {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:nil];
}

+ (void)handleMessage:(NSString *)msg {
    if ([msg containsString:@"<configparam"]) {
        //获取配置参数的消息
        notiSendMsg(kGetParamNotification, msg);
    }
}
@end
