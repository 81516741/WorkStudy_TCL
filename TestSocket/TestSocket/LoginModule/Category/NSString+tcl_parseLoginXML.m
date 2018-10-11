//
//  NSString+tcl_parseLoginXML.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "NSString+tcl_parseLoginXML.h"
#import "NSString+tcl_parseXML.h"

@implementation NSString (tcl_parseLoginXML)
@dynamic tcl_hostAndPort;
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
