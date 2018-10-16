//
//  LDSocketTool+ld_Login.m
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool+login.h"
#import "MessageIDConst.h"
#import "NSString+tcl_parseXML.h"
#import "ErrorCode.h"
#import "LDSysTool.h"
#import "NSString+ld_Security.h"


@implementation LDSocketTool (login)
+ (void)getCountByPhoneNum:(NSString *)phoneNum success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    NSString * messageID = getMessageID(kGetCountMessageIDPrefix);
    NSString * message = [NSString stringWithFormat:@"\
        <?xml version=\"1.0\" encoding=\"utf-8\"?>\
        <iq id=\"%@\" type=\"get\">\
            <bundling xmlns=\"jabber:iq:checkguide\">\
                <type>tel</type>\
                <username>%@</username>\
            </bundling>\
        </iq>",messageID,phoneNum];
    [LDSocketTool sendMessage:message messageID:messageID success:success failure:failure];
    
}

+ (void)login:(NSString *)userID password:(NSString *)password Success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    NSString * messageID = getMessageID(kLoginMessageIDPrefix);
    NSDictionary * dic = @{
        @"joinid":[LDSysTool joinID],
        @"configversion":@"10310",
        @"lang":[LDSysTool languageType],
        @"devicetype":[LDSysTool deviceType],
        @"company":[LDSysTool company],
        @"version":[LDSysTool version],
        @"token":[LDSysTool UUIDString],
        @"type":[LDSysTool TID],
        @"pwd":password.sha1String
                           };
    NSString * passwordStr = [LDSocketTool dicToStr:dic];
    
    NSString * message = [NSString stringWithFormat:@"\
    <?xml version=\"1.0\" encoding=\"utf-8\"?>\
    <iq type=\"set\" id=\"%@\">\
        <query xmlns=\"jabber:iq:auth\">\
           <username>%@</username>\
           <resource>PH-ios-zx01-4</resource>\
           <password>%@</password>\
        </query>\
    </iq>",messageID,userID,passwordStr];
    
    [LDSocketTool sendMessage:message messageID:messageID success:success failure:failure];
}

+ (void)loging:(NSString *)num password:(NSString *)password Success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if (num.length == 11) {
        [self getCountByPhoneNum:num success:^(id data) {
            [self login:data password:password Success:^(id data) {
                NSLog(@"登录成功");
                if (success) {
                    success(nil);
                }
            } failure:^(id data) {
                if (failure) {
                    failure(data);
                }
            }];
        } failure:^(id data) {
            if (failure) {
                failure(data);
            }
        }];
    } else if (num.length == 7) {
        [self login:num password:password Success:^(id data) {
            NSLog(@"登录成功");
            if (success) {
                success(nil);
            }
        } failure:^(id data) {
            if (failure) {
                failure(data);
            }
        }];
    } else {
        if (failure) {
            failure(@"请输入正确的账号");
        }
    }
}

- (void)receiveLoginModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([messageIDPrefix isEqualToString:kGetCountMessageIDPrefix]) {
        [self handleGetCountMessage:message success:success failure:failure];
    } else if ([messageIDPrefix isEqualToString:kLoginMessageIDPrefix]) {
        [self handleLoginMessage:message success:success failure:failure];
    }
}
- (void)handleGetCountMessage:(NSString *)message success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([message.tcl_errorCode isEqualToString:@"0"]) {
        success(message.tcl_userID);
    } else {
        failure(getErrorDescription(message.tcl_errorCode));
    }
}

- (void)handleLoginMessage:(NSString *)message success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if (message.tcl_errorCode == nil) {
        success(nil);
    } else if ([message.tcl_errorCode isEqualToString:@"401"]) {//认证失败
        failure(@"认证失败");
    } else if ([message.tcl_errorCode isEqualToString:@"403"]) {//禁用
        failure(@"禁用");
    } else if ([message.tcl_errorCode isEqualToString:@"404"]) {//账号不存在
        failure(@"账号不存在");
    } else if ([message.tcl_errorCode isEqualToString:@"405"]) {//连续3次密码错误
        failure(@"连续3次密码错误");
    } else {
        failure(@"未知错误");
    }
}

@end
