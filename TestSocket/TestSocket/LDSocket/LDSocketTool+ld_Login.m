//
//  LDSocketTool+ld_Login.m
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool+ld_Login.h"
#import "MessageIDConst.h"
#import "NSString+tcl_xml.h"
#import "ErrorCode.h"


@implementation LDSocketTool (ld_Login)
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
        @"joinid":@"f6hek6hdpt64jrw596",
        @"configversion":@"10307",
        @"lang":@"cn",
        @"devicetype":@"iPhone SE",
        @"company":@"TCLYJY",
        @"version":@"1.63",
        @"token":@"2ABAEAC2-027D-4CD4-AD1B-493434DC9CA3",
        @"type":@"TID",
        @"pwd":@"ba3da472cb1a59f523b87f74c4e42c860c2aa5d0"
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
    </iq>",messageID,@"2003232",passwordStr];
    
    [LDSocketTool sendMessage:message messageID:messageID success:success failure:failure];
}

- (void)receiveMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([messageIDPrefix isEqualToString:kGetCountMessageIDPrefix]) {
        if ([message.tcl_errorCode isEqualToString:@"0"]) {
            success(message.tcl_userID);
        } else {
            failure(getErrorDescription(message.tcl_errorCode));
        }
    } else if ([messageIDPrefix isEqualToString:kLoginMessageIDPrefix]) {
        if (message.tcl_loginErrorCode == nil) {
            success(nil);
        } else if ([message.tcl_loginErrorCode isEqualToString:@"401"]) {//认证失败
            failure(@"认证失败");
        } else if ([message.tcl_loginErrorCode isEqualToString:@"403"]) {//禁用
            failure(@"禁用");
        } else if ([message.tcl_loginErrorCode isEqualToString:@"404"]) {//账号不存在
            failure(@"账号不存在");
        } else if ([message.tcl_loginErrorCode isEqualToString:@"405"]) {//连续3次密码错误
            failure(@"连续3次密码错误");
        }
    }
}
@end
