//
//  NSString+tcl_xml.m
//  TestSocket
//
//  Created by lingda on 2018/9/30.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "NSString+tcl_xml.h"

@implementation NSString(tcl_xml)
@dynamic tcl_noSpaceStr,tcl_messageID,tcl_userID,tcl_errorCode;

- (NSString *)tcl_subStringNear:(NSString *) startStr  endStr:(NSString *)endStr {
    NSRange range = [self rangeOfString:startStr];
    NSString * handleStr;
    if (range.length > 0) {
        handleStr = [self substringFromIndex:range.location + startStr.length];
        range = [handleStr rangeOfString:endStr];
        handleStr = [handleStr substringToIndex:range.location];
    }
    return handleStr;
}

- (NSString *)tcl_noSpaceStr {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)tcl_messageID {
    NSString * str = [self.tcl_noSpaceStr tcl_subStringNear:@"id=\"" endStr:@"\""];
    return str;
}

- (NSString *)tcl_errorCode {
    NSString * str = [self.tcl_noSpaceStr tcl_subStringNear:@"<errorcode>" endStr:@"</"];
    return str;
}

- (NSString *)tcl_userID {
    NSString * str = [self.tcl_noSpaceStr tcl_subStringNear:@"<userid>" endStr:@"</"];
    return str;
}
@end
