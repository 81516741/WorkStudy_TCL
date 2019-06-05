//
//  TCLLocationManager.m
//  TclIntelliCom
//
//  Created by lingda on 2019/1/11.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import "TCLLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ToNetUtils.h"
@interface TCLLocationManager()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,strong)dispatch_source_t getDeviceLocationTimeOutTimer;
@property(nonatomic,copy)void (^getDeviceLocationResult)(NSString * latitude,NSString * longitude);
@end
@implementation TCLLocationManager
+ (instancetype)shared {
    static TCLLocationManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [TCLLocationManager new];
        _instance.locationManager = [[CLLocationManager alloc] init];
    });
    return _instance;
}

+ (void)getLocationInfo:(void (^)(NSString *, NSString *))result {
    [[TCLLocationManager shared] getLocationInfo:result];
}
- (void)getLocationInfo:(void (^)(NSString *, NSString *))result {
    //正在获取中
    if (self.getDeviceLocationResult) {
        return;
    }
    self.getDeviceLocationResult = result;
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if (@available(iOS 8.0, *)) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    } else {
        [self resetGetDeviceLocationProperty];
        return;
    }
    //超时
    self.getDeviceLocationTimeOutTimer = [ToNetUtils startTimerAfter:20 interval:509 execute:^{
        if (self.getDeviceLocationResult) {
            self.getDeviceLocationResult(@"", @"");
        }
        [self resetGetDeviceLocationProperty];
    }];
}
- (void)resetGetDeviceLocationProperty {
    if (self.getDeviceLocationTimeOutTimer) {
        dispatch_source_cancel(self.getDeviceLocationTimeOutTimer);
        self.getDeviceLocationTimeOutTimer = nil;
    }
    if (self.getDeviceLocationResult) {
        self.getDeviceLocationResult = nil;
    }
    [self.locationManager stopUpdatingLocation];
}
#pragma mark - delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.getDeviceLocationResult) {
        NSString * latitudeString = [NSString stringWithFormat:@"%f",[locations.lastObject coordinate].latitude];
        NSString * longitudeString = [NSString stringWithFormat:@"%f",[locations.lastObject coordinate].longitude];
        if (latitudeString.length > 0 && longitudeString.length > 0) {
            self.getDeviceLocationResult(latitudeString, longitudeString);
            [self resetGetDeviceLocationProperty];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.getDeviceLocationResult) {
        self.getDeviceLocationResult(@"", @"");
    }
    [self resetGetDeviceLocationProperty];
}
@end
