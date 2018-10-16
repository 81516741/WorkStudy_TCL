//
//  LDMediator+HTTP.h
//  Project
//
//  Created by 令达 on 2018/4/9.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDMediator.h"

@interface LDMediator (HTTP)
/**
 返回包装了导航控制器的模块A控制器
 */
- (void)http_cancelAllHTTPRequest:(NSString *)VCName;
@end
