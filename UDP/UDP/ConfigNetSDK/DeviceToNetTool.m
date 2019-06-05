//
//  DeviceToNetTool.m
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import "DeviceToNetTool.h"
#import "ToNetUtils.h"
#import "LocalTclSocketManager.h"
#import <NetworkExtension/NEHotspotConfigurationManager.h>
#import "SearchLocalDeviceTool.h"
#import "TCLLocationManager.h"

#pragma mark - 这个操作是为了实现调用以下2个类方法，但是在别处是无法直接调用的目的 ...
@interface SearchLocalDeviceTool(tcl_extension)
+ (void)startSearcheDeviceTag:(NSString *)tag config:(SearchLocalDeviceConfig *)config result:(void(^)(id deviceInfo))result;
+ (void)changeSearchLocalDeviceToolConfigPropertyIsSendingPacketValue:(BOOL)value;
+ (void)changeSearchLocalDeviceToolConfig:(SearchLocalDeviceConfig *)config;
+ (void)removeResultBloclByTag:(NSString *)tag;
@end

NSString * kConfigSearchDeviceBlockTag = @"kConfigSearchDeviceBlockTag";
NSString * kConfigSearchSubDeviceBlockTag = @"kConfigSearchSubDeviceBlockTag";

BOOL enableLog = YES;
@interface DeviceToNetTool()
@property(nonatomic,strong)LocalTclSocketManager * tcpManager;
//已经配网成功的设备信息
@property(nonatomic,strong)DeviceModel * shouldReportDevice;
@property(nonatomic,copy)NSString * deviceUniqueFlag;//设备唯一标识
@property(nonatomic,copy)NSString * deviceWifiHotName;//设备热点
@property(nonatomic,copy)NSString * deviceType;//设备型号
@property(nonatomic,copy)NSString * deviceToNetWifiName;//设备需入网的wifi
@property(nonatomic,copy)NSString * deviceToNetWifiPassword;//设备需入网的wifi密码
@property(nonatomic,copy)NSArray<NSString *> * deviceHotpotRules;//设备的热点规则

//记录 searchLocalDeviceTool 的几个属性，用于恢复 searchLocalDeviceTool的原来状态
@property(nonatomic,strong)SearchLocalDeviceConfig * searchConfig;
@property(nonatomic,assign)BOOL isSaveSearchConfig;

//1-检测连接设备是否稳定的相关属性
@property(nonatomic,strong)dispatch_source_t checkSteadyTimer;
@property(nonatomic,strong)dispatch_source_t checkSteadyTimeOutTimer;
@property(nonatomic,assign)NSInteger checkSteadyCount;
@property(nonatomic,copy)void(^checkSteadyResult)(DeviceToNetPerStepState);
//2-tcp连接设备的相关属性
@property(nonatomic,copy)void(^connectDeviceResult)(DeviceToNetPerStepState);
@property(nonatomic,strong)dispatch_source_t connectDeviceTimeOutTimer;
@property(nonatomic,assign)NSInteger checkConnectDeviceCount;
//3-发送wifiName和password的相关属性
@property(nonatomic,copy)void(^sendWifiInfoToDeviceResult)(DeviceToNetPerStepState);
@property(nonatomic,strong)dispatch_source_t sendWifiInfoToTimeOutTimer;
//4-发送wifiName和password的相关属性
@property(nonatomic,copy)void(^reConnectedPreWifiResult)(BOOL,NSInteger);
@property(nonatomic,copy)BOOL(^isConnectedBlock)(DeviceToNetPerStepState);
@property(nonatomic,strong)dispatch_source_t reConnectedPreWifiTimeOutTimer;
@property(nonatomic,assign)NSInteger checkReConnectedCount;
@property(nonatomic,assign)NSInteger reConnectedServiceLastingSecond;
@property(nonatomic,assign)NSTimeInterval timerPreciseCheckInterval;
//5-检测设备是否上报服务器的相关属性
@property(nonatomic,copy)void(^deviceReportToServiceBlock)(DeviceModel *);
@property(nonatomic,strong)dispatch_source_t deviceReportToServiceTimeOutTimer;
//6-获取设备经纬度信息
@property(nonatomic,copy)void(^getDeviceLocationBlock)(DeviceModel *);
@property(nonatomic,strong)dispatch_source_t getDeviceLocationTimeOutTimer;
//网关子设备配网
@property(nonatomic,copy)void(^configSubDeviceToNetResult)(DeviceModel *);
@property(nonatomic,strong)dispatch_source_t configSubDeviceToNetTimeOutTimer;
@property (nonatomic , copy) NSString * randCode;

