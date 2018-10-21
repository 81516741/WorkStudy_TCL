//
//  LDSocketTool.m
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/6.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDDBTool+initiative.h"
#import "ConfigModel.h"

#import "LDSocketTool.h"
#import "LDSocketManager.h"
#import "MessageIDConst.h"
#import "LDPacketHandle.h"
#import "LDHTTPTool.h"
#import "LDNetTool.h"
#import "ErrorCode.h"
#import "LDLogTool.h"
#import "LDSysTool.h"
#import "NSString+tcl_parseXML.h"


NSString * const quickHand0 = @"quickHand0";
NSString * const quickHand1 = @"quickHand1";
BOOL useSSL = false;
NSInteger autoLoginMaxCount = 2;
//为什么没有handFailure，因为握手失败就是超时，此时会断开连接
typedef enum {
    disConnect = 10,
    connecting,
    connected,
    handing,
    handed
}ConnectState;

@interface LDSocketTool()<LDSocketManagerConnectProtocol,LDSocketManagerSendMessageProtocol>
/**
 连接状态
 */
@property(assign, nonatomic) ConnectState connectState;

/**
 检查网络的次数，心跳用
 */
@property(assign, nonatomic) NSInteger checkNetCount;
/**
 心跳用的计时器
 */
@property(strong, nonatomic) dispatch_source_t timer;
/**
 发消息的队列   串行
 */
@property(strong, nonatomic) dispatch_queue_t messageQueue;
/**
 发握手的队列   串行
 */
@property(strong, nonatomic) dispatch_queue_t handQueue;
/**
 自动登录的队列   串行
 */
@property(strong, nonatomic) dispatch_queue_t autoLoginQueue;
/**
 心跳的队列   串行
 */
@property(strong, nonatomic) dispatch_queue_t heartQueue;

//以下几个属性是用来辅助block回调的，因为没有和服务器约定id，属于历史遗留问题
@property(copy, nonatomic) NSString * connectMessageID;
@property(copy, nonatomic) NSString * startHandMessageID;
@property(copy, nonatomic) NSString * openSSLMessageID;
@property(copy, nonatomic) NSString * endHandMessgeID;
@property(copy, nonatomic) NSString * startHandshakeMessage;
@property(copy, nonatomic) NSString * openSSLMessage;
@property(copy, nonatomic) NSString * endHandshakeMessage;

@end

@implementation LDSocketTool
+ (instancetype)shared {
    static LDSocketTool * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LDSocketTool new];
        _instance.connectState = disConnect;
        _instance.loginState = @"1";
        _instance.autoLoginErrorCount = 0;
        _instance.isAutoLoginFailure = YES;
        _instance.messageQueue = dispatch_queue_create("message_queue", DISPATCH_QUEUE_SERIAL);
        _instance.handQueue = dispatch_queue_create("hand_queue", DISPATCH_QUEUE_SERIAL);
        _instance.autoLoginQueue = dispatch_queue_create("autoLogin_queue", DISPATCH_QUEUE_SERIAL);
        _instance.heartQueue = dispatch_queue_create("heart_queue", DISPATCH_QUEUE_SERIAL);
    });
    return _instance;
}
#pragma mark - 连接和心跳
+ (void)startConnectAndHeart {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LDSocketTool shared].timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer([LDSocketTool shared].timer, 0, 5ull * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler([LDSocketTool shared].timer, ^{
            static NSInteger checkCount = 0;
            if ([LDNetTool networkReachable]) {
                checkCount ++;
                if ([LDSocketTool shared].connectState == disConnect) {
                    [LDSocketTool buildConnectingSuccess:nil failure:nil];
                } else if ([LDSocketTool shared].connectState == handed && checkCount > 4) {
                    checkCount = 0;
                    [LDSocketTool sendHeartMessageSuccess:nil failure:nil];
                }
            }
        });
        dispatch_resume([LDSocketTool shared].timer);
    });
}

#pragma  mark - 连接服务器
+ (BOOL)connectServer:(NSString *)host port:(NSString *)port success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    if ([LDSocketTool shared].connectState == connecting) {
        return NO;
    }
    [LDSocketTool shared].connectState = connecting;
    [LDSocketTool shared].connectMessageID = getMessageID(kConnecctServiceMessageIDPrefix);
    [LDSocketTool saveSuccessBlock:success
                      failureBlock:failure messageID:[LDSocketTool shared].connectMessageID];
    return [LDSocketManager connectServer:host port:port.integerValue delegate:[LDSocketTool shared]];
}

