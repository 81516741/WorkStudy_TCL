//
//  TCLSecurityTool.h
//  StaticFrameWork_Example
//
//  Created by lingda on 2019/4/15.
//  Copyright © 2019年 81516741@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCLSecurityTool : NSObject
+ (NSString *)loginPassword:(NSString *)password;
+ (NSString *)bleDataWithSSID:(NSString *)ssid password:(NSString *)password bindCode:(NSString *)bindCode;
@end