@end

@implementation DeviceToNetTool
+ (instancetype)shared {
    static DeviceToNetTool * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [DeviceToNetTool new];
        _instance.deviceHotpotRules = @[@"tcl_[a-zA-Z0-9]+_t\\*ap(.*)"];
        _instance.isSaveSearchConfig = NO;
    });
    return _instance;
}

#pragma mark  相关配置和对外提供的取值方法
+(NSString *)currentDeviceType {
    return [DeviceToNetTool shared].deviceType;
}
+ (BOOL)isConfiging {
    return [DeviceToNetTool shared].checkSteadyResult != nil ||
    [DeviceToNetTool shared].connectDeviceResult != nil||
    [DeviceToNetTool shared].sendWifiInfoToDeviceResult != nil ||
    [DeviceToNetTool shared].reConnectedPreWifiResult != nil ||
    [DeviceToNetTool shared].deviceReportToServiceBlock != nil ||
    [DeviceToNetTool shared].getDeviceLocationBlock != nil;
}
+ (void)configDeviceHotpotRules:(NSArray<NSString *> *)rule {
    [DeviceToNetTool shared].deviceHotpotRules = rule;
}
+(NSArray<NSString *> *) deviceHotpotRules {
    return [DeviceToNetTool shared].deviceHotpotRules;
}

+ (void)saveWifiNameAndPassword:(NSString *)wifiName password:(NSString *)password {
    [DeviceToNetTool shared].deviceToNetWifiName = wifiName;
    [DeviceToNetTool shared].deviceToNetWifiPassword = password;
}
+(NSString *) deviceToNetWifiName {
    return [DeviceToNetTool shared].deviceToNetWifiName;
}
+(NSString *) deviceToNetWifiPassword {
    return [DeviceToNetTool shared].deviceToNetWifiPassword;
}
+ (BOOL)isDeviceHotpot:(NSString *)maybeDeviceHotpot {
    for (NSString * rule in [DeviceToNetTool shared].deviceHotpotRules) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
        BOOL isMatch = [pre evaluateWithObject:maybeDeviceHotpot];
        if (isMatch) {
            return isMatch;
        }
    }
    return NO;
}
+(NSString *)deviceWifiHotName {
    return [DeviceToNetTool shared].deviceWifiHotName;
}
+ (void)enableLog:(BOOL)value {
    enableLog = value;
}
#pragma mark - Wifi设备配网
#pragma mark 第一步，检测连接设备热点是否稳定，稳定检测 15s超时
int step1TimeOutSecond = 15;
+ (void)checkDeviceWifiHotConnect:(void (^)(DeviceToNetPerStepState))result {
    [[DeviceToNetTool shared] checkDeviceWifiHotConnect:result];
}

