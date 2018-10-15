//
//  LDInitiativeMsgHandle.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDInitiativeMsgHandle.h"
#import <GDataXML_HTML/GDataXMLNode.h>

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
        [self handleConfigParamMessage:message];
        return YES;
    }
    return NO;
}

+ (void)documentFromMessage:(NSString *)message block:(void(^)(GDataXMLDocument * doc))block {
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:message error:nil];
    if (doc == nil) {
        NSLog(@"\n将下面的xml转化成document失败\n%@",message);
    } else {
        if (block) {
            block(doc);
        }
    }
}

+ (void)handleConfigParamMessage:(NSString *)message {
    [self documentFromMessage:message block:^(GDataXMLDocument * doc) {
        NSArray * arr = [doc.rootElement.children.firstObject children];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        for (GDataXMLElement * ele in arr) {
            [dic setValue:ele.stringValue forKey:ele.name];
        }
        NSLog(@"%@",dic);
    }];
}

@end
