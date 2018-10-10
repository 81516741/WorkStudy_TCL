//
//  Target_LDHTTP.m
//  Project
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "Target_LDHTTP.h"
#import "LDHTTPTool.h"
@implementation Target_LDHTTP

- (void)Action_nativeCancelAllHTTPRequest:(NSDictionary *)params;
{
    [LDHTTPTool cancelHTTPTasksByViewControllerName:params[@"VCName"]];
}
@end
