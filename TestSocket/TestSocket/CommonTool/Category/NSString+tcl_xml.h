//
//  NSString+tcl_xml.h
//  TestSocket
//
//  Created by lingda on 2018/9/30.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (tcl_xml)
- (NSString *)tcl_subStringNear:(NSString *) startStr  endStr:(NSString *)endStr;
//去掉空格键
@property(copy, nonatomic) NSString * tcl_noSpaceStr;
@property(copy, nonatomic) NSString * tcl_messageID;
@property(copy, nonatomic) NSString * tcl_errorCode;
@property(copy, nonatomic) NSString * tcl_loginErrorCode;
@property(copy, nonatomic) NSString * tcl_userID;
@property(strong, nonatomic) NSDictionary * tcl_hostAndPort;
@end
