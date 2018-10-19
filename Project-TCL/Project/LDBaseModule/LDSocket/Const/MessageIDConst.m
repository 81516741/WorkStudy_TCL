//
//  LDSocketMessageIDTool.m
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "MessageIDConst.h"

NSString * const kConnecctServiceMessageIDPrefix = @"connect_service";
NSString * const kStartHandMessageIDPrefix = @"first_hand";
NSString * const kOpenSSLMessageIDPrefix = @"open_ssl";
NSString * const kEndHandMessageIDPrefix = @"second_hand";
NSString * const kHeartMessageIDPrefix = @"heart";
NSString * const kAutoLoginMessageIDPrefix = @"auto_login";
//登录模块的
NSString * const kGetCountMessageIDPrefix = @"login_getCount";
NSString * const kLoginMessageIDPrefix = @"login_log";
//首页模块的
NSString * const kGetConfigParamIDPrefix = @"home_getConfigParam";
NSString * const kGetDeviceListIDPrefix = @"home_getDeviceList";
NSString * const kGetSceneListIDPrefix = @"home_getSceneList";




NSString * getMessageID(NSString * messageIDPrefix) {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
    return [[NSString alloc] initWithFormat:@"%@-%@",messageIDPrefix,[[NSString alloc] initWithFormat:@"%ld",(long)currentTime]];
}
