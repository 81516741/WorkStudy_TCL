//
//  LDSocketMessageIDTool.m
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "MessageIDTool.h"

@implementation MessageIDTool 

NSString * kConnecctServiceMessageIDPrefix = @"connect_service";
NSString * kStartHandMessageIDPrefix = @"first_hand";
NSString * kOpenSSLMessageIDPrefix = @"open_ssl";
NSString * kEndHandMessageIDPrefix = @"second_hand";
NSString * kHeartMessageIDPrefix = @"heart";

NSString * kLoginMessageIDPrefix = @"login";

+ (NSString *)getMessageID:(NSString *)messageIDPrefix
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
    return [[NSString alloc] initWithFormat:@"%@-%@",messageIDPrefix,[[NSString alloc] initWithFormat:@"%ld",(long)currentTime]];
}
@end
