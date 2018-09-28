//
//  LDSocketManager.h
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/3.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LDSocketManagerBlock)(NSData * data);
@interface LDSocketManager : NSObject
+ (instancetype)shared;
+ (NSString *)host;
+ (NSInteger)port;
+ (BOOL)connectServer:(NSString *)host port:(NSInteger) port success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure;
+ (void)sendMessage:(NSString *)message success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure;
+ (void)startSSL;
@end
