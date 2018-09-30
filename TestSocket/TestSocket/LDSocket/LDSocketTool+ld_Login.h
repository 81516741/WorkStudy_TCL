//
//  LDSocketTool+ld_Login.h
//  TestSocket
//
//  Created by lingda on 2018/9/29.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool.h"

@interface LDSocketTool (ld_Login)
+ (void)getCountByPhoneNum:(NSString *)phoneNum success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)loginSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
@end
