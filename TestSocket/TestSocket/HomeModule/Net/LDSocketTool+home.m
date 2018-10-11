//
//  LDSocketTool+home.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool+home.h"
#import "MessageIDConst.h"
#import "LDSysTool.h"

@implementation LDSocketTool (home)

+ (void)getConfigParam {
    NSString * messageID = getMessageID(kGetConfigParamIDPrefix);
    NSString * message = [NSString stringWithFormat:@"\
                          <iq id=\"%@\" type=\"get\">\
                          <configparam xmlns=\" tcl:im:info\">\
                          <lang>%@</lang>\
                          </configparam>\
                          </iq>",messageID,[LDSysTool languageType]];
    [self sendMessage:message messageID:nil success:nil failure:nil];
    
}

+ (void)getDeviceListSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    NSString * messageID = getMessageID(kGetDeviceListIDPrefix);
    NSString * message = [NSString stringWithFormat:@"\
<message id=\"%@\" type=\"chat\" to=\"tcl.com\">\
  <body>\
    <msg cmd=\"getCtrDev\" type=\"common\" seq=\"%@\">\
        <getCtrDev>\
            <thirdlabel>jdiot</thirdlabel>\
        </getCtrDev>\
    </msg>\
  </body>\
  <x xmlns=\"tcl:im:attribute\">\
    <apptype>0</apptype>\
    <msgtype>1</msgtype>\
  </x>\
</message>",
    messageID,kGetDeviceListIDPrefix];
    [self sendMessage:message messageID:messageID success:success failure:failure];
}
- (void)receiveHomeModuleMessage:(id)message messageIDPrefix:(NSString *)messageIDPrefix success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([messageIDPrefix isEqualToString:kGetDeviceListIDPrefix]) {
        [self handleDeviceListMessage:message success:success failure:failure];
    }
}
- (void)handleDeviceListMessage:(NSString *)message success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if (success) {
        success(message);
    }
}
@end
