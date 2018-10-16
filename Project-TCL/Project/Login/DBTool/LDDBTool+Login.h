//
//  LDDBTool+Login.h
//  Project
//
//  Created by 令达 on 2018/4/10.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool.h"
@class LDLoginModel;
@interface LDDBTool (Login)
/**
 创建模块A的所有数据库的表
 */
+ (void)createLoginTables;

+ (void)saveLoginModel:(LDLoginModel *)model;
+ (void)update:(Class)className name:(NSString *)name conditionName:(NSString *)conditionName;
+ (NSArray<LDLoginModel *> *)getLoginModels;
+ (void)clearnLoginModel;

@end
