//
//  DeviceModel.h
//  TclIntelliCom
//
//  Created by lingda on 2019/1/11.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel:NSObject;
@property(nonatomic,copy) NSString * tid;
@property(nonatomic,copy) NSString * devName;
@property(nonatomic,copy) NSString * category;
@property(nonatomic,copy) NSString * brand;
@property(nonatomic,copy) NSString * company;
@property(nonatomic,copy) NSString * devMac;
@property(nonatomic,copy) NSString * devIP;
@property(nonatomic,copy) NSString * devPort;
@property(nonatomic,copy) NSString * resetFlag;
@property(nonatomic,copy) NSString * clientType;
@property(nonatomic,copy) NSString * version;
@property(nonatomic,copy) NSString * childcategory;
@property(nonatomic,copy) NSString * eui64addr;
@property(nonatomic,copy) NSString * devicetype;
@property(nonatomic,copy) NSString * hashStr;
@property(nonatomic,copy) NSString * step;
@property(nonatomic,copy) NSString * randcode;

@property(nonatomic,copy) NSString * currentWifi;
@property(nonatomic,copy) NSString * longitude;
@property(nonatomic,copy) NSString * latitude;
@end
