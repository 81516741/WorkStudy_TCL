//
//  LDHTTPTool+login.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDHTTPTool+login.h"

@implementation LDHTTPTool (login)

+ (void)getIPAndPortSuccess:(void (^)(LDHTTPModel *))success failure:(void (^)(LDHTTPModel *))failure
{
    NSLog(@"发送获取IP 和 端口的请求");
    LDHTTPModel * model = [LDHTTPModel new];
    model = [LDHTTPTool decorate:model httpType:LDHTTPTypeGet url:@"http://ds.zx.test.tcljd.net:8500/distribute-server/get_as_addr?method=get_as&clienttype=4&userid=2004050&replyproto=xml" parameters:nil];
    [LDHTTPTool sendModel:model success:success failure:failure];
}

@end