- (void)checkDeviceWifiHotConnect:(void (^)(DeviceToNetPerStepState))result {
    if (enableLog) {
       NSLog(@"🚀🚀🚀🚀🚀配网第1步：稳定检测检测");
    }
    if (self.checkSteadyResult) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第1步：稳定检测检测 已在检测");
        }
        if (result) {
          result(DeviceToNetPerStepStateFailure);
        }
        return;
    }
    if (self.deviceToNetWifiName.length == 0 || self.deviceToNetWifiPassword.length == 0) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第1步：未配置路由器SSID和密码");
        }
        if (result) {
            result(DeviceToNetPerStepStateFailure);
        }
        return;
    }
    
    NSString * deviceHotpotName = [ToNetUtils getCurrentWifiName];
    BOOL isMatch = [DeviceToNetTool isDeviceHotpot:deviceHotpotName];
    if (!isMatch) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第1步：稳定检测 当前wifi->[%@]不是设备热点",deviceHotpotName);
        }
        if (result) {
            result(DeviceToNetPerStepStateFailure);
        }
        return;
    }
    NSArray * deviceHotComponents = [deviceHotpotName componentsSeparatedByString:@"_"];
    if (deviceHotComponents.count > 3) {
        self.deviceUniqueFlag = [deviceHotpotName componentsSeparatedByString:@"_"][3];
        self.deviceType = [deviceHotpotName componentsSeparatedByString:@"_"][1];
    } else {
        if (deviceHotComponents.count > 1) {
            self.deviceType = [deviceHotpotName componentsSeparatedByString:@"_"][1];
        }
        self.deviceUniqueFlag = nil;
    }
    if (self.deviceUniqueFlag != nil && self.deviceUniqueFlag.length != 6) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第1步：从设备热点中获取唯一标识失败");
        }
        if (result) {
            result(DeviceToNetPerStepStateFailure);
        }
        return;
    }
    self.searchConfig = [SearchLocalDeviceTool config];//保存属性，这里是copy
    self.isSaveSearchConfig = YES;
    [SearchLocalDeviceTool changeSearchLocalDeviceToolConfigPropertyIsSendingPacketValue:NO];
    self.checkSteadyResult = result;
    self.deviceWifiHotName = deviceHotpotName;
    self.checkSteadyTimer = [ToNetUtils startTimerAfter:1 interval:1 execute:^{
        NSString * currentWifiName = [ToNetUtils getCurrentWifiName];
        if ([currentWifiName isEqualToString:self.deviceWifiHotName]) {
            self.checkSteadyCount ++;
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第1步：稳定检测(%d)",(int)self.checkSteadyCount);
            }
        } else {
            self.checkSteadyCount = 0;
        }
        if (self.checkSteadyCount > 2) {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第1步：稳定检测检测成功");
            }
            [self callBackCheckSteadyResult:DeviceToNetPerStepStateSuccess];
        }
    }];
    //超时检测
    self.checkSteadyTimeOutTimer = [ToNetUtils startTimerAfter:step1TimeOutSecond interval:509 execute:^{
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第1步：稳定检测检测超时");
        }
        [self callBackCheckSteadyResult:DeviceToNetPerStepStateTimeOut];
    }];
}
- (void)callBackCheckSteadyResult:(DeviceToNetPerStepState)state {
    if (self.checkSteadyResult) {
        self.checkSteadyResult(state);
    }
    [self resetCheckDeviceWifiHotConnectProperty];
}
- (void)resetCheckDeviceWifiHotConnectProperty {
    if (self.checkSteadyTimer) {
        dispatch_source_cancel(self.checkSteadyTimer);
        self.checkSteadyTimer = nil;
    }
    if (self.checkSteadyTimeOutTimer) {
        dispatch_source_cancel(self.checkSteadyTimeOutTimer);
        self.checkSteadyTimeOutTimer = nil;
    }
    self.checkSteadyResult = nil;
    self.checkSteadyCount = 0;
}
#pragma mark 第二步，连接设备热点 20s超时
int step2TimeOutSecond = 20;
+ (void)connectToDeviceByHost:(NSString *)host port:(NSString *)port result:(void(^)(DeviceToNetPerStepState))result {
    [[DeviceToNetTool shared] connectToDeviceByHost:host port:port result:result];
}
- (void)connectToDeviceByHost:(NSString *)host port:(NSString *)port result:(void(^)(DeviceToNetPerStepState))result {
    if (enableLog) {
        NSLog(@"🚀🚀🚀🚀🚀配网第2步：连接设备热点");
    }
    //已经在连接中
    if (self.connectDeviceResult) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第2步：连接设备热点 已有请求正在连接设备");
        }
        return;
    }
    self.connectDeviceResult = result;
    __weak typeof(self) selfWeak = self;
    self.tcpManager.connectHandle = ^(BOOL connected) {
        if (connected) {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第2步：连接设备热点 【成功】");
            }
           [selfWeak callBackConnectDeviceResult:DeviceToNetPerStepStateSuccess];
        } else {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第2步： 断开连接Tcp连接");
            }
            if ([[ToNetUtils getCurrentWifiName] isEqualToString:selfWeak.deviceWifiHotName]) {
                if (enableLog) {
                    NSLog(@"🚀🚀🚀🚀🚀配网第2步：断开连接 重连Tcp连接");
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [selfWeak.tcpManager connectToHost:host port:port];
                });
                return ;
            }
           [selfWeak callBackConnectDeviceResult:DeviceToNetPerStepStateFailure];
        }
    };
    [self.tcpManager connectToHost:host port:port];
    
    //超时检测
    self.connectDeviceTimeOutTimer = [ToNetUtils startTimerAfter:1 interval:1 execute:^{
        self.checkConnectDeviceCount ++;
        if (self.checkConnectDeviceCount % 5 == 0) {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第2步：如果连接没有回应 每隔5秒连接一下设备");
            }
            [self.tcpManager connectToHost:host port:port];
        }
        if (self.checkConnectDeviceCount > step2TimeOutSecond) {
            [selfWeak callBackConnectDeviceResult:DeviceToNetPerStepStateTimeOut];
        }
    }];
}
- (void)callBackConnectDeviceResult:(DeviceToNetPerStepState)state {
    if (self.connectDeviceResult) {
        self.connectDeviceResult(state);
    }
    [self resetConnectToDeviceProperty];
}
- (void)resetConnectToDeviceProperty {
    self.connectDeviceResult = nil;
    if (self.connectDeviceTimeOutTimer) {
        dispatch_source_cancel(self.connectDeviceTimeOutTimer);
        self.connectDeviceTimeOutTimer = nil;
    }
    self.tcpManager.connectHandle = nil;
    self.checkConnectDeviceCount = 0;
}

