//
//  ViewController.m
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/3.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "ViewController.h"
#import "LDHTTPTool.h"
#import "LDSocketTool.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoConnect];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [LDSocketTool sendHandshakeMessageSuccess:^(id data) {
        
    } failure:^(id data) {
        
    }];
}

- (void)autoConnect
{
    [LDHTTPTool getIPAndPortSuccess:^(LDHTTPModel * model) {
        [LDSocketTool connectServer:model.dataOrigin[@"ip"] port:model.dataOrigin[@"port"] success:^(id data) {
            
        } failure:^(id data) {
            
        }];
    } failure:^(LDHTTPModel * model) {
    }];
}


@end
