//
//  ViewController.m
//  fasdfasd
//
//  Created by lingda on 2019/2/20.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import "ViewController.h"
#import <TCLConfigNet/TCLConfigNet.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DeviceToNetTool saveWifiNameAndPassword:@"TP-3F-APP" password:@"tcl12345"];
    NSString * wifiName = [ToNetUtils getCurrentWifiName];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:label];
    label.text = @"ddd";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
