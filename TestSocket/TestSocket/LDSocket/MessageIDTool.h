//
//  LDSocketMessageIDTool.h
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern  NSString * kConnecctServiceMessageIDPrefix;
extern  NSString * kStartHandMessageIDPrefix;
extern  NSString * kOpenSSLMessageIDPrefix;
extern  NSString * kEndHandMessageIDPrefix;
extern  NSString * kHeartMessageIDPrefix;
extern  NSString * kLoginMessageIDPrefix;

@interface MessageIDTool : NSObject
+ (NSString *)getMessageID:(NSString *)messageIDPrefix;
@end
