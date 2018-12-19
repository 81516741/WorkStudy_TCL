//
//  LDSocketTool+LDSocketTool_loginReceive.h
//  Project
//
//  Created by lingda on 2018/11/15.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDSocketTool.h"

@interface LDSocketTool (LDSocketTool_loginReceive)
- (void)receiveLoginModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix messageError:(NSString *)messageError success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
- (void)handleGetCountMessage:(NSString *)message errorDes:(NSString *)errorDes success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
- (void)handleLoginMessage:(NSString *)message errorDes:(NSString *)errorDes success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure;
@end
