//
//  ViewController.m
//  UDP
//
//  Created by lingda on 2019/5/13.
//  Copyright © 2019年 lingda. All rights reserved.
//

#import "ViewController.h"
#import "TCLConfigNet.h"
#import "LocalTclSocketManager.h"
#import "TCLLocationManager.h"
#import <MQTTClient/MQTTClient.h>
#import "ToNetUtils.h"
#import "MQTTManager.h"


@interface ViewController ()<MQTTSessionDelegate>
@property (nonatomic , strong) MQTTSession *session;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)clickStart:(id)sender {
//    SearchLocalDeviceConfig * config = [SearchLocalDeviceConfig config];
//    config.port = @"1314";
//    config.host = @"255.255.255.255";
//    config.intervalSendPacket = 1;
//    [SearchLocalDeviceTool startSearcheDevice:config result:^(id deviceInfo) {
        NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
//        self.textView.text = [NSString stringWithFormat:@"%@\n%f 收包时间戳",self.textView.text,interval];
//    }];
//    [SearchLocalDeviceTool shared].SendPack = ^{
//        NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
//        self.textView.text = [NSString stringWithFormat:@"%@\n%f 发包时间戳",self.textView.text,interval];
//    };
    
    self.textView.text = [NSString stringWithFormat:@"%@\n%f 开始连接网络-",self.textView.text,interval];
    [DeviceToNetTool connectWifi:@"TP-LINK_CADB" password:@"test1234" complement:^(NSString *error) {
        NSTimeInterval interval1 = [NSDate timeIntervalSinceReferenceDate];
        if (error == nil) {
            self.textView.text = [NSString stringWithFormat:@"%@\n%f 连接网络成功-",self.textView.text,interval1];
        }
    }];
//    [self testMqtt];
    
}
- (void)testMqtt {
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    self.textView.text = [NSString stringWithFormat:@"%@\n%f 开始连接服务器-",self.textView.text,interval];
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = @"10.124.206.82";
    transport.port = 1883;
    
    MQTTSession *session = [[MQTTSession alloc] init];
    session.cleanSessionFlag = false;
    self.session = session;
    session.delegate = self;
    session.transport = transport;
    [session connectWithConnectHandler:^(NSError *error) {
        [session subscribeToTopic:@"1234" atLevel:MQTTQosLevelExactlyOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
            if (error) {
                NSLog(@"Subscription failed %@", error.localizedDescription);
            } else {
                NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
            }
        }];
    }];
}
- (IBAction)clickStop:(id)sender {
//    [SearchLocalDeviceTool stopSearchDevice];
//    self.textView.text = @"";
    [self.textView endEditing:true];
}
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    self.textView.text = [NSString stringWithFormat:@"%@\n%f 收到服务器消息-",self.textView.text,interval];
}
@end
