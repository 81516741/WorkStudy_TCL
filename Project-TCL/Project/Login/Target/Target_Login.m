//
//  Target_Login.m
//  MainArch_Example
//
//  Created by 令达 on 2018/4/4.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "Target_Login.h"
#import "LDDBTool+Login.h"
#import "LDDBTool+initiative.h"
#import "ConfigModel.h"
#import "Project-Swift.h"

@implementation Target_Login
- (UIViewController *)Action_nativeFetchModuleLoginVC:(NSDictionary *)params
{
    LoginVC * vc = [[LoginVC alloc] init];
    return vc;
}

- (void)Action_nativeCreateModuleLoginDBTables:(NSDictionary *)params
{
    [LDDBTool createLoginTables];
}

- (void)Action_nativeClearModuleLoginModels:(NSDictionary *)params
{
    [LDDBTool clearnLoginModel];
}

- (BOOL)Action_getLoginState:(NSDictionary *)params {
    ConfigModel * model = [LDDBTool getConfigModel];
    if (model.currentUserPassword.length > 0) {
        return YES;
    } else {
        return NO;
    }
}
@end
