//
//  LDDBTool+home.m
//  Project
//
//  Created by lingda on 2018/10/17.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool+home.h"
#import "LDDBTool+Base.h"
#import "LDDBTool+initiative.h"
#import "DeviceModel+WCTTableCoding.h"
#import "UserInfoModel+WCTTableCoding.h"
#import "SceneModel+WCTTableCoding.h"

@implementation LDDBTool (home)
+ (void)createHomeTables {
    [self createTable:DeviceModel.self];
    [self createTable:UserInfoModel.self];
    [self createTable:SceneModel.self];
}
+ (void)saveDeviceList:(NSArray *)deviceList {
    NSArray * deviceListCache = [self getDeviceList];
    if (deviceListCache.count > 0) {
        //去重并保存
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
        if (deviceList.count > 0) {
           [self insert:deviceList];
        }
    }
    
}
+ (NSArray *)getDeviceList {
    ConfigModel * model = [self getConfigModel];
    return [self queryObjects:DeviceModel.self where:DeviceModel.currentUserID == model.currentUserID];
}

+ (void)saveUserInfo:(UserInfoModel *)userInfoModel {
    [self deleteAllObjects:UserInfoModel.self];
    [self insert:@[userInfoModel]];
}

+ (UserInfoModel *)getUserInfoModel {
    return  [self queryAllObjects:UserInfoModel.self].lastObject;
}

+ (void)saveSceneModels:(NSArray *)sceneModels {
    NSArray * sceneModelsCache = [self getSceneModels];
    if (sceneModelsCache.count > 0) {
        //去重并保存
        NSMutableArray * sceneModelsNew = [NSMutableArray array];
        for (SceneModel * model in sceneModels) {
            BOOL isNew = YES;
            for (SceneModel * modelCache in sceneModelsCache) {
                if ([model.sid isEqualToString:modelCache.sid]) {
                    isNew = NO;
                    break;
                }
            }
            if (isNew) {
                [sceneModelsNew addObject:model];
            }
        }
        if (sceneModelsNew.count > 0) {
            [self insert:sceneModelsNew];
        }
    } else {
        if (sceneModels.count > 0) {
           [self insert:sceneModels];
        }
    }
}

+ (NSArray *)getSceneModels {
    ConfigModel * model = [self getConfigModel];
    return [self queryObjects:SceneModel.self where:SceneModel.currentUserID == model.currentUserID];
}

+ (void)clearnAllDevice {
    [self deleteAllObjects:DeviceModel.self];
    [self deleteAllObjects:UserInfoModel.self];
    [self deleteAllObjects:SceneModel.self];
}
@end
