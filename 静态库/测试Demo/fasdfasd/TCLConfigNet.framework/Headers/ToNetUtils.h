//
//  ToNetUtils.h
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToNetUtils : NSObject
#pragma mark - tool method
+ (NSString *)getCurrentWifiName;
+ (dispatch_source_t)startTimerAfter:(NSTimeInterval)start interval:(NSTimeInterval)interval execute:(void(^)(void))excute;
+ (NSString *)get:(NSString *)str subStringNear:(NSString *) startStr  endStr:(NSString *)endStr;
+ (NSString *)randanCode;
@end
