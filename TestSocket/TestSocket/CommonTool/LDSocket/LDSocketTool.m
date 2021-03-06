//
//  LDSocketTool.m
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/6.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool.h"
#import "LDSocketManager.h"
#import "MessageIDConst.h"
#import "NSString+tcl_parseXML.h"
#import "LDSocketTool+login.h"
#import "LDPacketHandle.h"

NSString * const quickHand0 = @"quickHand0";
NSString * const quickHand1 = @"quickHand1";
BOOL useSSL = false;

@interface LDSocketTool()<LDSocketManagerConnectProtocol,LDSocketManagerSendMessageProtocol>
@property(assign, nonatomic) BOOL isConnecting;
@property(assign, nonatomic) BOOL isHanding;
@property(copy, nonatomic) NSString * connectMessageID;
@property(copy, nonatomic) NSString * startHandMessageID;
@property(copy, nonatomic) NSString * openSSLMessageID;
@property(copy, nonatomic) NSString * endHandMessgeID;

@property(strong, nonatomic) NSMutableString * tempXML;

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
    [LDSocketTool shared].connectMessageID = getMessageID(kConnecctServiceMessageIDPrefix);
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
    NSString * messageID = getMessageID(kHeartMessageIDPrefix);
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
    [LDSocketTool shared].startHandMessageID = getMessageID(kStartHandMessageIDPrefix);
    [LDSocketTool shared].openSSLMessageID = getMessageID(kOpenSSLMessageIDPrefix);
    [LDSocketTool shared].endHandMessgeID = getMessageID(kEndHandMessageIDPrefix);
    NSLog(@"\n---【开始握手】---");
    NSLog(@"\n握手（1）");
    [LDSocketTool sendMessage:startHandshakeMessage messageID:[LDSocketTool shared].startHandMessageID success:^(NSString * data) {
        if (!useSSL) {
            if (![data isEqualToString:quickHand0]) {
                NSLog(@"\n不启用SSL加密");
                if (success) {
                    success(nil);
                }
            }
            return ;
        }
        if ([data isEqualToString:quickHand0]) {
            if (success) {
                NSLog(@"\n快速握手开始");
                return ;
            }
        }
        if ([data isEqualToString:quickHand1]) {
            if (success) {
                NSLog(@"\n快速握手完成");
                return ;
            }
        }
        NSLog(@"\n握手（2）");
        [LDSocketTool sendMessage:openSSLMessage messageID:[LDSocketTool shared].openSSLMessageID success:^(id data) {
            NSLog(@"\n握手（3）");
            [LDSocketManager startSSL];
            [LDSocketTool sendMessage:endHandshakeMessage messageID:[LDSocketTool shared].endHandMessgeID success:^(id data) {
                [LDSocketTool shared].isHanding = false;
                NSLog(@"\n握手成功");
                if (success) {
                    success(nil);
                }
            } failure:^(id data) {
                [LDSocketTool shared].isHanding = false;
                if (failure) {
                    failure(data);
                }
            }];
        } failure:^(id data) {
            [LDSocketTool shared].isHanding = false;
            if (failure) {
                failure(data);
            }
        }];
    } failure:^(id data) {
        [LDSocketTool shared].isHanding = false;
        if (failure) {
            failure(data);
        }
    }];
}

+ (void)sendMessage:(NSString *)message messageID:(NSString *)messageID success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    NSLog(@"\n---【发送信息到服务器】---\n%@",message);
    [LDSocketTool saveSuccessBlock:success failureBlock:failure messageID:messageID];
    [LDSocketManager sendMessage:message delegate:[LDSocketTool shared]];
}

#pragma mark - 发完消息后的回调
- (void)receiveMessageResult:(id)result manager:(LDSocketManager *)manager {
    NSString * XMLString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"\n---【收到服务器数据】---\n%@",XMLString);
    //处理握手消息
    BOOL isShakeMessage = [self handleShakeMessage:XMLString];
    if (isShakeMessage) {
        return;
    }
    //断开连接
    if ([XMLString isEqualToString:@"</stream:stream>"]) {
        NSLog(@"\n---【收到服务器主动断开连接的消息】---");
        return;
    }
    //处理其他消息
    NSArray * xmlArray = [LDPacketHandle xml:XMLString];
    if (xmlArray.count == 0) {
        return;
    }
    for (NSString * xml in xmlArray) {
        [self handleMessage:xml];
    }
}

