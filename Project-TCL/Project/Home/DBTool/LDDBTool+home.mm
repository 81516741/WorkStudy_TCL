//
//  LDDBTool+home.m
//  Project
//
//  Created by lingda on 2018/10/17.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool+home.h"
#import "DeviceModel.h"
#import "LDDBTool+Base.h"

@implementation LDDBTool (home)
+ (void)createHomeTables {
    [self createTable:DeviceModel.self];
}
+ (void)saveDeviceList:(NSArray *)deviceList {
    [self insert:deviceList];
}
+ (NSArray *)getLoginDeviceList {
    return [self queryAllObjects:DeviceModel.self];
}
+ (void)clearnAllDevice {
    [self deleteAllObjects:DeviceModel.self];
}
@end
