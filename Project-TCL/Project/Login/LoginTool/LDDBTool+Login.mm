//
//  LDDBTool+Login.m
//  Project
//
//  Created by 令达 on 2018/4/10.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool+Login.h"
#import "LDDBTool+Base.h"
#import "LDLoginModel+WCTTableCoding.h"

@implementation LDDBTool (Login)

+ (void)createLoginTables
{
    [LDDBTool  createTable:LDLoginModel.class];
}

+ (void)saveLoginModel:(LDLoginModel *)model
{
    [LDDBTool insert:@[model]];
}

+ (NSArray<LDLoginModel *> *)getLoginModels
{
    return (NSArray<LDLoginModel *> *)[LDDBTool queryAllObjects:LDLoginModel.class];
}

+ (void)update:(Class)className name:(NSString *)name conditionName:(NSString *)conditionName
{
    LDLoginModel * model = [LDLoginModel new];
    model.name = name;
    WCTPropertyList propertyList;
    propertyList.push_front (LDLoginModel.name);
    [LDDBTool update:LDLoginModel.class onProperties:propertyList withObject:model where:LDLoginModel.name == conditionName];
}

+ (void)clearnLoginModel
{
    [LDDBTool deleteAllObjects:LDLoginModel.class];
}
@end
