//
//  DeviceModel.h
//  Project
//
//  Created by lingda on 2018/10/17.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
/**
 这个id代表设备的拥有者的智讯id
 */
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * regdate;
@property (nonatomic , copy) NSString              * did;
@property (nonatomic , copy) NSString              * company;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * devicetype;
@property (nonatomic , copy) NSString              * ssid;
@property (nonatomic , copy) NSString              * brand;
@property (nonatomic , copy) NSString              * childctp;
@property (nonatomic , copy) NSString              * headurl;
@property (nonatomic , copy) NSString              * latitude;
@property (nonatomic , copy) NSString              * category;
@property (nonatomic , copy) NSString              * h5Version;
@property (nonatomic , copy) NSString              * multiple;
@property (nonatomic , copy) NSString              * appVersion;
@property (nonatomic , copy) NSString              * thirdlabel;
@property (nonatomic , copy) NSString              * accesskey;
@property (nonatomic , copy) NSString              * ctrchannel;
@property (nonatomic , copy) NSString              * localkey;
@property (nonatomic , copy) NSString              * mac;
@property (nonatomic , copy) NSString              * longitude;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , copy) NSString              * head;
@property (nonatomic , copy) NSString              * masterid;
@property (nonatomic , copy) NSString              * bindtime;
@property (nonatomic , copy) NSString              * categoryid;
/**
 当前用户的智讯id，用来标识该设备是该用户列表中的数据
 */
@property (nonatomic , copy) NSString              * currentUserID;

@end

