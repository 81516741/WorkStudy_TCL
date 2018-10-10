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

NSString * const kGetCountMessageIDPrefix = @"getCount";
NSString * const kLoginMessageIDPrefix = @"login";
NSString * const kGetConfigParamIDPrefix = @"getConfigParam";


NSString * getMessageID(NSString * messageIDPrefix) {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
    return [[NSString alloc] initWithFormat:@"%@-%@",messageIDPrefix,[[NSString alloc] initWithFormat:@"%ld",(long)currentTime]];
}
