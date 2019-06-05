//
//  LocalTclSocketManager.m
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import "LocalTclSocketManager.h"
#import "GCDAsyncSocket.h"
@interface LocalTclSocketManager()<GCDAsyncSocketDelegate>
@property(nonatomic,copy) NSString * hostStr;
@property(nonatomic,copy) NSString * portStr;
@property(nonatomic,strong) GCDAsyncSocket * socket;
@property(nonatomic,strong) dispatch_queue_t tcpWriteQueue;
@end

@implementation LocalTclSocketManager

- (void)connectToHost:(NSString *)host port:(NSString *)port {
    NSAssert(host.length > 0 && port.length > 0, @"host 或 port 为nil");
    [self disconnect];
    self.hostStr = host;
    self.portStr = port;
    [self.socket connectToHost:host onPort:port.intValue error:nil];
}

- (void)sendMsg:(NSString *)msg {
    NSLog(@">>>>>>>>设备tcp消息:发送消息给设备：%@",msg);
    NSData * data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        [self.socket writeData:data withTimeout:-1 tag:0];
    }
}

- (void)disconnect {
    if (self.socket.isConnected) {
        NSLog(@">>>>>>>>设备tcp消息:主动断开设备连接");
        [self.socket disconnect];
    }
    if (self.socket) {
        self.socket = nil;
    }
}

- (NSString *)host {
    return self.hostStr;
}
- (NSString *)port {
    return self.portStr;
}

#pragma mark - delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@">>>>>>>>设备tcp消息:连接设备成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.connectHandle) {
            self.connectHandle(YES);
        }
    });
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@">>>>>>>>设备tcp消息:设备断开连接");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.connectHandle) {
            self.connectHandle(NO);
        }
    });
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [sock readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString * msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@">>>>>>>>设备tcp消息:收到设备消息：%@",msg);
    if (msg.length > 0) {
        if (self.messageHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageHandle(msg);
            });
        }
    }
}
#pragma mark - 懒加载
- (GCDAsyncSocket *)socket {
    if (_socket == nil) {
       _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("tcpDelegateQueue", DISPATCH_QUEUE_SERIAL)];
    }
    return _socket;
}
- (dispatch_queue_t)tcpWriteQueue {
    if (_tcpWriteQueue) {
        _tcpWriteQueue = dispatch_queue_create("tcpWriteQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _tcpWriteQueue;
}
@end
