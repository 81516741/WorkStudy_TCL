//
//  ErrorCode.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "ErrorCode.h"

NSString * getErrorDescription(NSString * errorCode) {
    switch (errorCode.integerValue) {
        case success:
            return @"成功";
            break;
        case sysError:
            return @"系统错误";
            break;
        case notFoundUser:
            return @"没有找到此用户";
            break;
        default:
            return @"未知错误";
            break;
    }
}
