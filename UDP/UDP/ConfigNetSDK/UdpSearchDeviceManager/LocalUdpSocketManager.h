//
//  LocalUdpSocketManager.h
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalUdpSocketManager : NSObject
- (void)configUdpSocket:(NSString *)host port:(NSString *)port bindPort:(NSString *)bindPort;
- (void)sendMsg:(NSString *)msg;
- (void)closeUdpSocket;
@property(nonatomic,copy) void(^messageHandle)(NSString *);
@property(nonatomic,copy) void(^errorHandle)(NSString *);
@end
