//
//  Target_A.m
//  MainArch_Example
//
//  Created by 令达 on 2018/3/26.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import "Target_Home.h"
#import "LDHomeVC.h"
#import "LDOtherVC.h"

@implementation Target_Home
    
- (UIViewController *)Action_nativeFetchHomeVC:(NSDictionary *)params
{
    LDHomeVC * vc = [[LDHomeVC alloc] init];
    vc.tabBarItem.title = params[@"title"];
    vc.tabBarItem.image = [UIImage imageNamed:params[@"image"]];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:params[@"selectedImage"]];
    return vc;
}

- (UIViewController *)Action_nativeFetchOtherVC:(NSDictionary *)params
{
    LDOtherVC * vc = [[LDOtherVC alloc] init];
    return vc;
}
@end
