//
//  LDMediator+LDModuleLogin.h
//  MainArch
//
//  Created by 令达 on 2018/4/4.
//

#import "LDMediator.h"

@interface LDMediator (Login)

/**
 返回包装了导航控制器的登录控制器
 */
- (UINavigationController *)login_getLoginController;
- (void)login_createModuleLoginTables;
- (void)login_clearModuleLoginModels;
@end
