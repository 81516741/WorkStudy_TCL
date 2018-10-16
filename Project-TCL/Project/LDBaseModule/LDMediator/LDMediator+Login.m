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

- (id)_performAction:(NSString *)action params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCache
{
    return [self performTarget:kLDMediatorTargetLogin action:action params:params shouldCacheTarget:shouldCache];
}

- (UINavigationController *)login_getLoginController
{
    UIViewController *viewController = [self _performAction:kLDMediatorActionNativeFetchLoginVC
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
    [self _performAction:kLDMediatorActionCreateModuleLoginTables params:nil shouldCacheTarget:NO];
}
- (void)login_clearModuleLoginModels
{
    [self _performAction:kLDMediatorActionClearModuleLoginModels params:nil shouldCacheTarget:NO];
}
@end
