//
//  LDFunctionTool.h
//  Project
//
//  Created by 令达 on 2018/4/12.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    LDFunctionCodeLogin = 888001,
    LDFunctionOtherVC = 888002,
}LDFunctionCode;


@interface LDFunctionTool : NSObject

+(void)gotoFunctionByCode:(LDFunctionCode)code inVC:(UIViewController *)vc;

@end
