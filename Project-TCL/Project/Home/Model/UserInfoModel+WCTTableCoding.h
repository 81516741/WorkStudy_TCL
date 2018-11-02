//
//  UserInfoModel+WCTTableCoding.h
//  Project
//
//  Created by lingda on 2018/10/26.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "UserInfoModel.h"
#import <WCDB/WCDB.h>

@interface UserInfoModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(apptype)
WCDB_PROPERTY(category)
WCDB_PROPERTY(head)
WCDB_PROPERTY(userid)
WCDB_PROPERTY(sendtime)
WCDB_PROPERTY(province)
WCDB_PROPERTY(area)
WCDB_PROPERTY(street)
WCDB_PROPERTY(masterid)
WCDB_PROPERTY(multiple)
WCDB_PROPERTY(birthday)
WCDB_PROPERTY(headurl)
WCDB_PROPERTY(clienttype)
WCDB_PROPERTY(city)
WCDB_PROPERTY(tel)
WCDB_PROPERTY(nickname)
WCDB_PROPERTY(country)
WCDB_PROPERTY(gender)
WCDB_PROPERTY(relationship)

@end
