//
//  DeviceModel.mm
//  Project
//
//  Created by lingda on 2018/10/17.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "DeviceModel+WCTTableCoding.h"
#import "DeviceModel.h"
#import <WCDB/WCDB.h>
#import <MJExtension/MJExtension.h>

@implementation DeviceModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"appVersion":@"version"};
}

WCDB_IMPLEMENTATION(DeviceModel)

WCDB_SYNTHESIZE(DeviceModel,userid);
WCDB_SYNTHESIZE(DeviceModel,regdate);
WCDB_SYNTHESIZE(DeviceModel,did);
WCDB_SYNTHESIZE(DeviceModel,company);
WCDB_SYNTHESIZE(DeviceModel,nickname);
WCDB_SYNTHESIZE(DeviceModel,devicetype);
WCDB_SYNTHESIZE(DeviceModel,ssid);
WCDB_SYNTHESIZE(DeviceModel,brand);
WCDB_SYNTHESIZE(DeviceModel,childctp);
WCDB_SYNTHESIZE(DeviceModel,headurl);
WCDB_SYNTHESIZE(DeviceModel,latitude);
WCDB_SYNTHESIZE(DeviceModel,category);
WCDB_SYNTHESIZE(DeviceModel,h5Version);
WCDB_SYNTHESIZE(DeviceModel,multiple);
WCDB_SYNTHESIZE(DeviceModel,appVersion);
WCDB_SYNTHESIZE(DeviceModel,thirdlabel);
WCDB_SYNTHESIZE(DeviceModel,accesskey);
WCDB_SYNTHESIZE(DeviceModel,ctrchannel);
WCDB_SYNTHESIZE(DeviceModel,localkey);
WCDB_SYNTHESIZE(DeviceModel,mac);
WCDB_SYNTHESIZE(DeviceModel,longitude);
WCDB_SYNTHESIZE(DeviceModel,nick);
WCDB_SYNTHESIZE(DeviceModel,head);
WCDB_SYNTHESIZE(DeviceModel,masterid);
WCDB_SYNTHESIZE(DeviceModel,bindtime);
WCDB_SYNTHESIZE(DeviceModel,categoryid);
@end

