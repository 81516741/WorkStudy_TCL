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
    sysError             = 100000,
    notFoundUser         = 302800
};

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
            return nil;
            break;
    }
}
