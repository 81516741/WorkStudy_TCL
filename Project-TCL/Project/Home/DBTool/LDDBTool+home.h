//
//  LDDBTool+home.h
//  Project
//
//  Created by lingda on 2018/10/17.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool.h"
@class UserInfoModel;
@interface LDDBTool (home)
+ (void)createHomeTables;

+ (void)saveDeviceList:(NSArray *)deviceList;
+ (NSArray *)getDeviceList;

+ (void)saveUserInfo:(UserInfoModel *)userInfoModel;
+ (UserInfoModel *)getUserInfoModel;

+ (void)saveSceneModels:(NSArray *)sceneModels;
+ (NSArray *)getSceneModels;

+ (void)clearnAllDevice;
@end
