//
//  LDHTTPConst.m
//  Project
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHTTPConst.h"

NSString * const kLDHTTPDeviceDomainURL = @"http://io.zx.test.tcljd.net:8080/"; //测试版
//NSString * const kLDHTTPDomainURL = @"http://10.124.206.81:8500/"; //开发版
//NSString * const kLDHTTPDomainURL = @"http://io.zx.tcljd.com:8080/";  //正式
//
//#define ServiceURL             @"http://ds.zx.test.tcljd.net:8500/" //测试版          @"http://10.124.206.81:8500/" // @"http://up.zx.dev.tcljd.cn:8500/" //开发版
//#define ServiceURL             @"http://ds.zx.tcljd.com:8500/"  //正式


NSString * const kLDHTTPImageUploadImageDataKey = @"kHTTPImageUploadImageData";
NSString * const kLDHTTPImageUploadImageNameKey = @"kHTTPImageUploadImageName";
NSString * const kLDHTTPImageUploadFileNameKey = @"kHTTPImageUploadFileName";
NSString * const kLDHTTPImageUploadMimeTypeKey = @"kHTTPImageUploadMimeType";


NSString * http_realPath(NSString * path) {
    NSString * localAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    if (localAddress.length <= 0) {
        localAddress = kLDHTTPDeviceDomainURL;
    }
    NSString * realPath = [localAddress stringByAppendingString:path];
    return realPath;
}


