//
//  LDSocketTool.m
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/6.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool.h"
#import "LDSocketManager.h"
#import "LDXMLParseTool.h"

@implementation LDSocketTool
+ (BOOL)connectServer:(NSString *)host port:(NSString *)port success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    return [LDSocketManager connectServer:host port:port.integerValue success:success failure:failure];
}

+ (void)sendMessage:(NSString *)message Success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    NSLog(@"当前请求的信息是:%@",message);
    [LDSocketManager sendMessage:message success:^(NSData *data) {
        id parseData = [LDXMLParseTool parseData:data];
        if (success) {
          success(parseData);
        }
    } failure:^(NSData *data) {
        
    }];
}

+ (void)sendHeartMessage
{
    NSString * heartMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><iq id=\"2801-1533195256761\" to=\"tcl.com\" type=\"get\"><ping xmlns=\"urn:xmpp:ping\"></ping></iq>";
    [LDSocketManager  sendMessage:heartMessage success:^(NSData * data) {
        
    } failure:^(id data) {
        
    }];
}

+ (void)sendHandshakeMessageSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    NSString * startHandshakeMessage=[NSString stringWithFormat:@"<stream:stream to=\"%@\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">",[LDSocketManager host]];
    NSString * endHandshakeMessage = @"<stream:stream to=\"tcl.com\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">";
    NSLog(@"握手（1）");
    [LDSocketTool sendMessage:startHandshakeMessage Success:^(id data) {
        NSLog(@"握手（2）");
        [LDSocketTool sendMessage:data Success:^(id data) {
            NSLog(@"握手（3）");
            [LDSocketManager startSSL];
            [LDSocketTool sendMessage:endHandshakeMessage Success:^(id data) {

            } failure:^(id data) {

            }];

        } failure:^(id data) {
            
        }];
    } failure:^(id data) {
        
    }];
}




@end
