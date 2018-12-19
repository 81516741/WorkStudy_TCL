//
//  H5DeviceURLModel.m
//  Project
//
//  Created by lingda on 2018/11/15.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "H5DeviceURLModel.h"
#import <MJExtension/MJExtension.h>

@implementation H5DeviceURLModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             @"des":@"description"
             };
}
@end
