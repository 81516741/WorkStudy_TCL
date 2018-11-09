//
//  NSString+tcl_xml.h
//  TestSocket
//
//  Created by lingda on 2018/9/30.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (tcl_parseXML)

- (NSString *)tcl_subStringNear:(NSString *) startStr  endStr:(NSString *)endStr;
//去掉空格键
@property(copy, nonatomic) NSString * tcl_noSpaceStr;
@property(copy, nonatomic) NSString * tcl_messageID;
@property(copy, nonatomic) NSString * tcl_userID;
@property(copy, nonatomic) NSString * tcl_errorCode;
@property(copy, nonatomic) NSString * tcl_convertXML;
@property(copy, nonatomic) NSString * tcl_fromID;

//获取响应消息的状态（有些请求发送后，服务器会马上回个响应消息）
@property(copy, nonatomic) NSString * tcl_reportMsgStatus;
- (NSDictionary *)tcl_hostAndPort;
@end
