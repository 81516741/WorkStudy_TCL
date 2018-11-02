//
//  UserInfoModel.mm
//  Project
//
//  Created by lingda on 2018/10/26.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "UserInfoModel+WCTTableCoding.h"
#import "UserInfoModel.h"
#import <WCDB/WCDB.h>

@implementation UserInfoModel

WCDB_IMPLEMENTATION(UserInfoModel)

WCDB_SYNTHESIZE(UserInfoModel,apptype)
WCDB_SYNTHESIZE(UserInfoModel,category)
WCDB_SYNTHESIZE(UserInfoModel,head)
WCDB_SYNTHESIZE(UserInfoModel,userid)
WCDB_SYNTHESIZE(UserInfoModel,sendtime)
WCDB_SYNTHESIZE(UserInfoModel,province)
WCDB_SYNTHESIZE(UserInfoModel,area)
WCDB_SYNTHESIZE(UserInfoModel,street)
WCDB_SYNTHESIZE(UserInfoModel,masterid)
WCDB_SYNTHESIZE(UserInfoModel,multiple)
WCDB_SYNTHESIZE(UserInfoModel,birthday)
WCDB_SYNTHESIZE(UserInfoModel,headurl)
WCDB_SYNTHESIZE(UserInfoModel,clienttype)
WCDB_SYNTHESIZE(UserInfoModel,city)
WCDB_SYNTHESIZE(UserInfoModel,tel)
WCDB_SYNTHESIZE(UserInfoModel,nickname)
WCDB_SYNTHESIZE(UserInfoModel,country)
WCDB_SYNTHESIZE(UserInfoModel,gender)
WCDB_SYNTHESIZE(UserInfoModel,relationship)

@end
