//
//  NSString+tcl_xml.m
//  TestSocket
//
//  Created by lingda on 2018/9/30.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "NSString+tcl_parseXML.h"

@implementation NSString(tcl_parseXML)
@dynamic tcl_noSpaceStr,tcl_messageID,tcl_userID,tcl_errorCode,tcl_reportMsgStatus;

- (NSString *)tcl_subStringNear:(NSString *) startStr  endStr:(NSString *)endStr {
    NSRange range = [self rangeOfString:startStr];
    NSString * handleStr = nil;
    if (range.length > 0) {
        handleStr = [self substringFromIndex:range.location + startStr.length];
        range = [handleStr rangeOfString:endStr];
        handleStr = [handleStr substringToIndex:range.location];
    }
    return handleStr;
}

- (NSString *)tcl_noSpaceStr {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)tcl_messageID {
    NSString * str = self.tcl_noSpaceStr;
    /*1.目前发现登录请求返回的信息 是用 id = ""
    的样式来保存的*/
    NSString * str0 = [str tcl_subStringNear:@"id=\"" endStr:@"\""];
    /*2.目前发现的规律，如果str1 和 str2 都存在
    那么str2、的id是上一条信息的id*/
    NSString * str1 = [str tcl_subStringNear:@"msgid=\"" endStr:@"\""];
    NSString * str2 = [str tcl_subStringNear:@"messageid=\"" endStr:@"\""];
    //因为msgid 和 messageid都可以截出id 所以做下处理
    if ([str0 isEqualToString:str1] || [str0 isEqualToString:str2]) {
        str0 = nil;
    }
    if ([str0 containsString:@"-"]) {
        return str0;
    }
    if ([str1 containsString:@"-"]) {
        return str1;
    }
    if ([str2 containsString:@"-"]) {
        return str2;
    }
    
    if (str0.length > 0) {
        return str0;
    }
    if (str1.length > 0) {
        return str1;
    }
    if (str2.length > 0) {
        return str2;
    }
    return nil;
}

- (NSString *)tcl_errorCode {
    NSString * str1 = [self.tcl_noSpaceStr tcl_subStringNear:@"<errorcode>" endStr:@"</"];
    
    NSString * str2 = [self.tcl_noSpaceStr tcl_subStringNear:@"errorcode=\"" endStr:@"\""];
    if (str1.length > 0) {
        return str1;
    } else if (str2.length > 0) {
        return str2;
    }
    return nil;
}


- (NSString *)tcl_userID {
    NSString * str = [self.tcl_noSpaceStr tcl_subStringNear:@"<userid>" endStr:@"</"];
    return str;
}

- (NSString *)tcl_reportMsgStatus {
    NSString * str = [self.tcl_noSpaceStr tcl_subStringNear:@"status=\"" endStr:@"\""];
    return str;
}
- (NSDictionary *)tcl_hostAndPort {
    NSString * ip = [self.tcl_noSpaceStr tcl_subStringNear:@"<ip>" endStr:@"</"];
    if (ip.length == 0) {
        return nil;
    }
    NSString * port = [self.tcl_noSpaceStr tcl_subStringNear:@"<port>" endStr:@"</"];
    if (port.length == 0) {
        return nil;
    }
    NSString * errorcode = [self.tcl_noSpaceStr tcl_subStringNear:@"<errorcode>" endStr:@"</"];
    if (errorcode.length == 0) {
        errorcode = @"1";
    }
    return @{
             @"ip":ip,
             @"port":port,
             @"errorcode":errorcode
             };
}
@end