#pragma mark 第三步发送wifi账号和密码 15s超时
int step3TimeOutSecond = 15;
+ (void)sendWifiNameAndPassword:(void(^)(DeviceToNetPerStepState state))result {
    NSString * msg = [NSString stringWithFormat:@"<setReq><ssid>%@</ssid><password>%@</password><setReq>",[DeviceToNetTool deviceToNetWifiName],[DeviceToNetTool deviceToNetWifiPassword]];
    [[DeviceToNetTool shared] sendWifiNameAndPassword:msg result:result];
}
- (void)sendWifiNameAndPassword:(NSString *)sendMsg result:(void(^)(DeviceToNetPerStepState state))result {
    if (enableLog) {
        NSLog(@"🚀🚀🚀🚀🚀配网第3步：发送WifiInfo");
    }
    //已经在发送中
    if (self.sendWifiInfoToDeviceResult) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第3步：发送WifiInfo 已经发送了请求");
        }
        return;
    }
    self.sendWifiInfoToDeviceResult = result;
    __weak typeof(self) selfWeak = self;
    self.tcpManager.messageHandle = ^(NSString *msg) {
        NSString * errorCode = [ToNetUtils get:msg subStringNear:@"<errcode>" endStr:@"</"];
        NSString * macStr = [ToNetUtils get:msg subStringNear:@"<mac>" endStr:@"</"];
        if (macStr.length == 17 ) {
            selfWeak.deviceUniqueFlag = [[[macStr uppercaseString] stringByReplacingOccurrencesOfString:@":" withString:@""] substringFromIndex:6];;
        }
        if ([errorCode isEqualToString:@"1"]) {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第3步：发送WifiInfo 设备入网成功【成功】");
            }
            [selfWeak callBackSendWifiInfoToDeviceResult:msg state:DeviceToNetPerStepStateSuccess];
        } else {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第3步：发送WifiInfo 设备入网失败【失败】");
            }
            [selfWeak callBackSendWifiInfoToDeviceResult:msg state: DeviceToNetPerStepStateFailure];
        }
    };
    [self.tcpManager sendMsg:sendMsg];
    //超时检测
    self.sendWifiInfoToTimeOutTimer = [ToNetUtils startTimerAfter:step3TimeOutSecond interval:509 execute:^{
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第3步：发送WifiInfo 超时【失败】");
        }
        [self callBackSendWifiInfoToDeviceResult:nil state:DeviceToNetPerStepStateTimeOut];
    }];
}
- (void)callBackSendWifiInfoToDeviceResult:(NSString *)msg state:(DeviceToNetPerStepState)state {
    if (self.sendWifiInfoToDeviceResult) {
        self.sendWifiInfoToDeviceResult(state);
    }
    [self resetSendWifiInfoToDeviceProperty];
}
- (void)resetSendWifiInfoToDeviceProperty {
    self.sendWifiInfoToDeviceResult = nil;
    if (self.sendWifiInfoToTimeOutTimer) {
        dispatch_source_cancel(self.sendWifiInfoToTimeOutTimer);
        self.sendWifiInfoToTimeOutTimer = nil;
    }
}
#pragma mark 第四步重连原来wifi的检测 60s超时
int step4TimeOutSecond = 60;
+ (void)checkIsReConnectedPreWifi:(void(^)(BOOL,NSInteger))result serviceTcpConnected:(BOOL(^)(DeviceToNetPerStepState))isConnectedBlock {
    [[DeviceToNetTool shared] checkIsReConnectedPreWifi:result serviceTcpConnected:isConnectedBlock];
}
- (void)checkIsReConnectedPreWifi:(void(^)(BOOL,NSInteger))result serviceTcpConnected:(BOOL(^)(DeviceToNetPerStepState))isConnectedBlock {
    if (enableLog) {
        NSLog(@"🚀🚀🚀🚀🚀配网第4步：重连原来wifi的检测");
    }
    //正在重连检测中
    if (self.reConnectedPreWifiResult) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第4步：重连原来wifi的检测 已经在检测");
        }
        return;
    }
    [DeviceToNetTool connectWifi:self.deviceToNetWifiName password:self.deviceToNetWifiPassword complement:nil];
    self.reConnectedPreWifiResult = result;
    self.isConnectedBlock = isConnectedBlock;
    //超时检测
    self.reConnectedPreWifiTimeOutTimer = [ToNetUtils startTimerAfter:0 interval:1 execute:^{
        [self checkIsReConnectedPreWifi];
        [self checkIsReConnectedPreWifiAndService];
        [self checkIsReConnectedPreWifiTimeOut];
    }];
}
+ (void)connectWifi:(NSString *)wifiName password:(NSString *)password complement:(void(^)(NSString *))handle{
    if (@available(iOS 11.0, *)) {
        NSLog(@"iOS11系统主动连接已知Wifi");
        // 创建将要连接的WIFI配置实例
        NEHotspotConfiguration * hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:wifiName passphrase:password isWEP:NO];
        // 开始连接 (调用此方法后系统会自动弹窗确认)
        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
            NSString * errorDes = error.description;
            if (errorDes.length > 0) {
                NSLog(@"调用ios11的api连接原来的wifi错误：%@",errorDes);
            }
            if ([[ToNetUtils getCurrentWifiName] isEqualToString:wifiName]) {
                errorDes = nil;
            } else if (errorDes.length == 0) {
                errorDes = @"未知错误";
            }
            if (handle) {
                handle(errorDes);
            }
        }];
    }
}
//检测一下是否连回原来的wifi
- (void) checkIsReConnectedPreWifi {
    NSString * currentWifiName = [ToNetUtils getCurrentWifiName];
    if ([currentWifiName isEqualToString:self.deviceToNetWifiName]) {
        if (self.reConnectedPreWifiResult) {
            if (enableLog) {
                NSLog(@"%@",[NSString stringWithFormat:@"🚀🚀🚀🚀🚀配网第4步：重连原来wifi的检测 已经连接回原来的wifi：%@",self.deviceToNetWifiName]);
            }
            self.reConnectedPreWifiResult(YES,self.checkReConnectedCount);
        }
    } else {
        if (self.reConnectedPreWifiResult) {
            if (enableLog) {
                NSLog(@"%@",[NSString stringWithFormat:@"🚀🚀🚀🚀🚀配网第4步：重连原来wifi的检测 请连接原来的wifi：%@",self.deviceToNetWifiName]);
            }
            self.reConnectedPreWifiResult(NO,self.checkReConnectedCount);
        }
    }
}
//每隔1秒检测一下是否在原来的wifi下连接上了服务器
- (void)checkIsReConnectedPreWifiAndService {
    NSString * currentWifiName = [ToNetUtils getCurrentWifiName];
    if (self.isConnectedBlock &&
        self.isConnectedBlock(DeviceToNetPerStepStateNone) &&
        [currentWifiName isEqualToString:self.deviceToNetWifiName]) {
        //这一段是为了保证timer确实是走了4秒，因为在后台timer是不会停的，当回到前台，会连续调用
        NSTimeInterval currentInterval = [NSDate timeIntervalSinceReferenceDate];
        if (currentInterval - self.timerPreciseCheckInterval > 0.9) {
            self.reConnectedServiceLastingSecond ++;
            if (enableLog) {
                NSLog(@"%@", [NSString stringWithFormat:@"🚀🚀🚀🚀🚀配网第4步：重连原来wifi的检测 检测是否处于原来Wifi且已经连接上了服务器 %d 次",(int)self.reConnectedServiceLastingSecond]);
            }
        }
        self.timerPreciseCheckInterval = currentInterval;
        
        //连接上了 且稳定的检测
        if (self.reConnectedServiceLastingSecond > 3) {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第4步：重连原来wifi的检测 成功在原来wifi下连上服务器【成功】");
            }
            self.isConnectedBlock(DeviceToNetPerStepStateSuccess);
            [self resetReConnectedPreWifiProperty];
        }
    } else {
        self.reConnectedServiceLastingSecond = 0;
    }
}
//超时检测
- (void)checkIsReConnectedPreWifiTimeOut {
    self.checkReConnectedCount ++;
    if (self.checkReConnectedCount > step4TimeOutSecond) {
        if (self.isConnectedBlock) {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第4步：重连原来wifi的检测 超时【失败】");
            }
            self.isConnectedBlock(DeviceToNetPerStepStateTimeOut);
        }
        [self resetReConnectedPreWifiProperty];
    }
}

