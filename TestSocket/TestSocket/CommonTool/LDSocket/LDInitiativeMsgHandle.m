//
//  LDInitiativeMsgHandle.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDInitiativeMsgHandle.h"

NSString * const kGetConfigParamNotification = @"kGetConfigParamNotification";

@implementation LDInitiativeMsgHandle

void notiSendMsg(NSString * name,id obj) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
}

void notiReceiveMsg(id observer,SEL selector,NSString * name) {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:nil];
}

+ (BOOL)handleMessage:(NSString *)message {
    if ([message containsString:@"<configparam"]) {
        return YES;
    }
    return NO;
}
@end
