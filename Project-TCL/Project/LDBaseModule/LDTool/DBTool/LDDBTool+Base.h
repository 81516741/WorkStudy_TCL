//
//  LDDBTool+Base.h
//  Project
//
//  Created by 令达 on 2018/4/10.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDDBTool.h"
#import <WCDB/WCDB.h>
@interface LDDBTool (Base)

+ (BOOL)insert:(NSArray *)models;

+ (BOOL)deleteAllObjects:(Class)modelClass;
+ (BOOL)deleteObject:(Class)modelClass where:(const WCTCondition &)condition;


+ (BOOL)update:(Class)modelClass
  onProperties:(const WCTPropertyList &)propertyList
    withObject:(WCTObject *)object;
+ (BOOL)update:(Class)modelClass
  onProperties:(const WCTPropertyList &)propertyList
    withObject:(WCTObject *)object
         where:(const WCTCondition &)condition;

+ (NSArray *)queryAllObjects:(Class)modelClass;
+ (NSArray *)queryObjects:(Class)modelClass where:(const WCTCondition &)condition;

@end