//重置 重连原来wifi的检测的属性
- (void)resetReConnectedPreWifiProperty {
    self.reConnectedPreWifiResult = nil;
    self.isConnectedBlock = nil;
    if (self.reConnectedPreWifiTimeOutTimer) {
        dispatch_source_cancel(self.reConnectedPreWifiTimeOutTimer);
        self.reConnectedPreWifiTimeOutTimer = nil;
    }
    self.checkReConnectedCount = 0;
    self.reConnectedServiceLastingSecond = 0;
}

#pragma mark 第五步检测设备是否上报服务器 90s超时
int step5TimeOutSecond = 90;
+ (void)checkDeviceIsReportToService:(NSString *)randcode result:(void(^)(DeviceModel *))block {
    [[DeviceToNetTool shared] checkDeviceIsReportToServiceSearchPacket:randcode result:block];
}
- (void)checkDeviceIsReportToServiceSearchPacket:(NSString *)randcode result:(void(^)(DeviceModel *))block {
    NSAssert(block != nil, @"checkDeviceIsReportToService的result不能为nil");
    if (enableLog) {
        NSLog(@"🚀🚀🚀🚀🚀配网第5步：检测设备是否上报服务器");
    }
    //正在检测中
    if (self.deviceReportToServiceBlock) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第5步：检测设备是否上报服务器 已经在检测");
        }
        return;
    }
    self.shouldReportDevice = nil;
    self.deviceReportToServiceBlock = block;
    self.deviceReportToServiceTimeOutTimer = [ToNetUtils startTimerAfter:step5TimeOutSecond interval:509 execute:^{
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第5步：检测设备是否上报服务器 超时【失败】");
        }
        [self callBackCheckDeviceIsReportToService:nil state:DeviceToNetPerStepStateTimeOut];
    }];
    [self checkDeviceMacMatch:randcode];
}
- (void)setSearchConfig:(SearchLocalDeviceConfig *)searchConfig {
    _searchConfig = searchConfig;
    if(searchConfig == nil) {
        NSLog(@"");
    }
}
- (void)checkDeviceMacMatch:(NSString *)randcode {
    if (self.deviceReportToServiceBlock) {
        NSString * packet = @"<searchDevice\"></searchDevice>";
        if (self.deviceUniqueFlag.length > 0) {
            packet = [NSString stringWithFormat:@"<searchDevice devid=\"%@\" randcode=\"%@\"></searchDevice>",self.deviceUniqueFlag,randcode];
        }
        SearchLocalDeviceConfig * config = [SearchLocalDeviceConfig new];
        config.packet = packet;
        config.intervalSendPacket = 5;
        config.enableLog = enableLog;
        [SearchLocalDeviceTool startSearcheDeviceTag:kConfigSearchDeviceBlockTag config:config result:^(id deviceInfo) {
            if ([deviceInfo isKindOfClass:NSArray.class]) {
                for (DeviceModel * model in deviceInfo) {
                    NSString * searchDeviceMac = [[[model.devMac uppercaseString] stringByReplacingOccurrencesOfString:@":" withString:@""] substringFromIndex:6];
                    if ([searchDeviceMac isEqualToString:self.deviceUniqueFlag]) {
                        if (enableLog) {
                            NSLog(@"🚀🚀🚀🚀🚀配网第5步：检测设备是否上报服务器 【成功】");
                        }
                        self.shouldReportDevice = model;
                        [self callBackCheckDeviceIsReportToService:model state:DeviceToNetPerStepStateSuccess];
                        return;
                    }
                }
            }
        }];
    }
}
- (void)callBackCheckDeviceIsReportToService:(DeviceModel *)deviceInfo state:(DeviceToNetPerStepState)state {
    if (self.deviceReportToServiceBlock) {
        if (state == DeviceToNetPerStepStateSuccess) {
            self.deviceReportToServiceBlock(deviceInfo);
        } else {
            self.deviceReportToServiceBlock(nil);
        }
    }
    [SearchLocalDeviceTool removeResultBloclByTag:kConfigSearchDeviceBlockTag];
    [SearchLocalDeviceTool changeSearchLocalDeviceToolConfigPropertyIsSendingPacketValue:NO];
    [self resetDeviceIsReportToServiceProperty];
}

