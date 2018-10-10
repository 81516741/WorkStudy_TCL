//
//  LDHTTPTool+login.h
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDHTTPTool.h"

@interface LDHTTPTool (login)

+ (void)getIPAndPortSuccess:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure;
@end
