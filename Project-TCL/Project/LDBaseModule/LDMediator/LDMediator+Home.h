//
//  LDMediator+LDModuleAActions.h
//  MainArch_Example
//
//  Created by 令达 on 2018/3/26.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "LDMediator.h"

@interface LDMediator (Home)
/**
 返回包装了导航控制器的模块A控制器
 */
- (UINavigationController *)home_getHomeController;

- (UIViewController *)home_getOtherController;


@end
