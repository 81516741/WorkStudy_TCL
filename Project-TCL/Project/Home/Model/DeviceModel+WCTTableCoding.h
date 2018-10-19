//
//  DeviceModel+WCTTableCoding.h
//  Project
//
//  Created by lingda on 2018/10/17.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "DeviceModel.h"
#import <WCDB/WCDB.h>

@interface DeviceModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(userid)
WCDB_PROPERTY(regdate)
WCDB_PROPERTY(did)
WCDB_PROPERTY(company)
WCDB_PROPERTY(nickname)
WCDB_PROPERTY(devicetype)
WCDB_PROPERTY(ssid)
WCDB_PROPERTY(brand)
WCDB_PROPERTY(childctp)
WCDB_PROPERTY(headurl)
WCDB_PROPERTY(latitude)
WCDB_PROPERTY(category)
WCDB_PROPERTY(h5Version)
WCDB_PROPERTY(multiple)
WCDB_PROPERTY(appVersion)
WCDB_PROPERTY(thirdlabel)
WCDB_PROPERTY(accesskey)
WCDB_PROPERTY(ctrchannel)
WCDB_PROPERTY(localkey)
WCDB_PROPERTY(mac)
WCDB_PROPERTY(longitude)
WCDB_PROPERTY(nick)
WCDB_PROPERTY(head)
WCDB_PROPERTY(masterid)
WCDB_PROPERTY(bindtime)
WCDB_PROPERTY(categoryid)
WCDB_PROPERTY(licenseid)

@end
