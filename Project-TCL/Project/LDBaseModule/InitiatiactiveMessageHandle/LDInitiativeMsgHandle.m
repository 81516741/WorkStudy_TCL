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
#import "LDSocketTool.h"
#import "ConfigModel.h"
#import "LDDBTool+initiative.h"
#import "NSString+tcl_parseXML.h"
#import <MJExtension/MJExtension.h>
#import "ErrorCode.h"
#import "MessageIDConst.h"

NSString * const kOtherDeviceLoginNotification = @"kOtherDeviceLoginNotification";
NSString * const kAutoLoginFailureNotification = @"kAutoLoginFailureNotification";



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
    if ([message containsString:kAutoLoginMessageIDPrefix]) {//自动登录消息的处理
        if ([messageError isEqualToString:errorCodeNone]) {
            [LDSocketTool shared].loginState = @"0";
            [LDSocketTool shared].autoLoginErrorCount = 0;
            Log(@"\n---自动登录成功---");
        } else {
            [LDSocketTool shared].isAutoLoginFailure = YES;
            [LDSocketTool shared].autoLoginErrorCount ++;
            Log([NSString stringWithFormat:@"\n---自动登录失败---%ld",(long)[LDSocketTool shared].autoLoginErrorCount]);
            //发出自动登录失败的通知，然后外部做处理
            if ([LDSocketTool shared].autoLoginErrorCount >= 3) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginFailureNotification object:nil];
            }
        }
        return YES;
    } else if ([message containsString:kLoginMessageIDPrefix]) {
        //登录成功需要修改一些参数，所以在这里拦截一下【拦截器作用】
        if ([messageError isEqualToString:errorCodeNone]) {
            [LDSocketTool shared].loginState = @"0";
            [LDSocketTool shared].autoLoginErrorCount = 0;
        }
        return NO;
    } else if ([message containsString:@"conflict"]) {
        //在别的设备登录了
        NSString * deviceName = [message tcl_subStringNear:@"connection::" endStr:@"</text>"];
        if (deviceName == nil) {
            deviceName = @"";
        }
        [LDDBTool updateConfigModelOtherDeviceLoginState:otherDeviceLogined];
        [[NSNotificationCenter defaultCenter] postNotificationName:kOtherDeviceLoginNotification object:deviceName];
    } else if ([message containsString:@"<configparam"]) {
        //全局配置参数
        [self handleConfigParamMessage:message];
        return YES;
    } else if ([message containsString:@"randcode"]) {
        //随机因子
        if ([LDDBTool getConfigModel]) {
            NSString * randCode = [message tcl_subStringNear:@"<randcode>" endStr:@"</"];
            [LDDBTool updateConfigModelRandCode:randCode];
        }
        if (![message containsString:@"login_log"]) {
            //不含login_log代表是主动推的消息，含就是登录完成后，随登录成功回调一起返回的
            return YES;
        }
        
    } else if ([message containsString:@"<message"]) {
        //消息的处理--TODO:这里有很多种类型的消息，需要分别处理
        [self documentFromMessage:message block:^(GDataXMLDocument *doc) {
            Log([NSString stringWithFormat:@"收到消息:%@",[doc.rootElement.children.firstObject stringValue]]);
        }];
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
