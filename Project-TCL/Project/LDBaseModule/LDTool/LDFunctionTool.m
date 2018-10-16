//
//  LDFunctionTool.m
//  Project
//
//  Created by 令达 on 2018/4/12.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDFunctionTool.h"
#import "LDMediator+Login.h"
#import "LDMediator+Home.h"
#import "UIViewController+LDLogin.h"
#import "UIViewController+LDNaviBar.h"

@implementation LDFunctionTool

+(void)gotoFunctionByCode:(LDFunctionCode)code inVC:(UIViewController *)vc
{
    switch (code) {
        case LDFunctionOtherVC:
        {
            UINavigationController * navi = [[LDMediator sharedInstance] login_getLoginController];
        navi.childViewControllers.firstObject.ld_loginSuccessBlock = ^(id data){
            [vc.navigationController pushViewController:[[LDMediator sharedInstance] home_getOtherController] animated:YES];
            };
            [vc presentViewController:navi animated:YES completion:nil];
        }
            

            break;
            
        default:
            break;
    }
}

@end
