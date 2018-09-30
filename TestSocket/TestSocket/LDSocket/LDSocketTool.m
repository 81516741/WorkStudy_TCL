//
//  LDSocketTool.m
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/6.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool.h"
#import "LDSocketManager.h"
#import "MessageIDTool.h"
#import "LDXMLParseTool.h"

@interface NSString(ld_Extension)
@end

@implementation NSString(ld_Extension)
- (NSString *)ld_subStringNear:(NSString *) startStr  endStr:(NSString *)endStr {
    NSRange range = [self rangeOfString:startStr];
    NSString * handleStr;
    if (range.length > 0) {
        handleStr = [self substringFromIndex:range.location + startStr.length];
        range = [handleStr rangeOfString:endStr];
        handleStr = [handleStr substringToIndex:range.location];
    }
    return handleStr;
}
- (NSString *)tcl_messageID
{
    NSString * messageID = [[self stringByReplacingOccurrencesOfString:@" " withString:@""] ld_subStringNear:@"id=\"" endStr:@"\""];
    return messageID;
    
}
@end


@interface LDSocketTool()<LDSocketManagerConnectProtocol,LDSocketManagerSendMessageProtocol>
@property(assign, nonatomic) BOOL isConnecting;
@property(assign, nonatomic) BOOL isHanding;
@property(copy, nonatomic) NSString * connectMessageID;
@property(copy, nonatomic) NSString * startHandMessageID;
@property(copy, nonatomic) NSString * openSSLMessageID;
@property(copy, nonatomic) NSString * endHandMessgeID;
@end

@implementation LDSocketTool
+ (instancetype)shared {
    static LDSocketTool * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LDSocketTool new];
    });
    return _instance;
}
#pragma  mark - 连接服务器
+ (BOOL)connectServer:(NSString *)host port:(NSString *)port success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    if ([LDSocketTool shared].isConnecting) {
        return NO;
    }
    [LDSocketTool shared].isConnecting = YES;
    [LDSocketTool shared].connectMessageID = [MessageIDTool getMessageID:kConnecctServiceMessageIDPrefix];
    [LDSocketTool saveSuccessBlock:success
                      failureBlock:failure messageID:[LDSocketTool shared].connectMessageID];
    return [LDSocketManager connectServer:host port:port.integerValue delegate:[LDSocketTool shared]];
}
- (void)receiveConnectServiceResult:(id)result manager:(LDSocketManager *)manager {
    [self callBackByMessageID:[LDSocketTool shared].connectMessageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
        if ([result isKindOfClass:NSString.self]) {
            if ([result isEqualToString:@"连接成功"]) {
                if (success) {
                    success(nil);
                }
            } else if ([result isEqualToString:@"连接失败"]) {
                if (failure) {
                    failure(nil);
                }
            }
        }
    }];
    [LDSocketTool shared].isConnecting = false;
}

#pragma mark - 发消息给服务器
+ (void)sendHeartMessageSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    NSString * messageID = [MessageIDTool getMessageID:kHeartMessageIDPrefix];
    NSString * heartMessage =
    [NSString stringWithFormat:@"\
<?xml version=\"1.0\" encoding=\"utf-8\"?>\
<iq id=\"%@\" to=\"tcl.com\" type=\"get\">\
        <ping xmlns=\"urn:xmpp:ping\"></ping>\
</iq>",messageID];
    
    [LDSocketTool sendMessage:heartMessage messageID:messageID success:success failure:failure];
}

+ (void)sendHandshakeMessageSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    if ([LDSocketTool shared].isHanding) {
        return;
    }
    [LDSocketTool shared].isHanding = YES;
    NSString * startHandshakeMessage = [NSString stringWithFormat:@"<stream:stream to=\"%@\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">",[LDSocketManager host]];
    NSString * openSSLMessage = @"<starttls xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>";
    NSString * endHandshakeMessage = @"<stream:stream to=\"tcl.com\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">";
    NSLog(@"（1）");
    [LDSocketTool shared].startHandMessageID = [MessageIDTool getMessageID:kStartHandMessageIDPrefix];
    [LDSocketTool shared].openSSLMessageID = [MessageIDTool getMessageID:kOpenSSLMessageIDPrefix];
    [LDSocketTool shared].endHandMessgeID = [MessageIDTool getMessageID:kEndHandMessageIDPrefix];
    [LDSocketTool sendMessage:startHandshakeMessage messageID:[LDSocketTool shared].startHandMessageID success:^(id data) {
        NSLog(@"握手成功");
        [LDSocketTool shared].isHanding = false;
        if (success) {
            success(nil);
        }
//        NSLog(@"（2）");
//        [LDSocketTool sendMessage:openSSLMessage messageID:[LDSocketTool shared].openSSLMessageID success:^(id data) {
//            NSLog(@"（3）");
//            [LDSocketManager startSSL];
//            [LDSocketTool sendMessage:endHandshakeMessage messageID:[LDSocketTool shared].endHandMessgeID success:^(id data) {
//                [LDSocketTool shared].isHanding = false;
//            } failure:^(id data) {
//                [LDSocketTool shared].isHanding = false;
//            }];
//        } failure:^(id data) {
//            [LDSocketTool shared].isHanding = false;
//        }];
    } failure:^(id data) {
        [LDSocketTool shared].isHanding = false;
        failure(nil);
    }];
}

