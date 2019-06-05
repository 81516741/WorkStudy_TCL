//
//  ToNetUtils.m
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import "ToNetUtils.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation ToNetUtils
#pragma mark - tool method
+(NSString *)getCurrentWifiName
{
    NSString *currentwifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    /**
     *  dictRef 中所有的key：值为CFStringRef类型
     *  1> BSSID(kCNNetworkInfoKeyBSSID)：路由器的Mac地址
     *  2> SSID(kCNNetworkInfoKeySSID)：WiFi的名称
     *  3> SSIDDATA(kCNNetworkInfoKeySSIDData)：转换成字符串打印出来是wifi名称
     */
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            //获取BSSID 、SSID、SSIDDATA
            currentwifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return currentwifiName;
}
+ (dispatch_source_t)startTimerAfter:(NSTimeInterval)start interval:(NSTimeInterval)interval execute:(void(^)(void))excute {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (excute) {
            excute();
        }
    });
    dispatch_resume(timer);
    return timer;
}
+ (NSString *)get:(NSString *)str subStringNear:(NSString *) startStr  endStr:(NSString *)endStr {
    NSRange range0 = [str rangeOfString:startStr];
    NSString * result = nil;
    if (range0.location != NSNotFound) {
        NSString * handleStr = [str substringFromIndex:range0.location + startStr.length];
        NSRange range1 = [handleStr rangeOfString:endStr];
        if (range1.location != NSNotFound) {
            handleStr = [handleStr substringToIndex:range1.location];
            result = handleStr;
        }
    }
    return result;
}
+ (NSString *)randanCode {
    int randNum = arc4random() % 1000000;
    NSString * randanCode = [NSString stringWithFormat:@"%d",randNum];
    int count0 = (int)(6 - randanCode.length);
    if (count0 > 0) {
        for (int i = 0; i < count0; i ++) {
            randanCode = [randanCode stringByAppendingString:@"0"];
        }
    }
    return randanCode;
}
@end
