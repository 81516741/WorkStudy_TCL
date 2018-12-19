//
//  ImageViewBehavior.m
//  btc
//
//  Created by lingda on 2017/9/4.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDImageViewBehavior.h"

@implementation LDImageViewBehavior

- (BOOL)check
{
    if (self.imageView.image == nil) {
        return NO;
    } else {
        return YES;
    }
}

@end