- (void)receiveConnectServiceResult:(id)result manager:(LDSocketManager *)manager {
    if ([result isEqualToString:@"连接成功"]) {
        [LDSocketTool shared].connectState = connected;
        //连接成功时，是肯定是没有登录服务器的
        [LDSocketTool shared].loginState = @"1";
        //连接成功的时候，这个值必须设置成YES，不然不会去自动登录
        [LDSocketTool shared].isAutoLoginFailure = YES;
    } else {
        [LDSocketTool shared].connectState = disConnect;
    }
    [self callBackByMessageID:[LDSocketTool shared].connectMessageID excuteCode:^(LDSocketToolBlock success, LDSocketToolBlock failure) {
        if ([result isKindOfClass:NSString.self]) {
            if ([result isEqualToString:@"连接成功"]) {
                if (success) {
                    success(nil);
                }
            } else {
                if (failure) {
                    failure(result);
                }
            }
        }
    }];
}
#pragma mark - 发消息给服务器
+ (void)sendMessage:(NSString *)message messageID:(NSString *)messageID success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    //是否是握手消息
    BOOL isHandMessage = [message isEqualToString:[LDSocketTool shared].startHandshakeMessage] || [message isEqualToString:[LDSocketTool shared].openSSLMessage] || [message isEqualToString:[LDSocketTool shared].endHandshakeMessage];
    if (isHandMessage) {
        dispatch_async([LDSocketTool shared].handQueue, ^{
            Log([NSString stringWithFormat:@"\n---【发送信息到服务器】---\n%@",message]);
            [LDSocketTool saveSuccessBlock:success failureBlock:failure messageID:messageID];
            [LDSocketManager sendMessage:message delegate:[LDSocketTool shared]];
        });
    } else {
        ConfigModel * model = [LDDBTool getConfigModel];
        //自动登录
        if ([[LDSocketTool shared].loginState isEqualToString:@"1"] &&
            [LDNetTool networkReachable] &&
            model.currentUserPassword.length > 0) {
            if ([LDSocketTool shared].autoLoginErrorCount < autoLoginMaxCount) {
                dispatch_async([LDSocketTool shared].autoLoginQueue, ^{
                    while ([[LDSocketTool shared].loginState isEqualToString:@"1"]) {
                        if ([LDSocketTool shared].autoLoginErrorCount > autoLoginMaxCount) {
                            break;
                        }
                        if ([LDSocketTool shared].isAutoLoginFailure) {
                            [LDSocketTool shared].isAutoLoginFailure = NO;
                           [LDSocketTool autoLogin:model];
                        }
                        sleep(5);
                    }
                });
            }
        }
        
        if ([message containsString:@"heart-"]) {
            //发送心跳消息
            dispatch_async([LDSocketTool shared].heartQueue, ^{
                [LDSocketTool saveSuccessBlock:success failureBlock:failure messageID:messageID];
                [LDSocketManager sendMessage:message delegate:[LDSocketTool shared]];
            });
        } else {
            //发送普通消息
            dispatch_async([LDSocketTool shared].messageQueue, ^{
                {
                    //应该登录
                    BOOL shouldLogin = model.currentUserPassword.length > 0 && [LDSocketTool shared].autoLoginErrorCount < autoLoginMaxCount;
                    if (shouldLogin) {//应该是登录的
                        //没有登录就卡死
                        while ([[LDSocketTool shared].loginState isEqualToString:@"1"]) {
                            if ([LDSocketTool shared].autoLoginErrorCount > autoLoginMaxCount) {
                                break;
                            }
                            Log([NSString stringWithFormat:@"\n---【没网了或者没握手,所以暂停发送信息】---\n%@",message]);
                            sleep(2);
                        }
                    }
                    //如果没有握手 或者没有网络就卡死该线程
                    while (![LDNetTool networkReachable] ||[LDSocketTool shared].connectState != handed) {
                        Log([NSString stringWithFormat:@"\n---【没网了或者没握手,所以暂停发送信息】---\n%@",message]);
                        sleep(2);
                    }
                    Log([NSString stringWithFormat:@"\n---【发送信息到服务器】---\n%@",message]);
                    [LDSocketTool saveSuccessBlock:success failureBlock:failure messageID:messageID];
                    [LDSocketManager sendMessage:message delegate:[LDSocketTool shared]];
                }
            });
        }
        
        
    }
}

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
    if ([LDSocketTool shared].connectState == handing) {
        return;
    }
    [LDSocketTool shared].connectState = handing;
    NSString * startHandshakeMessage = [NSString stringWithFormat:@"<stream:stream to=\"%@\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">",[LDSocketManager host]];
    [LDSocketTool shared].startHandshakeMessage = startHandshakeMessage;
    NSString * openSSLMessage = @"<starttls xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>";
    [LDSocketTool shared].openSSLMessageID =openSSLMessage;
    NSString * endHandshakeMessage = @"<stream:stream to=\"tcl.com\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">";
    [LDSocketTool shared].endHandshakeMessage = endHandshakeMessage;
    [LDSocketTool shared].startHandMessageID = getMessageID(kStartHandMessageIDPrefix);
    [LDSocketTool shared].openSSLMessageID = getMessageID(kOpenSSLMessageIDPrefix);
    [LDSocketTool shared].endHandMessgeID = getMessageID(kEndHandMessageIDPrefix);
    Log(@"\n---【开始握手】---");
    Log(@"\n握手（1）");
    [LDSocketTool sendMessage:startHandshakeMessage messageID:[LDSocketTool shared].startHandMessageID success:^(NSString * data) {
        if (!useSSL) {
            if (![data isEqualToString:quickHand0]) {
                Log(@"\n不启用SSL加密");
                [LDSocketTool shared].connectState = handed;
                [LDSocketTool sendHeartMessageSuccess:nil failure:nil];
                if (success) {
                    success(nil);
                }
            }
            return ;
        }
        if ([data isEqualToString:quickHand0]) {
            if (success) {
                Log(@"\n快速握手开始");
                return ;
            }
        }
        if ([data isEqualToString:quickHand1]) {
            if (success) {
                Log(@"\n快速握手完成");
                [LDSocketTool shared].connectState = handed;
                [LDSocketTool sendHeartMessageSuccess:nil failure:nil];
                return ;
            }
        }
        Log(@"\n握手（2）");
        [LDSocketTool sendMessage:openSSLMessage messageID:[LDSocketTool shared].openSSLMessageID success:^(id data) {
            Log(@"\n握手（3）");
            [LDSocketManager startSSL];
            [LDSocketTool sendMessage:endHandshakeMessage messageID:[LDSocketTool shared].endHandMessgeID success:^(id data) {
                Log(@"\n握手成功");
                [LDSocketTool shared].connectState = handed;
                [LDSocketTool sendHeartMessageSuccess:nil failure:nil];
                if (success) {
                    success(nil);
                }
            } failure:nil];
        } failure:nil];
    } failure:nil];
}
+ (void)autoLogin:(ConfigModel *)configModel
{
    NSString * messageID = getMessageID(kAutoLoginMessageIDPrefix);
    NSString * configVersion = @"0";
    if (configModel.configversion.length > 0) {
        configVersion = configModel.configversion;
    }
    NSDictionary * dic = @{
                           @"joinid":[LDSysTool joinID],
                           @"configversion":configVersion,
                           @"lang":[LDSysTool languageType],
                           @"devicetype":[LDSysTool deviceType],
                           @"company":[LDSysTool company],
                           @"version":[LDSysTool version],
                           @"token":[LDSysTool UUIDString],
                           @"type":[LDSysTool TID],
                           @"pwd":configModel.currentUserPassword
                           };
    NSString * passwordStr = [LDSocketTool dicToStr:dic];
    
    NSString * message = [NSString stringWithFormat:@"\
                          <?xml version=\"1.0\" encoding=\"utf-8\"?>\
                          <iq type=\"set\" id=\"%@\">\
                          <query xmlns=\"jabber:iq:auth\">\
                          <username>%@</username>\
                          <resource>PH-ios-zx01-4</resource>\
                          <password>%@</password>\
                          </query>\
                          </iq>",messageID,configModel.currentUserID,passwordStr];
    Log(@"\n---发起自动登录---");
    [LDSocketManager sendMessage:message delegate:[LDSocketTool shared]];
}
+ (void)buildConnectingSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    
    [LDHTTPTool getIPAndPortSuccess:^(LDHTTPModel * model) {
        [LDSocketTool connectServer:model.data[@"ip"] port:model.data[@"port"] success:^(id data) {
            [LDSocketTool sendHandshakeMessageSuccess:^(id data) {
                if (success) {
                   success(data);
                }
            } failure:nil];
        } failure:nil];
    } failure:^(LDHTTPModel * model) {
        [LDSocketTool shared].connectState = disConnect;
        if (failure) {
            failure(model);
        }
    }];
}
#pragma mark - 发完消息后的回调
- (void)receiveMessageResult:(id)result manager:(LDSocketManager *)manager {
    NSString * XMLString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    Log([NSString stringWithFormat:@"\n---【收到服务器数据】---\n%@",XMLString]);
    //处理握手消息
    BOOL isShakeMessage = [self handleShakeMessage:XMLString];
    if (isShakeMessage) {
        return;
    }
    //断开连接
    if ([XMLString isEqualToString:@"</stream:stream>"]) {
        Log(@"\n---【收到服务器主动断开连接的消息】---");
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
    NSString * messageID = message.tcl_messageID;
    NSString * messageError = getErrorDescription (message.tcl_errorCode);
    if ([LDInitiativeMsgHandle handleMessage:message messageID:messageID messageError:messageError]) {
        //如果是主动消息，则不用进行下一步处理
        return;
    }
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
                if ([self respondsToSelector:@selector(receiveLoginModuleMessage:messageIDPrefix:messageError:success:failure:)]) {
                    [self receiveLoginModuleMessage:message messageIDPrefix:[messageID componentsSeparatedByString:@"-"].firstObject messageError:messageError success:success failure:failure];
                }  
            }
            
            if ([messageID containsString:@"home_"]) {
                if ([self respondsToSelector:@selector(receiveHomeModuleMessage:messageIDPrefix: messageError:success:failure:)]) {
                    [self receiveHomeModuleMessage:message messageIDPrefix:[messageID componentsSeparatedByString:@"-"].firstObject messageError:messageError success:success failure:failure];
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
        Log([NSString stringWithFormat:@"⚠️⚠️⚠️没有找到与MessageID:%@对应的blocks",messageID]);
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
            Log([NSString stringWithFormat:@"json解析失败：%@",err]);
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


@end
