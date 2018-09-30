//
//  LDSocketTool+ld_Login.m
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool+ld_Login.h"
#import "MessageIDTool.h"

@implementation LDSocketTool (ld_Login)
+ (void)loginSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure{
    NSString * messageID = [MessageIDTool getMessageID:kLoginMessageIDPrefix];
    NSString * message = [NSString stringWithFormat:@"\
    <?xml version=\"1.0\" encoding=\"utf-8\"?>\
    <iq type=\"set\" id=\"%@\">\
    <query xmlns=\"jabber:iq:auth\">\
    <username>2003232</username>\
    <resource>PH-ios-zx01-4</resource>\
    <password>\
    {\"joinid\":\"f6hek6hdpt64jrw596\",\
    \"configversion\":\"10307\",\
    \"lang\":\"cn\",\
    \"devicetype\":\"iPhone SE\",\
    \"company\":\"TCLYJY\",\
    \"version\":\"1.63\",\
    \"token\":\"2ABAEAC2-027D-4CD4-AD1B-493434DC9CA3\",\
    \"type\":\"TID\",\
    \"pwd\":\"ba3da472cb1a59f523b87f74c4e42c860c2aa5d0\"\
    }\
    </password>\
    </query>\
    </iq>",messageID];
    [LDSocketTool sendMessage:message messageID:messageID success:success failure:failure];
}

- (void)receiveMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([messageIDPrefix isEqualToString:kLoginMessageIDPrefix]) {
        
    }
}
@end
