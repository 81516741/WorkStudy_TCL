//
//  LocalSearchDeviceTool.h
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SearchLocalDeviceConfig;
@interface SearchLocalDeviceTool : NSObject
/**
 * 搜索手机所处wifi下的所有入网设备 传nil则为默认配置
 */
+ (void)startSearcheDevice:(SearchLocalDeviceConfig *)config result:(void(^)(id deviceInfo))result;
/**
 * 停止搜索设备
 */
+ (void)stopSearchDevice;
/**
 * 获取配置参数模型
 */
+ (SearchLocalDeviceConfig *)config;
/**
 * 获取搜索到的已入网设备
 */
+ (NSArray *)allDeviceList;
@end

@interface SearchLocalDeviceConfig : NSObject<NSCopying>
/**
 * 搜索设备广播的 host 默认 255.255.255.255
 */
@property (nonatomic , copy) NSString * host;
/**
 * 搜索设备广播端口 host 默认 10075
 */
@property (nonatomic , copy) NSString * port;
/**
 * 搜索设备广播的内容  默认<searchDevice></searchDevice>
 */
@property (nonatomic , copy) NSString * packet;
/**
 * 搜索设备广播内容发送的间隔时间  默认 5秒
 */
@property (nonatomic , assign) NSInteger intervalSendPacket;
/**
 * 是否开启打印日志 默认NO
 */
@property (nonatomic , assign) BOOL enableLog;
/**
 * 是否在发送广播 默认NO
 */
@property (nonatomic , assign) BOOL isSendingPacket;
/**
 * 快速获取配置对象
 */
+ (instancetype)config;
@end
