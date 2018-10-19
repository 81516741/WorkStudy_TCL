//
//  LDSocketTool+home.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool+homeSend.h"
#import "MessageIDConst.h"
#import "LDDBTool+initiative.h"
#import "ConfigModel.h"

@implementation LDSocketTool (homeSend)

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

+ (void)getSceneListSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    ConfigModel * model = [LDDBTool getConfigModel];
    NSString * messageID = getMessageID(kGetSceneListIDPrefix);
    NSString * message = [NSString stringWithFormat:@"\
<iq id=\"%@\" type=\"get\" from=\"%@@tcl.com/PH-ios-zx01-4\">\
    <getscenesbyuserid xmlns=\"iot:smart:scene\"></getscenesbyuserid>\
</iq>",messageID,model.currentUserID];
    [self sendMessage:message messageID:messageID success:success failure:failure];
}

@end
