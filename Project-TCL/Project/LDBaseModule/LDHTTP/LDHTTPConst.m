//
//  LDHTTPConst.m
//  Project
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHTTPConst.h"
NSString * const kLDHTTPImageUploadImageDataKey = @"";
NSString * const kLDHTTPImageUploadImageNameKey = @"";
NSString * const kLDHTTPImageUploadFileNameKey = @"";
NSString * const kLDHTTPImageUploadMimeTypeKey = @"";

#if IOS_TEST
NSString * const kLDHTTPDeviceDomainURL = @"http://io.zx.test.tcljd.net:8080/"; //测试版
#elif IOS_DEV
NSString * const kLDHTTPDeviceDomainURL = @"http://10.124.206.81:8500/"; //开发版
#else
NSString * const kLDHTTPDeviceDomainURL = @"http://io.zx.tcljd.com:8080/" ; //正式
#endif

NSString * http_realDevicePath(NSString * path) {
    NSString * localAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    if (localAddress.length <= 0) {
        localAddress = kLDHTTPDeviceDomainURL;
    }
    NSString * realPath = [localAddress stringByAppendingString:path];
    return realPath;
}

NSString * http_realServicePath(NSString * path) {
    NSString * localAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    if (localAddress.length <= 0) {
        localAddress = kLDHTTPDeviceDomainURL;
    }
    NSString * realPath = [localAddress stringByAppendingString:path];
    return realPath;
}


