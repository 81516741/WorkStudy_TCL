//
//  LDSocketManager.m
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/3.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketManager.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@interface LDSocketManager()<GCDAsyncSocketDelegate>
@property (nonatomic,strong) GCDAsyncSocket *     socket;
@property (nonatomic,copy)   NSString *           host;
@property (nonatomic,assign) NSInteger            port;
@property (nonatomic,strong) dispatch_queue_t     socketQueue;
@property(weak, nonatomic) id<LDSocketManagerConnectProtocol>  connectDelegate;
@property(weak, nonatomic) id<LDSocketManagerSendMessageProtocol>  sendMessageDelegate;
@end

NSInteger timerOutSec = 30;
@implementation LDSocketManager

#pragma mark - public method
+ (instancetype)shared
{
    static LDSocketManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LDSocketManager new];
        _instance.socketQueue=dispatch_queue_create("socket request queue",NULL);
    });
    return _instance;
}

+ (NSString *)host {
    return [LDSocketManager shared].host;
}
+ (NSInteger)port {
    return [LDSocketManager shared].port;
}


+ (BOOL)connectServer:(NSString *)host port:(NSInteger) port delegate:(id<LDSocketManagerConnectProtocol>)delegate
{
    return [[LDSocketManager shared] connectServer:host port:port delegate:delegate];
}
- (BOOL)connectServer:(NSString *)host port:(NSInteger)port delegate:(id<LDSocketManagerConnectProtocol>)delegate
{
    self.host = host;
    self.port = port;
    if (self.socket == nil) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
        self.connectDelegate = delegate;
        return [self.socket connectToHost:host onPort:port withTimeout:timerOutSec error:nil];
    } else if (!self.socket.isConnected) {
        return [self.socket connectToHost:host onPort:port withTimeout:timerOutSec error:nil];
    }
    return self.socket.isConnected;
}

+ (void)sendMessage:(NSString *)message delegate:(id<LDSocketManagerSendMessageProtocol>)delegate
{
    [[LDSocketManager shared] sendMessage:message delegate:delegate];
}
- (void)sendMessage:(NSString *) message delegate:(id<LDSocketManagerSendMessageProtocol>)delegate{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.sendMessageDelegate = delegate;
    });
    NSData *data =[message dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:timerOutSec tag:0];
}

+ (void)startSSL
{
    [[LDSocketManager shared] starSSL];
}
- (void)starSSL {
    NSMutableDictionary *settings =
    [NSMutableDictionary dictionaryWithCapacity:3];
    [settings setObject:@(YES)
                 forKey:GCDAsyncSocketManuallyEvaluateTrust];
    [settings setObject:@"192.168.4.1:443"
                 forKey:GCDAsyncSocketSSLPeerName];
//    [settings setObject:self.host
//                 forKey:GCDAsyncSocketSSLPeerName];
    [self.socket startTLS:settings]; // 开始SSL握手
}


#pragma mark - socket delegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if ([self.connectDelegate respondsToSelector:@selector(receiveConnectServiceResult:manager:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.connectDelegate receiveConnectServiceResult:@"连接成功" manager:self];
        });
    }
    [self.socket readDataWithTimeout:timerOutSec tag:0];
    NSLog(@"连接成功");
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSString * errorDes =  err.userInfo[NSLocalizedDescriptionKey];
    if ([self.connectDelegate respondsToSelector:@selector(receiveConnectServiceResult:manager:)]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.connectDelegate receiveConnectServiceResult:errorDes manager:self];
        });
    }
    NSLog(@"socket 断开连接:%@",errorDes);
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if ([self.sendMessageDelegate respondsToSelector:@selector(receiveMessageResult:manager:)]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
           [self.sendMessageDelegate receiveMessageResult:data manager:self];
        });
    }
     [self.socket readDataWithTimeout:timerOutSec tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler {
    NSLog(@"无条件信任证书");
    completionHandler(YES);
}

@end
