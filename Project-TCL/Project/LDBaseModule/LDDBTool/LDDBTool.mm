//
//  LDDBTool.m
//  MainArch_Example
//
//  Created by 令达 on 2018/3/27.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "LDDBTool.h"
#import "LDDBTool+Base.h"
#import "LDMediator+Login.h"
#import "LDMediator+Home.h"
#import "LDDBTool+initiative.h"
#import "LDLogTool.h"

@implementation LDDBTool

+ (instancetype)share
{
    static LDDBTool * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LDDBTool new];
    });
    return _instance;
}

+ (void)createDatabase
{
    //获取沙盒根目录
    NSString *documentsWCDB = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WCDB"];
    // 文件路径
    NSString *filePath = [documentsWCDB stringByAppendingPathComponent:@"LDCacheData.sqlite"];
    [LDLogTool Log:[NSString stringWithFormat:@"\n-------【WCDB_path】-------\n%@",filePath]];
    [LDDBTool share].database = [[WCTDatabase alloc]initWithPath:filePath];
    
    // 数据库加密
    //    NSData *password = [@"btcProject" dataUsingEncoding:NSASCIIStringEncoding];
    //    [[DBTool share].database setCipherKey:password];
}

+ (void)createTable:(Class)modelClass
{
    NSString * tableName = [NSStringFromClass(modelClass) lowercaseString];
    if ([[LDDBTool share].database canOpen]) {
        // 创建方法
        BOOL isOK = [[LDDBTool share].database createTableAndIndexesOfName:tableName withClass:modelClass];
        if (isOK) {
            [LDLogTool Log:[NSString stringWithFormat:@"\n----------------创建成功table:%@ 成功--------\n",tableName]];
        } else {
            [LDLogTool Log:[NSString stringWithFormat:@"\n----------------创建成功table:%@ 失败--------\n",tableName]];
        }
    } else{
        [LDLogTool Log:@"\n----------------数据库打开失败--------\n"];
    }
}


+ (void)createDatabaseAndAllTable
{
    [LDDBTool createDatabase];
    [LDDBTool createInitiativeTables];
    [[LDMediator sharedInstance] login_createModuleLoginTables];
    [[LDMediator sharedInstance] home_createModuleLoginTables];
}

+ (void)clearSomeUselessData
{
    [LDDBTool clearnInitiativeTables];
    [[LDMediator sharedInstance] login_clearModuleLoginModels];
    [[LDMediator sharedInstance] home_clearModuleLoginModels];
}
@end


void userDefaultSet(id object,id key) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}
id userDefaultGet(id key) {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
