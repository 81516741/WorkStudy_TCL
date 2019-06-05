//
//  ViewController.m
//  test
//
//  Created by lingda on 2019/5/29.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Student.h"
#import "Person.h"
#import <objc/runtime.h>
@interface ViewController ()
@property (nonatomic , strong) NSThread * tt;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%p",ddd);
    NSLog(@"%p",&nishuai);
    [[Student alloc] init];
    NSLog(@"%d,%d,%d,%d",[[NSObject class] isKindOfClass:[NSObject class]],[[NSObject class] isMemberOfClass:[NSObject class]],[[Student class] isKindOfClass:[Student class]],[[Student class] isMemberOfClass:[NSObject class]]);
    
}
- (void)test {
    NSLog(@"2");
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSThread * t = [[NSThread alloc] initWithBlock:^{
//        NSLog(@"1");
//        [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
//    }];
//    [t start];
//    self.tt = t;
//    [self performSelector:@selector(test) onThread:t withObject:nil waitUntilDone:YES];
    [self.navigationController pushViewController:[UIViewController new] animated:true];
}

@end