- (void)resetDeviceIsReportToServiceProperty {
    self.deviceReportToServiceBlock = nil;
    if (self.deviceReportToServiceTimeOutTimer) {
        dispatch_source_cancel(self.deviceReportToServiceTimeOutTimer);
        self.deviceReportToServiceTimeOutTimer = nil;
    }
}

#pragma mark  第六步获取设备经纬信息 15s超时
int step6TimeOutSecond = 15;
+ (void)getDeviceLocationInfo:(void(^)(DeviceModel * device))block {
    [[DeviceToNetTool shared] getDeviceLocationInfo:block];
}

- (void)getDeviceLocationInfo:(void(^)(DeviceModel * device))block {
    if (enableLog) {
        NSLog(@"🚀🚀🚀🚀🚀配网第6步：获取设备经纬信息");
    }
    //正在获取
    if (self.getDeviceLocationBlock) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀配网第6步：获取设备经纬信息  已经在获取");
        }
        return;
    }
    self.getDeviceLocationBlock = block;
    [TCLLocationManager getLocationInfo:^(NSString *latitude, NSString *longitude) {
        if (self.getDeviceLocationBlock) {
            if (latitude.length > 0 && longitude.length > 0) {
                if (enableLog) {
                    NSLog(@"🚀🚀🚀🚀🚀配网第6步：获取设备经纬信息 【成功】");
                }
                self.shouldReportDevice.latitude = latitude;
                self.shouldReportDevice.longitude = longitude;
                [self callBackGetDeviceLocation:self.shouldReportDevice];
            } else {
                if (enableLog) {
                    NSLog(@"🚀🚀🚀🚀🚀配网第6步：获取设备经纬信息 【失败】");
                }
                [self callBackGetDeviceLocation:self.shouldReportDevice];
            }
            
        }
    }];
    //超时
    self.getDeviceLocationTimeOutTimer = [ToNetUtils startTimerAfter:step6TimeOutSecond interval:509 execute:^{
        if (self.getDeviceLocationBlock) {
            if (enableLog) {
                NSLog(@"🚀🚀🚀🚀🚀配网第6步：获取设备经纬信息 【超时】");
            }
            [self callBackGetDeviceLocation:self.shouldReportDevice];
            
        }
    }];
}
- (void)callBackGetDeviceLocation:(DeviceModel *)device {
    if (self.getDeviceLocationBlock) {
        self.getDeviceLocationBlock(device);
    }
    [self stopDeviceToNetProcess];
}
- (void)resetGetDeviceLocationProperty {
    self.getDeviceLocationBlock = nil;
    if (self.getDeviceLocationTimeOutTimer) {
        dispatch_source_cancel(self.getDeviceLocationTimeOutTimer);
        self.getDeviceLocationTimeOutTimer = nil;
    }
}
#pragma mark -----停止Wifi设备配网-----
+ (void)stopDeviceToNetProcess {
    [[DeviceToNetTool shared] stopDeviceToNetProcess];
}
- (void)stopDeviceToNetProcess {
    if (enableLog) {
        NSLog(@"🚀🚀🚀🚀🚀配网 停止配网");
    }
    //1.稳定检测的属性reset
    [self resetCheckDeviceWifiHotConnectProperty];
    //2.连接设备的属性reset
    [self resetConnectToDeviceProperty];
    //3.发送WifiInfo属性reset
    [self resetSendWifiInfoToDeviceProperty];
    //4.重连原来wifi属性reset
    [self resetReConnectedPreWifiProperty];
    //5.设备是否上报步骤属性reset
    [self recoverySearchLocalDeviceToolProperty];
    [self resetDeviceIsReportToServiceProperty];
    //6.获取设备经纬度信息步骤属性reset
    [self resetGetDeviceLocationProperty];
    //清理工作
    self.deviceUniqueFlag = nil;
    [self stopDeviceTcp];
    [self clearWifiInfo];
}
- (void)stopDeviceTcp {
    [self.tcpManager disconnect];
}
- (void)clearWifiInfo {
    _deviceWifiHotName = nil;
    _deviceToNetWifiName = nil;
    _deviceToNetWifiPassword = nil;
}
- (void)recoverySearchLocalDeviceToolProperty {
    if (self.isSaveSearchConfig) {
        if (self.searchConfig == nil) {
            [SearchLocalDeviceTool changeSearchLocalDeviceToolConfig:nil];
        } else {
            [SearchLocalDeviceTool changeSearchLocalDeviceToolConfigPropertyIsSendingPacketValue:self.searchConfig.isSendingPacket];
            [SearchLocalDeviceTool changeSearchLocalDeviceToolConfig:self.searchConfig];
        }
        self.isSaveSearchConfig = NO;
    }
}

