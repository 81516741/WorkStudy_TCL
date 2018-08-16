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
@property (nonatomic,strong) GCDAsyncSocket *  socket;
@property (nonatomic,copy) NSString *  hostIP;
@property (nonatomic,strong) dispatch_queue_t  socketQueue;
@property (nonatomic,assign) long  connectTag;
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

+ (NSString *)hostIP
{
    return [LDSocketManager shared].hostIP;
}

+ (BOOL)connectServer:(NSString *)hostIP port:(NSString *)port success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure
{
    return [[LDSocketManager shared] connectServer:hostIP port:port success:success failure:failure];
}

+ (void)sendMessage:(NSString *)message success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure
{
    [[LDSocketManager shared] sendMessage:message success:success failure:failure];
}
+ (void)startSSL
{
    [[LDSocketManager shared] starSSL];
}

#pragma mark - private method
- (BOOL)connectServer:(NSString *)hostIP port:(NSString *)hostPort success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure
{
    self.hostIP = hostIP;
    if (self.socket == nil) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
        [self saveSuccess:success failure:failure tag:self.connectTag];
        return [_socket connectToHost:hostIP onPort:[hostPort intValue] error:nil];
    }
    return self.socket.isConnected;
}

// 发送命令
- (void)sendMessage:(NSString *) message success:(LDSocketManagerBlock)success failure:(LDSocketManagerBlock)failure{
    NSData *data =[message dataUsingEncoding:NSUTF8StringEncoding];
    long tag = [self saveSuccess:success failure:failure];
    [self.socket readDataWithTimeout:-1 tag:tag];
    [self.socket writeData:data withTimeout:-1 tag:tag];
}

- (void)starSSL {
    
    NSMutableDictionary *sslSettings = [[NSMutableDictionary alloc] init];
    
    // SSL 证书
//    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ios_client" ofType:@"p12"]];
//    if (pkcs12data == nil) {
//        NSLog(@"加载p12 certificate 失败");
//    }
//    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(pkcs12data);
//    CFStringRef password = CFSTR("tclking");
//    const void *keys[] = { kSecImportExportPassphrase };
//    const void *values[] = { password };
//    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
//    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
//    CFRelease(options);
//    CFRelease(password);
//
//    if(securityError == errSecSuccess)
//    {
//        NSLog(@"打开 p12 certificate 成功");
//    }
//    else
//    {
//        NSLog(@"打开 p12 certificate 失败");
//    }
//
//    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
//    SecIdentityRef myIdent = (SecIdentityRef)CFDictionaryGetValue(identityDict,
//                                                                  kSecImportItemIdentity);
//
//    SecIdentityRef  certArray[1] = { myIdent };
//    CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
//
//    [sslSettings setObject:(id)CFBridgingRelease(myCerts) forKey:(NSString *)kCFStreamSSLCertificates];
//    [sslSettings setObject:self.hostIP forKey:(NSString *)kCFStreamSSLPeerName];
//    [sslSettings setObject:GCDAsyncSocketSSLProtocolVersionMin forKey:(NSString *)kCFStreamSSLLevel];
//    [sslSettings setObject:(id)kCFBooleanTrue forKey:@"kCFStreamSSLAllowsAnyRoot"];
//    [sslSettings setObject:[NSNumber numberWithBool:YES] forKey:@"kCFStreamSSLAllowsExpiredRoots"];
//    [sslSettings setObject:[NSNumber numberWithBool:YES] forKey:@"kCFStreamSSLValidatesCertificateChain"];
//    [sslSettings setObject:[NSNumber numberWithBool:YES] forKey:@"kCFStreamSSLAllowsExpiredCertificates"];
    [sslSettings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
    // 此方法是GCDScoket 设置ssl验证的唯一方法,需要传字典
    [_socket startTLS:sslSettings];
}

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

#pragma mark - socket delegate
// 连接成功
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

// 读取数据
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

// 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socket 断开连接");
    self.socket=nil;
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ios_client" ofType:@"p12"]];
    if (pkcs12data == nil) {
        NSLog(@"加载p12 certificate 失败");
    }
    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(pkcs12data);

    CFStringRef password = CFSTR("tclking");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
    CFRelease(options);
    CFRelease(password);

    if(securityError == errSecSuccess)
    {
        NSLog(@"打开 p12 certificate 成功");
    }
    else
    {
        NSLog(@"打开 p12 certificate 失败");
    }

    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef myIdent = (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                                                  kSecImportItemIdentity);

    SecIdentityRef  certArray[1] = { myIdent };
    CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
    
    
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
