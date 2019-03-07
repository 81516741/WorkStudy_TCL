//
//  ViewController2.m
//  RxSwiftStudy
//
//  Created by lingda on 2019/3/7.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import "ViewController2.h"
#import "RxSwiftStudy-Swift.h"
@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.yellowColor;
    self.ld_theme = NaviBarThemeBlue;
    TestView * v = [[TestView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    v.backgroundColor = UIColor.redColor;
    [self.view addSubview:v];
}
- (void)routerEventWithTypeWithEventType:(NSString *)eventType userInfo:(id)userInfo {
    NSLog(@"%@--%@",eventType,userInfo);
}

@end
