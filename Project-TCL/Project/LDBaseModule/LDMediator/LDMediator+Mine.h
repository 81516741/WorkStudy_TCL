//
//  LDMediator+Mine.h
//  MainArch_Example
//
//  Created by 令达 on 2018/3/29.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "LDMediator.h"

@interface LDMediator (Mine)

/**
 返回包装了导航控制器的模块B控制器
 */
- (UINavigationController *)mine_getMineController;
@end
