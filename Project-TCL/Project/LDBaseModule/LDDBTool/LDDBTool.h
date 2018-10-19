//
//  LDDBTool.h
//  MainArch_Example
//
//  Created by 令达 on 2018/3/27.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//


#import <UIKit/UIKit.h>
@class WCTDatabase;
@interface LDDBTool : NSObject
@property (strong ,nonatomic)WCTDatabase * database;
+ (instancetype)share;
+ (void)createTable:(Class)modelClass;
+ (void)createDatabaseAndAllTable;
+ (void)clearSomeUselessData;
@end

void userDefaultSet(id object,id key);
id userDefaultGet(id key);

