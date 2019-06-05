



//
//  UIViewController+extension.m
//  test
//
//  Created by lingda on 2019/5/30.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import "UIViewController+extension.h"
#import <objc/runtime.h>

@implementation UIViewController (extension)
+ (void)load {
    Method oriMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method repMethod = class_getInstanceMethod([self class], @selector(replaceDelloc));
    method_exchangeImplementations(oriMethod, repMethod);
}

- (void)replaceDelloc {
    NSLog(@"d");
}
@end
