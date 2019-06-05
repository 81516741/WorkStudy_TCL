//
//  Student.m
//  test
//
//  Created by lingda on 2019/5/29.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import "Student.h"

@implementation Student
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@",[self class]);
        NSLog(@"%@",[super class]);
        NSLog(@"%@",[self superclass]);
        NSLog(@"%@",[super superclass]);
    }
    return self;
}
@end
