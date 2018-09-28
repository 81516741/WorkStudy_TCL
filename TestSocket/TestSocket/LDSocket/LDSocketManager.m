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
@property (nonatomic,strong) NSMutableDictionary *  requestBlocks;
@property (nonatomic,strong) GCDAsyncSocket *     socket;
@property (nonatomic,copy)   NSString *           host;
@property (nonatomic,assign) NSInteger            port;
@property (nonatomic,strong) dispatch_queue_t     socketQueue;
@property (nonatomic,assign) long                 connectTag;
@end

@implementation LDSocketManager

#pragma mark - public method
+ (instancetype)shared
{
    static LDSocketManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LDSocketManager new];
        _instance.socketQueue=dispatch_queue_create("socket request queue",NULL);
        _instance.connectTag = 666888;
    });
    return _instance;
}

+ (NSString *)host {
    return [LDSocketManager shared].host;
}
+ (NSInteger)port {
    return [LDSocketManager shared].port;
}

+ (BOOL)connectServer:(NSString *)host port:(NSInteger) port success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure
{
    return [[LDSocketManager shared] connectServer:host port:port success:success failure:failure];
}
- (BOOL)connectServer:(NSString *)host port:(NSInteger)port success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure
{
    self.host = host;
    self.port = port;
    if (self.socket == nil) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
        [self saveSuccess:success failure:failure tag:self.connectTag];
        return [_socket connectToHost:host onPort:port error:nil];
    }
    return self.socket.isConnected;
}

+ (void)sendMessage:(NSString *)message success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure
{
    [[LDSocketManager shared] sendMessage:message success:success failure:failure];
}
- (void)sendMessage:(NSString *) message success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure{
    NSData *data =[message dataUsingEncoding:NSUTF8StringEncoding];
    long tag = [self saveSuccess:success failure:failure];
    [self.socket writeData:data withTimeout:-1 tag:tag];
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
    [self.socket startTLS:settings]; // 开始SSL握手
}


#pragma mark - socket delegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSArray * blocks = [self.requestBlocks objectForKey:[NSString stringWithFormat:@"%ld",self.connectTag]];
    BOOL state = [self.socket isConnected];  // 判断是否连接成功
    if (state) {
        NSLog(@"socket 连接成功");
        if (blocks.firstObject) {
            ((LDSocketManagerBlock)(blocks.firstObject))([@"success" dataUsingEncoding:NSUTF8StringEncoding]);
        }
    }else{
        NSLog(@"socket 没有连接");
        if (blocks.lastObject) {
            ((LDSocketManagerBlock)(blocks.lastObject))([@"failure" dataUsingEncoding:NSUTF8StringEncoding]);
        }
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    completionHandler(YES);
}

-(void)socket:(GCDAsyncSocket *)sock
didWriteDataWithTag:(long)tag{
    NSLog(@"[客户端]:发送数据完毕");
    [self.socket readDataWithTimeout:-1 tag:tag];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString * tagString = [NSString stringWithFormat:@"%ld",tag];
    NSArray * blocks = [self.requestBlocks objectForKey:tagString];
    if (blocks.firstObject && data.length > 0) {
        ((LDSocketManagerBlock)(blocks.firstObject))(data);
    }
    if (blocks.lastObject && data.length > 0) {
        ((LDSocketManagerBlock)(blocks.lastObject))(data);
    }
  
    [self.requestBlocks removeObjectForKey:tagString];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socket 断开连接");
}
#pragma mark - method
- (long)saveSuccess:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure
{
    long tag = random();
    [self saveSuccess:success failure:failure tag:tag];
    return tag;
}

- (void)saveSuccess:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure tag:(long)tag
{
    NSMutableArray * blockArray = [NSMutableArray arrayWithCapacity:2];
    if (success) {
        [blockArray addObject:success];
    } else {
        [blockArray addObject:@"nil"];
    }
    if (failure) {
        [blockArray addObject:failure];
    } else {
        [blockArray addObject:@"nil"];
    }
    NSString * tagString = [NSString stringWithFormat:@"%ld",tag];
    [self.requestBlocks setObject:blockArray forKey:tagString];
}

- (void)removeSuccessAndFailureBlockByTag:(long)tag
{
    NSString * tagString = [NSString stringWithFormat:@"%ld",tag];
    [self.requestBlocks removeObjectForKey:tagString];
}

#pragma mark - lazy load
- (NSMutableDictionary *)requestBlocks
{
    if (_requestBlocks == nil) {
        _requestBlocks = [NSMutableDictionary dictionary];
    }
    return _requestBlocks;
}

@end
