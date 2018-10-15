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
#import "LDSocketTool+home.h"
#import "LDInitiativeMsgHandle.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoConnect];
}

- (void)autoConnect
{
    [LDHTTPTool getIPAndPortSuccess:^(LDHTTPModel * model) {
        [LDSocketTool connectServer:model.data[@"ip"] port:model.data[@"port"] success:^(id data) {
            [LDSocketTool sendHandshakeMessageSuccess:^(id data) {
                self.desLable.text = @"握手成功";
            } failure:^(id data) {
                self.desLable.text = @"握手失败";
            }];
        } failure:nil];
    } failure:nil];
}

- (IBAction)login {
    [LDSocketTool loging:@"13104475087" password:@"123456" Success:^(id data) {
    } failure:^(id data) {
    }];
}

- (IBAction)getDeviceList:(UIButton *)sender {
    [LDSocketTool getDeviceListSuccess:^(id data) {
        if ([data isKindOfClass:NSString.self]) {
            //消息响应包
            NSLog(@"收到服务器返回的状态：%@",data);
        } else {
            NSLog(@"%@",data);
        }
        
    } failure:^(id data) {
        
    }];
}

@end
