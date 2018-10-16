//
//  LDMediator+Mine.m
//  MainArch_Example
//
//  Created by 令达 on 2018/3/29.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "LDMediator+Mine.h"

NSString  * const kLDMediatorTargetMine = @"Mine";
NSString  * const kLDMediatorActionNativeFetchMineVC = @"nativeFetchMineVC";

@implementation LDMediator (Mine)
- (UINavigationController *)mine_getMineController;
{
    NSDictionary * params = @{@"title":@"首页",
                              @"image":@"second_normal",
                              @"selectedImage":@"second_selected"
                              };
    
    UIViewController *viewController = [self performTarget:kLDMediatorTargetMine
                                                    action:kLDMediatorActionNativeFetchMineVC
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



@end
