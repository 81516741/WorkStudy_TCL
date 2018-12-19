//
//  LDHTTPConst.h
//  Project
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef IOS_TEST    //测试环境
    #define IOS_TEST 1
#endif
#ifndef IOS_DEV     //开发环境
    #define IOS_DEV  0
#endif
#ifndef IOS_DIS      //发布环境
    #define IOS_DIS  0
#endif

extern NSString * const kLDHTTPDeviceDomainURL;

extern NSString * const kLDHTTPImageUploadImageDataKey;
extern NSString * const kLDHTTPImageUploadImageNameKey;
extern NSString * const kLDHTTPImageUploadFileNameKey;
extern NSString * const kLDHTTPImageUploadMimeTypeKey;

NSString * http_realDevicePath(NSString * path);
NSString * http_realServicePath(NSString * path);



