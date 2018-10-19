//
//  ErrorCode.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "ErrorCode.h"

NSString  *const errorDesSuccess = @"成功";
NSString  *const errorDesConfirmFailure = @"认证失败";
NSString  *const errorDesForbidden = @"禁用";
NSString  *const errorDesNotFoundCount = @"账号没找到";
NSString  *const errorDesThreeErrorPassword = @"密码错误三次";
NSString  *const errorDesSysError = @"系统错误";
NSString  *const errorDesNotFoundUser = @"没有找到此用户";
NSString  *const errorDesUnKnow = @"未知错误";
NSString  *const errorNone = @"没错误码";

NSString * getErrorDescription(NSString * errorCode) {
    if (errorCode.length == 0) {
        return errorNone;
    }
    switch (errorCode.integerValue) {
        case success:
            return errorDesSuccess;
            break;
        case confirmFailue:
            return errorDesConfirmFailure;
            break;
        case forbidden:
            return errorDesForbidden;
            break;
        case notFount:
            return errorDesNotFoundCount;
            break;
        case threeErrorPassword:
            return errorDesThreeErrorPassword;
            break;
        case sysError:
            return errorDesSysError;
            break;
        case notFoundUser:
            return errorDesNotFoundUser;
            break;
        default:
            return errorDesUnKnow;
            break;
    }
}

