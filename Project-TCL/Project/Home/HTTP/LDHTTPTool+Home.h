//
//  LDHTTPTool+Home.h
//  Project
//
//  Created by lingda on 2018/11/15.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHTTPTool.h"
@class DeviceModel,H5DeviceURLModel;
@interface LDHTTPTool (Home)
/**
 获取设备控制页面的url
 */
+ (void)getDeviceCtrUrlByDevice:(DeviceModel *)device inVC:(UIViewController *)vc taskDes:(NSString *)taskDes Success:(void (^)(NSArray<H5DeviceURLModel *> *))success failure:(void (^)(NSString *))failure;
@end
