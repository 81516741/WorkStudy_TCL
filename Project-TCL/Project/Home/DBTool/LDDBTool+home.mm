//
//  LDDBTool+home.m
//  Project
//
//  Created by lingda on 2018/10/17.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool+home.h"
#import "DeviceModel+WCTTableCoding.h"
#import "LDDBTool+Base.h"

@implementation LDDBTool (home)
+ (void)createHomeTables {
    [self createTable:DeviceModel.self];
}
+ (void)saveDeviceList:(NSArray *)deviceList {
    NSArray * deviceListCache = [self getDeviceList];
    if (deviceListCache.count > 0) {
        NSMutableArray * deviceListNew = [NSMutableArray array];
        for (DeviceModel * model in deviceList) {
            BOOL isNew = YES;
            for (DeviceModel * modelCache in deviceListCache) {
                if ([model.userid isEqualToString:modelCache.userid]) {
                    isNew = NO;
                    break;
                }
            }
            if (isNew) {
                [deviceListNew addObject:model];
            }
        }
        if (deviceListNew.count > 0) {
            [self insert:deviceListNew];
        }
    } else {
        [self insert:deviceList];
    }
    
}
+ (NSArray *)getDeviceList {
    return [self queryObjects:DeviceModel.self where:DeviceModel.licenseid == @"2004050"];
}
+ (void)clearnAllDevice {
    [self deleteAllObjects:DeviceModel.self];
}
@end
