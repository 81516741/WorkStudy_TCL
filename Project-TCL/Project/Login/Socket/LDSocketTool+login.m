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
        [self getCountByPhoneNum:num success:^(id count) {
            [self login:count password:password Success:^(id data) {
                NSLog(@"登录成功");
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
        [self login:num password:password Success:^(id data) {
            NSLog(@"登录成功");
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

- (void)receiveLoginModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix messageError:(NSString *)messageError success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([messageIDPrefix isEqualToString:kGetCountMessageIDPrefix]) {
        [self handleGetCountMessage:message errorDes:messageError success:success failure:failure];
    } else if ([messageIDPrefix isEqualToString:kLoginMessageIDPrefix]) {
        [self handleLoginMessage:message errorDes:messageError success:success failure:failure];
    }
}
- (void)handleGetCountMessage:(NSString *)message errorDes:(NSString *)errorDes success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([errorDes isEqualToString:errorDesSuccess]) {
        success(message.tcl_userID);
    } else {
        failure(errorDes);
    }
}

- (void)handleLoginMessage:(NSString *)message errorDes:(NSString *)errorDes success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([errorDes isEqualToString:errorDesSuccess]) {
        if (success) {
            success(errorDes);
        }
    } else {
        if (failure) {
            failure(errorDes);
        }
    }
}

@end
