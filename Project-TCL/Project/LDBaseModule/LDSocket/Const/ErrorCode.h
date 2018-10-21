//
//  ErrorCode.h
//  TestSocket
//
//  Created by lingda on 2018/9/30.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ErrorCode) {
    success              = 0,
    confirmFailue        = 401,
    forbidden            = 403,
    notFount             = 404,
    threeErrorPassword   = 405,
    sysError             = 100000,
    notFoundUser         = 302800
};
extern NSString  *const errorDesSuccess;
extern NSString  *const errorDesConfirmFailure;
extern NSString  *const errorDesForbidden;
extern NSString  *const errorDesNotFoundCount;
extern NSString  *const errorDesThreeErrorPassword;
extern NSString  *const errorDesSysError;
extern NSString  *const errorDesNotFoundUser;
extern NSString  *const errorCodeNone;
extern NSString  *const errorDesUnKnow;

NSString * getErrorDescription(NSString * errorCode);

