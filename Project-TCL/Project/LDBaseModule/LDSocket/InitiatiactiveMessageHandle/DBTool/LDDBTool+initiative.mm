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
    [LDDBTool clearnConfigModel];
    [LDDBTool insert:@[configModel]];
}
+ (void)updateConfigModelRandCode:(NSString *)randCode {
    ConfigModel * model = [ConfigModel new];
    model.randCode = randCode;
    [LDDBTool update:ConfigModel.self onProperties:ConfigModel.randCode withObject:model];
}
+ (void)updateConfigModelCurrentUserID:(NSString *)currentUserID {
    ConfigModel * model = [ConfigModel new];
    model.currentUserID = currentUserID;
    [LDDBTool update:ConfigModel.self onProperties:ConfigModel.currentUserID withObject:model];
}
+ (ConfigModel *)getConfigModel {
    return [LDDBTool queryAllObjects:ConfigModel.self].lastObject;
}
+ (void)clearnConfigModel {
    [LDDBTool deleteAllObjects:ConfigModel.self];
}
@end
