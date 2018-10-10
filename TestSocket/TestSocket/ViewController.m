//
//  ViewController.m
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/3.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "ViewController.h"
#import "LDHTTPTool+login.h"
#import "LDSocketTool+login.h"
#import "LDInitiativeMsgHandle.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *desLable;
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
    [LDSocketTool loging:@"13104475087" password:@"123456" Success:^(id data) {
        [LDSocketTool getConfigParam];
        notiReceiveMsg(self, @selector(receiveConfigParam:), kGetParamNotification);
    } failure:^(id data) {
        
    }];
}

- (void)autoConnect
{
    [LDHTTPTool getIPAndPortSuccess:^(LDHTTPModel * model) {
        [LDSocketTool connectServer:model.dataOrigin[@"ip"] port:model.dataOrigin[@"port"] success:^(id data) {
            [LDSocketTool sendHandshakeMessageSuccess:^(id data) {
                self.desLable.text = @"握手成功";
            } failure:^(id data) {
                self.desLable.text = @"握手失败";
            }];
        } failure:nil];
    } failure:nil];
}

- (void)receiveConfigParam:(NSNotification *)noti {
    
}

@end
