//
//  LDDBTool+Base.m
//  Project
//
//  Created by 令达 on 2018/4/10.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool+Base.h"


@implementation LDDBTool (Base)

+ (BOOL)insert:(NSArray *)models
{
    NSString * tableName = [NSStringFromClass([models.lastObject class]) lowercaseString];
    BOOL isOK = [[LDDBTool share].database insertObjects:models into:tableName];
    if (isOK) {
        NSLog(@"向表:%@中插入数据 成功",tableName);
    } else {
        NSLog(@"向表:%@中插入数据 失败",tableName);
    }
    return isOK;
}

+ (BOOL)deleteAllObjects:(Class)modelClass
{
    NSString * tableName = [NSStringFromClass(modelClass) lowercaseString];
    BOOL isOK = [[LDDBTool share].database deleteAllObjectsFromTable:tableName];
    if (isOK) {
//        LDLog(@"删除表:%@中所有数据 成功",tableName);
    } else {
//        LDLog(@"删除表:%@中所有数据 失败",tableName);
    }
    return isOK;
}

+ (BOOL)deleteObject:(Class)modelClass where:(const WCTCondition &)condition
{
    NSString * tableName = [NSStringFromClass(modelClass) lowercaseString];
    BOOL isOK = [[LDDBTool share].database deleteObjectsFromTable:tableName where:condition];
    if (isOK) {
//        LDLog(@"删除表:%@中单个数据 成功",tableName);
    } else {
//        LDLog(@"删除表:%@中单个数据 失败",tableName);
    }
    return isOK;
}


+ (BOOL)update:(Class)modelClass
  onProperties:(const WCTPropertyList &)propertyList
    withObject:(WCTObject *)object
         where:(const WCTCondition &)condition
{
    NSString * tableName = [NSStringFromClass(modelClass) lowercaseString];
    BOOL isOK = [[LDDBTool share].database updateRowsInTable:tableName
                                                onProperties:propertyList
                                                  withObject:object
                                                       where:condition];
    if (isOK) {
//        LDLog(@"更新表:%@中数据 成功",tableName);
    } else {
//        LDLog(@"更新表:%@中数据 失败",tableName);
    }
    return isOK;
}

+ (BOOL)update:(Class)modelClass
  onProperties:(const WCTPropertyList &)propertyList
    withObject:(WCTObject *)object
{
    NSString * tableName = [NSStringFromClass(modelClass) lowercaseString];
    BOOL isOK = [[LDDBTool share].database updateAllRowsInTable:tableName onProperties:propertyList withObject:object];
    if (isOK) {
//        LDLog(@"更新表:%@中数据 成功",tableName);
    } else {
//        LDLog(@"更新表:%@中数据 失败",tableName);
    }
    return isOK;
}

+ (NSArray *)queryAllObjects:(Class)modelClass
{
    NSString * tableName = [NSStringFromClass(modelClass) lowercaseString];
    NSArray * models = [[LDDBTool share].database getAllObjectsOfClass:modelClass fromTable:tableName];
    return models;
}

+ (NSArray *)queryObjects:(Class)modelClass where:(const WCTCondition &)condition
{
    NSString * tableName = [NSStringFromClass(modelClass) lowercaseString];
    NSArray * models = [[LDDBTool share].database getObjectsOfClass:modelClass fromTable:tableName where:condition];
    return models;
}

@end