+ (void)sendMessage:(NSString *)message messageID:(NSString *)messageID success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    NSLog(@"给服务器发送信息:%@",message);
    [LDSocketTool saveSuccessBlock:success failureBlock:failure messageID:messageID];
    [LDSocketManager sendMessage:message delegate:[LDSocketTool shared]];
}

#pragma mark - 发完消息后的回调
- (void)receiveMessageResult:(id)result manager:(LDSocketManager *)manager {
    NSString * XMLString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSString * messageID = [XMLString tcl_messageID];
    NSLog(@"收到服务器数据-messageID=%@\n%@",messageID,XMLString);
    if (messageID.length > 0 && [messageID containsString:@"-"]) {
        [self callBackByMessageID:messageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if ([self respondsToSelector:@selector(receiveMessage:messageIDPrefix:success:failure:)]) {
                [self receiveMessage:XMLString messageIDPrefix:[messageID componentsSeparatedByString:@"-"].firstObject success:success failure:failure];
            }
        }];
    } else if ([XMLString containsString:@"starttls"] && [XMLString containsString:@"auth"] && [XMLString containsString:@"register"] && ![XMLString containsString:@"mechanisms"]) {
        //开始握手的回调，在TCL项目中，此消息没有消息id
        [self callBackByMessageID:[LDSocketTool shared].startHandMessageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if (success) {
                success(nil);
            }
        }];
    } else if ([XMLString containsString:@"proceed"]) {
        //开启SSL的回调，在TCL项目中，此消息没有消息id
        [self callBackByMessageID:[LDSocketTool shared].openSSLMessageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if (success) {
                success(nil);
            }
        }];
    } else if ([XMLString containsString:@"starttls"] && [XMLString containsString:@"auth"] && [XMLString containsString:@"register"] && [XMLString containsString:@"mechanisms"]) {
        //结束握手的回调，在TCL项目中，此消息没有消息id
        [self callBackByMessageID:[LDSocketTool shared].endHandMessgeID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if (success) {
                success(nil);
            }
        }];
    }
}

#pragma mark - common method
+ (void)saveSuccessBlock:(LDSocketToolBlock)success failureBlock:(LDSocketToolBlock)failure messageID:(NSString *)messageID {
    [[LDSocketTool shared] saveSuccessBlock:success failureBlock:failure messageID:messageID];
}
- (void)saveSuccessBlock:(LDSocketToolBlock)success failureBlock:(LDSocketToolBlock)failure messageID:(NSString *)messageID
{
    NSMutableArray * blocks = [NSMutableArray arrayWithCapacity:2];
    if (success) {
        [blocks addObject:success];
    } else {
        [blocks addObject:@"nil"];
    }
    if (failure) {
        [blocks addObject:failure];
    } else {
        [blocks addObject:@"nil"];
    }
    [self.requestBlocks setObject:blocks forKey:messageID];
}

- (NSArray *)getBlocksByMessageID:(NSString *)messageID {
    NSArray * blocks = [self.requestBlocks objectForKey:messageID];
    return blocks;
}

- (void)removeBlocksByMessageID:(NSString *)messageID
{
    [self.requestBlocks removeObjectForKey:messageID];
}

-(void)callBackByMessageID:(NSString *)messageID excuteCode:(void (^)(LDSocketToolBlock success, LDSocketToolBlock failure))excuteCode {
    NSArray *  blocks = [self getBlocksByMessageID:messageID];
    if (blocks.count == 2) {
        if (excuteCode) {
            LDSocketToolBlock success;
            if(![blocks.firstObject isKindOfClass:NSString.self]) {
                success = blocks.firstObject;
            }
            LDSocketToolBlock failure;
            if(![blocks.lastObject isKindOfClass:NSString.self]) {
                failure = blocks.lastObject;
            }
            excuteCode(success,failure);
            
        }
        [self removeBlocksByMessageID:messageID];
    } else {
        NSLog(@"⚠️⚠️⚠️没有找到与MessageID:%@对应的blocks",messageID);
    }
    
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
