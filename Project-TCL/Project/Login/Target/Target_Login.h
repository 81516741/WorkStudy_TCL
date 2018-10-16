//
//  Target_Login.h
//  MainArch_Example
//
//  Created by 令达 on 2018/4/4.
//  Copyright © 2018年 81516741@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Target_Login : NSObject
- (UIViewController *)Action_nativeFetchModuleLoginVC:(NSDictionary *)params;
- (void)Action_nativeCreateModuleLoginDBTables;
- (void)Action_nativeClearModuleLoginModels;
@end
