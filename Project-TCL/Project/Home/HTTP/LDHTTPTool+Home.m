//
//  LDHTTPTool+Home.m
//  Project
//
//  Created by lingda on 2018/11/15.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHTTPTool+Home.h"
#import "H5DeviceURLModel.h"
#import "DeviceModel.h"
#import "NSString+str2Dic2str.h"
#import <MJExtension/MJExtension.h>

@implementation LDHTTPTool (Home)
/**
 获取设备控制页面的url
 */
+ (void)getDeviceCtrUrlByDevice:(DeviceModel *)device inVC:(UIViewController *)vc taskDes:(NSString *)taskDes Success:(void (^)(NSArray<H5DeviceURLModel *> *))success failure:(void (^)(NSString *))failure {
    NSString * url = http_realDevicePath([NSString stringWithFormat:@"app/getPageInfomation?did=%@&tid=%@&type=url",device.userid,device.currentUserID]);
    LDHTTPModel * model = [LDHTTPModel model:taskDes VCName:NSStringFromClass([vc class]) dataClass:nil];
    [self decorate:model httpType:LDHTTPTypeGet url:url parameters:nil];
    
    [self sendModel:model success:^(LDHTTPModel *responseObject) {
        NSArray * dataArr = ((NSString *)model.dataOrigin).toDic[@"menu_tree"];
        
        responseObject.data = [H5DeviceURLModel mj_objectArrayWithKeyValuesArray:dataArr];
        if (success) {
            success(responseObject.data);
        }
    } failure:^(LDHTTPModel *responseObject) {
        if (failure) {
            failure(@"获取失败");
        }
    }];
}
@end