#pragma mark - 网关子设备配网
int subDeviceToNetTimeOutCount = 58;
+ (void)startSubDeviceToNet:(NSString *)gateWayID result:(void (^)(DeviceModel *))block {
    [[DeviceToNetTool shared] startSubDeviceToNet:gateWayID result:block];
}
- (void)startSubDeviceToNet:(NSString *)gateWayID result:(void (^)(DeviceModel *))block {
    if (enableLog) {
        NSLog(@"🚀🚀🚀🚀🚀网关子设备配网  开始配网");
    }
    NSAssert(block != nil, @"startConfigSubDeviceToNet的block不能为nil");
    if ([DeviceToNetTool isConfiging]) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀网关子设备配网  wifi设备正在配网，无法同时子设备配网");
        }
        return;
    }
    if (self.configSubDeviceToNetResult) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀网关子设备配网  正在配网...");
        }
        return;
    }
    self.configSubDeviceToNetResult = block;
    self.randCode = [ToNetUtils randanCode];
    self.searchConfig = [SearchLocalDeviceTool config];//保存属性，这里是copy
    SearchLocalDeviceConfig * config = [SearchLocalDeviceConfig new];
    NSString * packet = [NSString stringWithFormat:@"<searchSubDevice randcode=\"%@\" gatewayid=\"%@\"></searchSubDevice>",self.randCode,gateWayID];
    config.packet = packet;
    config.enableLog = enableLog;
    config.intervalSendPacket = 1;
    [SearchLocalDeviceTool startSearcheDeviceTag:kConfigSearchSubDeviceBlockTag config:config result:^(DeviceModel * device) {
        [self callbackConfigSubDeviceToNetResult:device];
    }];
    self.configSubDeviceToNetTimeOutTimer = [ToNetUtils startTimerAfter:subDeviceToNetTimeOutCount interval:509 execute:^{
        [self callbackConfigSubDeviceToNetResult:nil];
    }];
}
- (void)callbackConfigSubDeviceToNetResult:(DeviceModel *)model {
    if (self.configSubDeviceToNetResult) {
        if (model == nil) {
            NSLog(@"🚀🚀🚀🚀🚀网关子设备配网  配网超时");
            self.configSubDeviceToNetResult(model);
            [self stopSubDeviceToNetProcess];
        } else {
            if (![self.randCode isEqualToString:model.randcode]) {
                NSLog(@"🚀🚀🚀🚀🚀网关子设备配网  搜到的设备不是目标设备");
                return;
            }
            self.configSubDeviceToNetResult(model);
            if (model.step.length > 0) {//新网关设备
                if ([model.step isEqualToString:@"3"]) {
                    NSLog(@"🚀🚀🚀🚀🚀网关子设备配网  新网关设备配网成功");
                    [self stopSubDeviceToNetProcess];
                }
            } else {//旧网关设备
                NSLog(@"🚀🚀🚀🚀🚀网关子设备配网  旧网关设备配网成功");
                [self stopSubDeviceToNetProcess];
            }
        }
    }
}
+ (void)stopSubDeviceToNetProcess {
    [[DeviceToNetTool shared] stopSubDeviceToNetProcess];
}
- (void)stopSubDeviceToNetProcess {
    if (self.configSubDeviceToNetTimeOutTimer) {
        dispatch_source_cancel(self.configSubDeviceToNetTimeOutTimer);
        self.configSubDeviceToNetTimeOutTimer = nil;
    }
    if (self.configSubDeviceToNetResult) {
        if (enableLog) {
            NSLog(@"🚀🚀🚀🚀🚀网关子设备配网  停止配网");
        }
        if (self.searchConfig == nil) {
            [SearchLocalDeviceTool changeSearchLocalDeviceToolConfig:nil];
        } else {
            [SearchLocalDeviceTool changeSearchLocalDeviceToolConfig:self.searchConfig];
            [SearchLocalDeviceTool removeResultBloclByTag:kConfigSearchSubDeviceBlockTag];
        }
        self.configSubDeviceToNetResult = nil;
    }
}
#pragma mark - 懒加载
- (LocalTclSocketManager *)tcpManager {
    if (_tcpManager == nil) {
        _tcpManager = [[LocalTclSocketManager alloc] init];
    }
    return _tcpManager;
}
@end
