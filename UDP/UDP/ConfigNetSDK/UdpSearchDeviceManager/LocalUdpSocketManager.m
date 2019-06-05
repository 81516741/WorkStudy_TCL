//
//  LocalUdpSocketManager.m
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import "LocalUdpSocketManager.h"
#import "GCDAsyncUdpSocket.h"

@interface LocalUdpSocketManager()<GCDAsyncUdpSocketDelegate>
@property(nonatomic,copy)NSString * host;
@property(nonatomic,assign)NSString * port;
@property(nonatomic,assign)NSString * bindPort;
@property(nonatomic,strong)GCDAsyncUdpSocket  * udpSocket;
@end

@implementation LocalUdpSocketManager
-(void)dealloc {
    NSLog(@"LocalUdpSocketManager 销毁");
}
- (void)configUdpSocket:(NSString *)host port:(NSString *)port bindPort:(NSString *)bindPort {
    self.host = host;
    self.port = port;
    self.bindPort = bindPort;
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    NSError * error;
    [self.udpSocket enableBroadcast:YES error:&error];
    if (error) { NSLog(@"%@",error); }
    if ([bindPort isEqualToString:@"none"]) { return; }
    [self.udpSocket bindToPort:bindPort.intValue error:&error];
    if (error) { NSLog(@"%@",error);}
}

- (void)closeUdpSocket {
    if(self.udpSocket != nil) {
        [self.udpSocket close];
        self.udpSocket = nil;
    }
}

- (void)sendMsg:(NSString *)msg {
    NSAssert(self.udpSocket != nil, @"请配置host，port，bindPort");
    if (msg.length > 0) {
        NSData * data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        if (data != nil) {
            if (self.udpSocket.isClosed) {
                [self configUdpSocket:self.host port:self.port bindPort:self.bindPort];
            }
            [self.udpSocket sendData:data toHost:self.host port:self.port.intValue withTimeout:-1 tag:0];
            [self.udpSocket beginReceiving:nil];
        }
    }
}

#pragma mark - delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
    NSString * errorDes = error.localizedDescription;
    if (errorDes.length > 0) {
        if (self.errorHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.errorHandle(errorDes);
                NSLog(@"%@",errorDes);
            });
        }
    }
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSString * errorDes = error.localizedDescription;
    if (errorDes.length > 0) {
        if (self.errorHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.errorHandle(errorDes);
                NSLog(@"%@",errorDes);
            });
        }
    }
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString * msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.messageHandle != nil && self.udpSocket != nil) {
                self.messageHandle(msg);
            }
        });
    }

}
@end