#pragma mark - 工具方法  只在此文件中用
- (BOOL)handleShakeMessage:(NSString *)XMLString {
    //握手第一步如果只回了一部分数据,则我理解为快速握手
    if ([XMLString containsString:@"<stream:stream"] &&
        ![XMLString containsString:@"<stream:features"]) {
        [self callBackByMessageID:[LDSocketTool shared].startHandMessageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if (success) {
                success(quickHand0);
            }
        }];
        return YES;
    }
    //快速握手时，是先回一段数据，紧接着再回下面的数据，此数据可以忽略掉
    if ([XMLString isEqualToString:@"<stream:features><starttls xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"></starttls><auth xmlns=\"http://jabber.org/features/iq-auth\"/><register xmlns=\"http://jabber.org/features/iq-register\"/></stream:features>"]) {
        [self callBackByMessageID:[LDSocketTool shared].startHandMessageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if (success) {
                success(quickHand1);
            }
        }];
        return YES;
    }
    
    //正常握手三步走
    if ([XMLString containsString:@"<stream:features"] && [XMLString containsString:@"starttls"]) {
        //开始握手的回调，在TCL项目中，此消息没有消息id
        [self callBackByMessageID:[LDSocketTool shared].startHandMessageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if (success) {
                success(nil);
            }
        }];
        return YES;
    } else if ([XMLString containsString:@"proceed"]) {
        //开启SSL的回调，在TCL项目中，此消息没有消息id
        [self callBackByMessageID:[LDSocketTool shared].openSSLMessageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if (success) {
                success(nil);
            }
        }];
        return YES;
    } else if ([XMLString containsString:@"<stream:features"]) {
        //结束握手的回调，在TCL项目中，此消息没有消息id
        [self callBackByMessageID:[LDSocketTool shared].endHandMessgeID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            if (success) {
                success(nil);
            }
        }];
        return YES;
    }
    return NO;
}

- (void)handleMessage:(NSString *)message {
    if ([LDInitiativeMsgHandle handleMessage:message]) {
        //如果是主动消息，则不用进行下一步处理
        return;
    }
    NSString * messageID = message.tcl_messageID;
    //标准请求回调的消息，应该是有消息id的
    if (messageID.length > 0 && [messageID containsString:@"-"]) {
        //因为服务器返回的数据可能会有些未转义的字符
        [self callBackByMessageID:messageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
            //如果为响应消息,则直接将该状态消息回传到控制器
            if ([message containsString:@"reportmsgstatus"]) {
                NSString * status = message.tcl_reportMsgStatus;
                if (status) {
                    if (success) {
                        success(status);
                    }
                } else {
                    if (failure) {
                        failure(message);
                    }
                }
                return;
            }
            //非响应消息，则分发到各个模块的分类进行处理
            if ([messageID containsString:@"login_"]) {
                if ([self respondsToSelector:@selector(receiveLoginModuleMessage:messageIDPrefix:success:failure:)]) {
                    [self receiveLoginModuleMessage:message messageIDPrefix:[messageID componentsSeparatedByString:@"-"].firstObject success:success failure:failure];
                }
                
            }
            
            if ([messageID containsString:@"home_"]) {
                if ([self respondsToSelector:@selector(receiveHomeModuleMessage:messageIDPrefix:success:failure:)]) {
                    [self receiveHomeModuleMessage:message messageIDPrefix:[messageID componentsSeparatedByString:@"-"].firstObject success:success failure:failure];
                }
            }
        }];
    }
}
+ (void)saveSuccessBlock:(LDSocketToolBlock)success failureBlock:(LDSocketToolBlock)failure messageID:(NSString *)messageID {
    [[LDSocketTool shared] saveSuccessBlock:success failureBlock:failure messageID:messageID];
}
- (void)saveSuccessBlock:(LDSocketToolBlock)success failureBlock:(LDSocketToolBlock)failure messageID:(NSString *)messageID
{
    if (messageID.length == 0) {
        return;
    }
    NSMutableArray * blocks = [NSMutableArray arrayWithCapacity:3];
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
    [blocks addObject:messageID];
    [self.requestBlocks addObject:blocks];
    //内存中保留的block超过30就移除第一个
    if (self.requestBlocks.count > 30) {
        [self.requestBlocks removeObjectAtIndex:0];
    }
    
}

- (NSArray *)getBlocksByMessageID:(NSString *)messageID {
    for (NSArray * item in self.requestBlocks) {
        if ([item.lastObject isEqualToString:messageID]) {
            return item;
        }
    }
    return nil;
}


-(void)callBackByMessageID:(NSString *)messageID excuteCode:(void (^)(LDSocketToolBlock success, LDSocketToolBlock failure))excuteCode {
    NSArray *  blocks = [self getBlocksByMessageID:messageID];
    if (blocks.count == 3) {
        if (excuteCode) {
            LDSocketToolBlock success;
            if(![blocks[0] isKindOfClass:NSString.self]) {
                success = blocks[0] ;
            }
            LDSocketToolBlock failure;
            if(![blocks[1] isKindOfClass:NSString.self]) {
                failure = blocks[1] ;
            }
            excuteCode(success,failure);
            
        }
    } else {
        NSLog(@"⚠️⚠️⚠️没有找到与MessageID:%@对应的blocks",messageID);
    }
    
}

#pragma mark - 工具方法 LDSocketTool分类也会用到的
+ (NSString *)dicToStr:(NSDictionary *)dic {
    NSError * parseError = nil;
    NSData  * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)strToDic:(NSString *)str {
    if (str.length > 0) {
        NSData * jsonData = [str dataUsingEncoding:NSUTF8StringEncoding]; NSError *err;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        } else {
            return dic;
        }
    }
    return nil;
}

#pragma mark - lazy load
- (NSMutableArray *)requestBlocks
{
    if (_requestBlocks == nil) {
        _requestBlocks = [NSMutableArray array];
    }
    return _requestBlocks;
}

- (NSMutableString *)tempXML {
    if (_tempXML == nil) {
        _tempXML = [NSMutableString string];
    }
    return _tempXML;
}

@end
