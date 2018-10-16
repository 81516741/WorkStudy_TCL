//
//  LDHTTPConst.h
//  Project
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kLDHTTPDomainURL;
extern NSString * const kLDHTTPImageUploadImageDataKey;
extern NSString * const kLDHTTPImageUploadImageNameKey;
extern NSString * const kLDHTTPImageUploadFileNameKey;
extern NSString * const kLDHTTPImageUploadMimeTypeKey;
extern NSString * const kLDHTTPRequestSimulatorString;
extern NSString * const kLDHTTPRequestTokenKey;

NSString * http_realPath(NSString * path);

//这个写在这里的原因是因为登录失败的重新请求需要在这里
#define kHTTPLoginRequest http_realPath(@"/ldapp/applogin")

