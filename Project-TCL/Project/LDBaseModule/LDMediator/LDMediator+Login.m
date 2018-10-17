//
//  LDMediator+Login.m
//  MainArch
//
//  Created by 令达 on 2018/4/4.
//

#import "LDMediator+Login.h"
#import "Project-Swift.h"

NSString  * const kLDMediatorTargetLogin = @"Login";
NSString  * const kLDMediatorActionNativeFetchLoginVC = @"nativeFetchModuleLoginVC";
NSString  * const kLDMediatorActionCreateModuleLoginTables = @"nativeCreateModuleLoginDBTables";
NSString  * const kLDMediatorActionClearModuleLoginModels = @"nativeClearModuleLoginModels";


@implementation LDMediator (Login)

- (UINavigationController *)login_getLoginController
{
    UIViewController *viewController = [self performTarget:kLDMediatorTargetLogin action:kLDMediatorActionNativeFetchLoginVC
                                                    params:nil
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:viewController];
        return navi;
    } else {
        return nil;
    }
}

- (void)login_createModuleLoginTables
{
    [self performTarget:kLDMediatorTargetLogin action:kLDMediatorActionCreateModuleLoginTables params:nil shouldCacheTarget:NO];
}
- (void)login_clearModuleLoginModels
{
    [self performTarget:kLDMediatorTargetLogin action:kLDMediatorActionClearModuleLoginModels params:nil shouldCacheTarget:NO];
}
@end
