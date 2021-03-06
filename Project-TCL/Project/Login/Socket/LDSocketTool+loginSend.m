//
//  LDSocketTool+ld_Login.m
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool+loginSend.h"
#import "MessageIDConst.h"
#import "NSString+tcl_parseXML.h"
#import "ErrorCode.h"
#import "LDSysTool.h"
#import "NSString+ld_Security.h"
#import "LDDBTool+initiative.h"
#import "ConfigModel.h"
#import "LDLogTool.h"


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
    ConfigModel * configModel = [LDDBTool getConfigModel];
    NSString * configVersion = @"0";
    if (configModel.configversion.length > 0) {
        configVersion = configModel.configversion;
    }
    NSDictionary * dic = @{
                           @"joinid":[LDSysTool joinID],
                           @"configversion":configVersion,
                           @"lang":[LDSysTool languageType],
                           @"devicetype":[LDSysTool deviceType],
                           @"company":[LDSysTool company],
                           @"version":[LDSysTool version],
                           @"token":[LDSysTool UUIDString],
                           @"type":[LDSysTool TID],
                           @"pwd":password
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
        [self getCountByPhoneNum:num success:^(NSString * count) {
            [self login:count password:password.sha1String Success:^(id data) {
                [LDDBTool updateConfigModelCurrentUserID:count password:password.sha1String];
                if (success) {
                    success(data);
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
        [self login:num password:password.sha1String Success:^(id data) {
            Log(@"登录成功,更新账号和密码");
            [LDDBTool updateConfigModelCurrentUserID:num password:password.sha1String];
            if (success) {
                success(data);
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

@end
