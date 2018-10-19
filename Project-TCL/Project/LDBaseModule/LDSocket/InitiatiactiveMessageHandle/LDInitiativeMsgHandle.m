//
//  LDInitiativeMsgHandle.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDInitiativeMsgHandle.h"
#import "GDataXMLNode.h"
#import "LDLogTool.h"
#import "ConfigModel.h"
#import "LDDBTool+initiative.h"
#import "NSString+tcl_parseXML.h"
#import <MJExtension/MJExtension.h>

NSString * const kGetConfigParamNotification = @"kGetConfigParamNotification";

@implementation LDInitiativeMsgHandle

+ (void)documentFromMessage:(NSString *)message block:(void(^)(GDataXMLDocument * doc))block {
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:message error:nil];
    if (doc == nil) {
        Log([NSString stringWithFormat:@"\n将下面的xml转化成document失败\n%@",message]);
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
    } else if ([message containsString:@"randcode"]) {
        if ([LDDBTool getConfigModel]) {
            NSString * randCode = [message tcl_subStringNear:@"<randcode>" endStr:@"</"];
            [LDDBTool updateConfigModelRandCode:randCode];
        }
        if (![message containsString:@"login_log"]) {
            //不含login_log代表是主动推的消息，含就是登录完成后，随登录成功回调一起返回的
            return YES;
        }
        
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
        Log([NSString stringWithFormat:@"获取配置参数\n%@",dic]);
        ConfigModel * model = [ConfigModel mj_objectWithKeyValues:dic];
        [LDDBTool saveConfigModel:model];
    }];
}

@end
