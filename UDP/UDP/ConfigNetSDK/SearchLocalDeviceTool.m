//
//  SearchLocalDeviceTool.m
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import "SearchLocalDeviceTool.h"
#import "LocalUdpSocketManager.h"
#import "DeviceToNetTool.h"
#import "ToNetUtils.h"
#import "DeviceModel.h"
#import "LocalTclSocketManager.h"
#import <objc/runtime.h>

NSString * myResultTag = @"myResultTag";
NSString * blockIsExcuteKey = @"blockIsExcuteKey";

@interface SearchLocalDeviceTool()
@property(nonatomic,strong)LocalUdpSocketManager * udpManager;
@property(nonatomic,strong)dispatch_source_t timer;
@property(nonatomic,strong)NSMutableDictionary * deviceInfo;
@property(nonatomic,strong)NSMutableDictionary * resultDeviceBlockInfo;
@property(nonatomic,strong)NSMutableDictionary * resultSubDeviceBlockInfo;
@property(nonatomic,assign)NSInteger sendPacketCount;
@property (nonatomic , strong) SearchLocalDeviceConfig * config;
@end

@implementation SearchLocalDeviceTool
+ (instancetype)shared {
    static SearchLocalDeviceTool * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [SearchLocalDeviceTool new];
        _instance.deviceInfo = [NSMutableDictionary dictionary];
        _instance.resultDeviceBlockInfo = [NSMutableDictionary dictionary];
        _instance.resultSubDeviceBlockInfo = [NSMutableDictionary dictionary];
    });
    return _instance;
}
+ (void)configUdpSocket:(NSString *)host port:(NSString *)port {
    [[SearchLocalDeviceTool shared].udpManager configUdpSocket:host port:port bindPort:@"none"];
}
+ (void)configUdpSocket:(NSString *)host port:(NSString *)port bindPort:(NSString *)bindPort {
    [[SearchLocalDeviceTool shared].udpManager configUdpSocket:host port:port bindPort:bindPort];
}
+ (void)removeResultBloclByTag:(NSString *)tag {
    [[SearchLocalDeviceTool shared].resultDeviceBlockInfo removeObjectForKey:tag];
    [[SearchLocalDeviceTool shared].resultSubDeviceBlockInfo removeObjectForKey:tag];
}
+ (SearchLocalDeviceConfig *)config {
    return [[SearchLocalDeviceTool shared].config copy];
}
+ (void)changeSearchLocalDeviceToolConfigPropertyIsSendingPacketValue:(BOOL)value {
    [SearchLocalDeviceTool shared].config.isSendingPacket = value;
}
+ (void)changeSearchLocalDeviceToolConfig:(SearchLocalDeviceConfig *)config {
    [SearchLocalDeviceTool shared].config = config;
}
+ (void)startSearcheDevice:(SearchLocalDeviceConfig *)config result:(void(^)(id deviceInfo))result {
    [SearchLocalDeviceTool startSearcheDeviceTag:myResultTag config:config result:result];
}
+ (void)startSearcheDeviceTag:(NSString *)tag config:(SearchLocalDeviceConfig *)config result:(void(^)(id deviceInfo))result {
    [[SearchLocalDeviceTool shared] startSearcheDeviceTag:tag config:config result:result];
}
- (void)startSearcheDeviceTag:(NSString *)tag config:(SearchLocalDeviceConfig *)config result:(void(^)(id deviceInfo))result {
    NSAssert(tag.length > 0, @"搜索设备的tag不能为空");
    if ([DeviceToNetTool isConfiging] && ![tag isEqualToString:@"kConfigSearchDeviceBlockTag"]) {
        if (self.config.enableLog) {
            NSLog(@"----正在配网，无法开启设备搜索---");
        }
        return;
    }
    if (config != nil) {
        self.config = config;
    } else {
        self.config = [SearchLocalDeviceConfig config];
    }
    if (self.config.packet.length == 0) {
        if (self.config.enableLog) {
            NSLog(@"请配置udp包");
        }
        return;
    }
    if (result) {
        if ([self.config.packet containsString:@"searchDevice"]) {
            [self.resultDeviceBlockInfo setValue:result forKey:tag];
        } else if ([self.config.packet containsString:@"searchSubDevice"]) {
            [self.resultSubDeviceBlockInfo setValue:result forKey:tag];
        }
    }
    self.config.isSendingPacket = YES;
    if (self.timer == nil) {
      [self sendpackets];
    }
}

