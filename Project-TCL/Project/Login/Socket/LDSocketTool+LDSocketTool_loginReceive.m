//
//  LDSocketTool+LDSocketTool_loginReceive.m
//  Project
//
//  Created by lingda on 2018/11/15.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDSocketTool+LDSocketTool_loginReceive.h"
#import "MessageIDConst.h"
#import "NSString+tcl_parseXML.h"
#import "ErrorCode.h"
#import "LDSysTool.h"
#import "NSString+ld_Security.h"
#import "LDDBTool+initiative.h"
#import "ConfigModel.h"
#import "LDLogTool.h"

@implementation LDSocketTool (LDSocketTool_loginReceive)
- (void)receiveLoginModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix messageError:(NSString *)messageError success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([messageIDPrefix isEqualToString:kGetCountMessageIDPrefix]) {
        [self handleGetCountMessage:message errorDes:messageError success:success failure:failure];
    } else if ([messageIDPrefix isEqualToString:kLoginMessageIDPrefix]) {
        [self handleLoginMessage:message errorDes:messageError success:success failure:failure];
    }
}
- (void)handleGetCountMessage:(NSString *)message errorDes:(NSString *)errorDes success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([errorDes isEqualToString:errorDesSuccess]) {
        success(message.tcl_userID);
    } else {
        failure(errorDes);
    }
}

- (void)handleLoginMessage:(NSString *)message errorDes:(NSString *)errorDes success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if ([errorDes isEqualToString:errorCodeNone] || [errorDes isEqualToString:errorDesSuccess]) {
        if (success) {
            success(errorDes);
        }
    } else {
        if (failure) {
            failure(errorDes);
        }
    }
}
@end
