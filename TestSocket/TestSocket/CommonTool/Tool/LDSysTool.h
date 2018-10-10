//
//  LDSysTool.h
//  TestSocket
//
//  Created by lingda on 2018/10/9.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDSysTool : NSObject
+ (NSString *)language ;
+ (NSString *)languageType;
+ (NSString *)version;
+ (NSString *)UUIDString;
+ (NSString *)company;
+ (NSString *)joinID;
+ (NSString *)deviceType;
+ (NSString *)TID;
@end
