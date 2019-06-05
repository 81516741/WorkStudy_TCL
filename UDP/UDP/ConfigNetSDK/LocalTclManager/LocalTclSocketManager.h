//
//  LocalTclSocketManager.h
//  TclIntelliCom
//
//  Created by lingda on 2019/1/10.
//  Copyright © 2019年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalTclSocketManager : NSObject
- (void)connectToHost:(NSString *)host port:(NSString *)port;
- (void)sendMsg:(NSString *)msg ;
- (void)disconnect;
@property(nonatomic,copy) void(^messageHandle)(NSString * msg);
@property(nonatomic,copy) void(^connectHandle)(BOOL connected);
@end
