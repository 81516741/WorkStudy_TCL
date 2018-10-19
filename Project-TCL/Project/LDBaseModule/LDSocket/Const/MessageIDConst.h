//
//  LDSocketMessageIDTool.h
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern  NSString * const kConnecctServiceMessageIDPrefix;
extern  NSString * const kStartHandMessageIDPrefix;
extern  NSString * const kOpenSSLMessageIDPrefix;
extern  NSString * const kEndHandMessageIDPrefix;
extern  NSString * const kHeartMessageIDPrefix;
extern  NSString * const kAutoLoginMessageIDPrefix;

extern  NSString * const kLoginMessageIDPrefix;
extern  NSString * const kGetCountMessageIDPrefix;

extern  NSString * const kGetConfigParamIDPrefix;
extern  NSString * const kGetDeviceListIDPrefix;
extern  NSString * const kGetSceneListIDPrefix;

NSString * getMessageID(NSString * messageIDPrefix);

