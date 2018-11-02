//
//  LDSocketTool+home.h
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool.h"

@interface LDSocketTool (homeSend)
+ (void)getDeviceListSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)getSceneListSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
+ (void)getUserInfoSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
@end
