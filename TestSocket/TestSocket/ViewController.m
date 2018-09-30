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
#import "LDSocketTool+ld_Login.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [UIButton new];
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    

    [self autoConnect];
}

- (void)login {
    [LDSocketTool loginSuccess:^(id data) {
        
    } failure:^(id data) {
        
    } ];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)autoConnect
{
    [LDHTTPTool getIPAndPortSuccess:^(LDHTTPModel * model) {
        [LDSocketTool connectServer:model.dataOrigin[@"ip"] port:model.dataOrigin[@"port"] success:^(id data) {
            [LDSocketTool sendHandshakeMessageSuccess:^(id data) {
                
            } failure:nil];
        } failure:nil];
    } failure:nil];
}


@end
