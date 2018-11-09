//
//  LDDBTool+initiative.m
//  Project
//
//  Created by lingda on 2018/10/19.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool+initiative.h"
#import "LDDBTool+Base.h"
#import "ConfigModel+WCTTableCoding.h"
#import "LDLogTool.h"

@implementation LDDBTool (initiative)
+ (void)createInitiativeTables {
    [LDDBTool createConfigModelTable];
    
}
+ (void)clearnInitiativeTables {
    [LDDBTool clearnConfigModel];
}

+ (void)createConfigModelTable {
    [LDDBTool createTable:ConfigModel.self];
}
+ (void)saveConfigModel:(ConfigModel *)configModel {
    ConfigModel * localConfigModel = [LDDBTool getConfigModel];
    configModel.randCode = localConfigModel.randCode;
    configModel.currentUserID = localConfigModel.currentUserID;
    configModel.currentUserPassword = localConfigModel.currentUserPassword;
    [LDDBTool clearnConfigModel];
    [LDDBTool insert:@[configModel]];
}
+ (void)updateConfigModelRandCode:(NSString *)randCode {
    ConfigModel * model = [LDDBTool getConfigModel];
    if (model == nil) {
        model = [ConfigModel new];
        [LDDBTool insert:@[model]];
    }
    model.randCode = randCode;
    [LDLogTool Log:@"更新configModel的randCode"];
    [LDDBTool update:ConfigModel.self onProperties:ConfigModel.randCode withObject:model];
}
+ (void)updateConfigModelCurrentUserID:(NSString *)currentUserID password:(NSString *)password {
    ConfigModel * model = [LDDBTool getConfigModel];
    if (model == nil) {
        model = [ConfigModel new];
        [LDDBTool insert:@[model]];
    }
    model.currentUserID = currentUserID;
    model.currentUserPassword = password;
    WCTPropertyList propertyList;
    propertyList.push_front (ConfigModel.currentUserID);
    propertyList.push_front (ConfigModel.currentUserPassword);
    [LDLogTool Log:@"更新configModel的账号和密码"];
    [LDDBTool update:ConfigModel.self onProperties:propertyList withObject:model];
}

+ (void)updateConfigModelOtherDeviceLoginState:(OtherDeviceLoginState)state {
    [LDLogTool Log:@"更新configModel的otherDeviceLoginState"];
    ConfigModel * model = [ConfigModel new];
    model.otherDeviceLoginState = state;
    [LDDBTool update:ConfigModel.self onProperties:ConfigModel.otherDeviceLoginState withObject:model];
}

+ (ConfigModel *)getConfigModel {
    return [LDDBTool queryAllObjects:ConfigModel.self].lastObject;
}

+ (void)clearnConfigModel {
    [LDDBTool deleteAllObjects:ConfigModel.self];
}
@end
