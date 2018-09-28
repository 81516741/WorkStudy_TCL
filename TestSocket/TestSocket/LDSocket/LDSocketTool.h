//
//  LDSocketTool.h
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/6.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LDSocketToolBlock)(id data);
@interface LDSocketTool : NSObject
+ (BOOL)connectServer:(NSString *)host port:(NSString *)port success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)sendHandshakeMessageSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)sendHeartMessage;
@end
