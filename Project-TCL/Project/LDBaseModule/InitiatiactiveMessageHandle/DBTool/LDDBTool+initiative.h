//
//  LDDBTool+initiative.h
//  Project
//
//  Created by lingda on 2018/10/19.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool.h"
#import "ConfigModel.h"

@interface LDDBTool (initiative)
+ (void)createInitiativeTables;
+ (void)clearnInitiativeTables;

+ (void)createConfigModelTable;
+ (void)saveConfigModel:(ConfigModel *)configModel;
+ (void)updateConfigModelRandCode:(NSString *)randCode;
+ (void)updateConfigModelCurrentUserID:(NSString *)currentUserID password:(NSString *)password;
+ (void)updateConfigModelOtherDeviceLoginState:(OtherDeviceLoginState)state;
+ (ConfigModel *)getConfigModel;
+ (void)clearnConfigModel;
@end
