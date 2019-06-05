//
//  TCLLocationManager.h
//  TclIntelliCom
//
//  Created by lingda on 2019/1/11.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCLLocationManager : NSObject
+ (void)getLocationInfo:(void(^)(NSString * latitude,NSString * longitude))result;
@end
