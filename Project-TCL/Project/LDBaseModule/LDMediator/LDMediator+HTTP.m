//
//  LDMediator+HTTP.m
//  Project
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDMediator+HTTP.h"
NSString  * const kTargetLDHTTP = @"LDHTTP";
NSString  * const kActionNativeCancelAllHTTPRequest = @"nativeCancelAllHTTPRequest";

@implementation LDMediator (HTTP)
- (void)http_cancelAllHTTPRequest:(NSString *)VCName
{
    NSDictionary * params = @{@"VCName":VCName
                              };
    
    [self performTarget:kTargetLDHTTP
                                                    action:kActionNativeCancelAllHTTPRequest
                                                    params:params
                                         shouldCacheTarget:NO
                                        ];
}
@end
