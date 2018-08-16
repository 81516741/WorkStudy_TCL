//
//  LDHTTPConst.m
//  Project
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHTTPConst.h"

NSString * const kLDHTTPDomainURL = @"http://service.tunnel.qydev.com";

NSString * const kLDHTTPImageUploadImageDataKey = @"kHTTPImageUploadImageData";
NSString * const kLDHTTPImageUploadImageNameKey = @"kHTTPImageUploadImageName";
NSString * const kLDHTTPImageUploadFileNameKey = @"kHTTPImageUploadFileName";
NSString * const kLDHTTPImageUploadMimeTypeKey = @"kHTTPImageUploadMimeType";
NSString * const kLDHTTPRequestSimulatorString = @"Simulator";

NSString * const kLDHTTPRequestTokenKey = @"token";


NSString * http_realPath(NSString * path) {
    NSString * localAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    if (localAddress.length <= 0) {
        localAddress = kLDHTTPDomainURL;
    }
    NSString * realPath = [localAddress stringByAppendingString:path];
    return realPath;
}


