//
//  LDNetTool.m
//  Project
//
//  Created by lingda on 2018/10/16.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDNetTool.h"
#import "LDHTTPManager.h"
@implementation LDNetTool
+ (BOOL)networkReachable {
    return [LDHTTPManager shared].networkReachable;
}
@end