- (void)sendpackets {
    //1.定时发送udp包
    __weak typeof(self) selfWeak = self;
    self.timer = [ToNetUtils  startTimerAfter:0 interval:1 execute:^{
        NSString * currentWifiName = [ToNetUtils getCurrentWifiName];
//        if (currentWifiName.length == 0) {
//            if (self.config.enableLog) {
//                NSLog(@"未连接wifi 暂停发送udp包");
//            }
//            return ;
//        }
//        if ([DeviceToNetTool isDeviceHotpot:currentWifiName]) {
//            if (self.config.enableLog) {
//                NSLog(@"当前连接的是设备热点暂停发送udp包");
//            }
//            return ;
//        }
        if (!selfWeak.config.isSendingPacket) {
            if (self.config.enableLog) {
                NSLog(@"手动暂停发送udp包");
            }
            return ;
        }
        if (self.sendPacketCount % self.config.intervalSendPacket == 0) {
            if (self.config.enableLog) {
                NSLog(@"搜索本地设备发送消息：%@",selfWeak.config.packet);
            }
            if (self.SendPack) {
                self.SendPack();
            }
            [selfWeak.udpManager sendMsg:[NSString stringWithFormat:@"%d",selfWeak.sendPacketCount]];
        }
        selfWeak.sendPacketCount ++;
    }];
    //2.收到回包
    self.udpManager.messageHandle = ^(NSString * msg) {
        if (selfWeak.config.enableLog) {
            NSLog(@"搜索本地设备 回包：%@",msg);
        }
        [self.resultDeviceBlockInfo enumerateKeysAndObjectsUsingBlock:^(NSString * key, void(^block)(id deviceInfo), BOOL * stop) {
            block(msg);
            objc_setAssociatedObject(block, &blockIsExcuteKey, @"ok", OBJC_ASSOCIATION_RETAIN);
        }];
        //2.1 如果没有deivceID 这条消息就不是设备，如果当前wifiName为nil则不用后续操作
//        if ([msg containsString:@"<deviceInfo"] && [selfWeak.config.packet containsString:@"searchDevice"]) {
//            [selfWeak handleWifiDevice:msg];
//        } else if ([msg containsString:@"<subDeviceInfo"] && [selfWeak.config.packet containsString:@"searchSubDevice"]) {
//            [selfWeak handleSubDevice:msg];
//        }
    };
    //3.错误回包
    self.udpManager.errorHandle = ^(NSString * msg) {
        
    };
}

- (void)handleWifiDevice:(NSString *)msg {
    NSString * deviceID = [ToNetUtils get:msg subStringNear:@"<tid>" endStr:@"</"];
    NSString * wifiName = [ToNetUtils getCurrentWifiName];
    if (wifiName.length == 0) {
        return;
    }
    //根据当前wifiName获取该wifi下的所有已入网设备列表
    NSMutableArray * deviceList = [self getCurrentWifiDeviceList];
    //查看设备是否为重复设备
    for (DeviceModel * model in deviceList) {
        if ([model.tid isEqualToString:deviceID]) {
            [self.resultDeviceBlockInfo enumerateKeysAndObjectsUsingBlock:^(NSString * key, void(^block)(id deviceInfo), BOOL * stop) {
                if (objc_getAssociatedObject(block, &blockIsExcuteKey) == nil) {
                    block(deviceList);
                    objc_setAssociatedObject(block, &blockIsExcuteKey, @"ok", OBJC_ASSOCIATION_RETAIN);
                }
            }];
            return;
        }
    }
    //添加新搜到的设备
    DeviceModel * device = [self getModel:msg];
    if (self.config.enableLog) {
        NSLog(@"新设备-%@-%@",device.category,device.devMac);
    }
    [deviceList addObject:device];
    [self.resultDeviceBlockInfo enumerateKeysAndObjectsUsingBlock:^(NSString * key, void(^block)(id deviceInfo), BOOL * stop) {
        block(deviceList);
        objc_setAssociatedObject(block, &blockIsExcuteKey, @"ok", OBJC_ASSOCIATION_RETAIN);
    }];
}
- (void)handleSubDevice:(NSString *)msg {
    DeviceModel * device = [self getModel:msg];
    [self.resultSubDeviceBlockInfo enumerateKeysAndObjectsUsingBlock:^(NSString * key, void(^block)(id deviceInfo), BOOL * stop) {
        block(device);
    }];
}

