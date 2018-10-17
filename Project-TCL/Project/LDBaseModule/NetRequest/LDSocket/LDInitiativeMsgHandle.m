//
//  LDInitiativeMsgHandle.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDInitiativeMsgHandle.h"
#import "GDataXMLNode.h"

NSString * const kGetConfigParamNotification = @"kGetConfigParamNotification";

@implementation LDInitiativeMsgHandle

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

+ (BOOL)handleMessage:(NSString *)message messageID:(NSString *)messageID messageError:(NSString *)messageError {
    if ([message containsString:@"<configparam"]) {
        [self handleConfigParamMessage:message];
        return YES;
    }
    return NO;
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
