//
//  LDMediator+Home.m
//  MainArch_Example
//
//  Created by 令达 on 2018/3/26.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "LDMediator+Home.h"

NSString  * const kLDMediatorTargetHome = @"Home";
NSString  * const kLDMediatorActionNativeFetchHomeVC = @"nativeFetchHomeVC";
NSString  * const kLDMediatorActionNativeFetchHomeOtherVC = @"nativeFetchOtherVC";

NSString  * const kLDMediatorActionCreateModuleHomeTables = @"nativeCreateModuleHomeDBTables";
NSString  * const kLDMediatorActionClearModuleHomeModels = @"nativeClearModuleHomeModels";

@implementation LDMediator (Home)
- (UINavigationController *)home_getHomeController;
{
    NSDictionary * params = @{@"title":@"我的",
                              @"image":@"first_normal",
                              @"selectedImage":@"first_selected"
                              };
    
    UIViewController *viewController = [self performTarget:kLDMediatorTargetHome
                                                    action:kLDMediatorActionNativeFetchHomeVC
                                                    params:params
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:viewController];
        return navi;
    } else {
        return nil;
    }
}

- (UIViewController *)home_getOtherController
{
    NSDictionary * params = @{@"title":@"其它"
                              };
    
    UIViewController *viewController = [self performTarget:kLDMediatorTargetHome
                                                    action:kLDMediatorActionNativeFetchHomeOtherVC
                                                    params:params
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        return nil;
    }
}

- (void)home_createModuleLoginTables
{
    [self performTarget:kLDMediatorTargetHome action:kLDMediatorActionCreateModuleHomeTables params:nil shouldCacheTarget:NO];
}
- (void)home_clearModuleLoginModels
{
    [self performTarget:kLDMediatorTargetHome action:kLDMediatorActionClearModuleHomeModels params:nil shouldCacheTarget:NO];
}
@end