- (DeviceModel *)getModel:(NSString *)msg {
    DeviceModel * device = [DeviceModel new];
    device.currentWifi = [ToNetUtils getCurrentWifiName];
    device.tid = [ToNetUtils get:msg subStringNear:@"<tid>" endStr:@"</"];;
    device.devName = [ToNetUtils get:msg subStringNear:@"<devName>" endStr:@"</"];
    device.category = [ToNetUtils get:msg subStringNear:@"<category>" endStr:@"</"];
    device.brand = [ToNetUtils get:msg subStringNear:@"<brand>" endStr:@"</"];
    device.company = [ToNetUtils get:msg subStringNear:@"<company>" endStr:@"</"];
    device.devMac = [ToNetUtils get:msg subStringNear:@"<devMac>" endStr:@"</"];
    device.devIP = [ToNetUtils get:msg subStringNear:@"<devIP>" endStr:@"</"];
    device.devPort = [ToNetUtils get:msg subStringNear:@"<devPort>" endStr:@"</"];
    device.resetFlag = [ToNetUtils get:msg subStringNear:@"<resetFlag>" endStr:@"</"];
    device.clientType = [ToNetUtils get:msg subStringNear:@"<clientType>" endStr:@"</"];
    device.version = [ToNetUtils get:msg subStringNear:@"<version>" endStr:@"</"];
    device.childcategory = [ToNetUtils get:msg subStringNear:@"<childcategory>" endStr:@"</"];
    device.eui64addr = [ToNetUtils get:msg subStringNear:@"<eui64addr>" endStr:@"</"];
    device.devicetype = [ToNetUtils get:msg subStringNear:@"<devicetype>" endStr:@"</"];
    device.hashStr = [ToNetUtils get:msg subStringNear:@"<hash>" endStr:@"</"];
    device.step = [ToNetUtils get:msg subStringNear:@"<step>" endStr:@"</"];
    device.randcode = [ToNetUtils get:msg subStringNear:@"<randcode>" endStr:@"</"];
    return device;
}
+ (void)stopSearchDevice {
    [[SearchLocalDeviceTool shared] stopSearchDevice];
}
- (void)stopSearchDevice {
    if ([DeviceToNetTool isConfiging]) {
        if (self.config.enableLog) {
            NSLog(@"----正在配网，无法停止设备搜索---");
        }
        return;
    }
    if (self.timer != nil) {
        if (self.config.enableLog) {
           NSLog(@"停止搜索本地已入网设备");
        }
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        [self.udpManager closeUdpSocket];
        self.udpManager.messageHandle = nil;
        self.udpManager.errorHandle = nil;
        self.udpManager = nil;
        self.sendPacketCount = 0;
        self.config = nil;
        [self.deviceInfo removeAllObjects];
        [self.resultDeviceBlockInfo removeAllObjects];
        [self.resultSubDeviceBlockInfo removeAllObjects];
        [DeviceToNetTool stopDeviceToNetProcess];
        [DeviceToNetTool stopSubDeviceToNetProcess];
    }
}

- (void)startSearchDevice {
    [self sendpackets];
}
+ (NSArray *)allDeviceList {
    return [[SearchLocalDeviceTool shared] getCurrentWifiDeviceList];
}
- (NSMutableArray *)getCurrentWifiDeviceList {
    NSString * wifiName = [ToNetUtils getCurrentWifiName];
    NSMutableArray * deviceList = [self.deviceInfo objectForKey:wifiName];
    if (deviceList == nil) {
        deviceList = [NSMutableArray array];
        [self.deviceInfo setObject:deviceList forKey:wifiName];
    }
    return deviceList;
}
- (LocalUdpSocketManager *)udpManager {
    if (_udpManager == nil) {
        _udpManager = [[LocalUdpSocketManager alloc] init];
        [_udpManager configUdpSocket:self.config.host port:self.config.port bindPort:@"none"];
    }
    return _udpManager;
}

@end

@implementation SearchLocalDeviceConfig
+ (instancetype)config {
    SearchLocalDeviceConfig * config = [[SearchLocalDeviceConfig alloc] init];
    return config;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.host = @"255.255.255.255";
        self.port = @"10075";
        self.packet = @"<searchDevice></searchDevice>";
        self.intervalSendPacket = 5;
        self.isSendingPacket = NO;
        self.enableLog = YES;
    }
    return self;
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    SearchLocalDeviceConfig * config = [SearchLocalDeviceConfig config];
    config.host = self.host;
    config.port = self.port;
    config.packet = self.packet;
    config.intervalSendPacket = self.intervalSendPacket;
    config.enableLog = self.enableLog;
    config.isSendingPacket = self.isSendingPacket;
    return config;
}

@end


