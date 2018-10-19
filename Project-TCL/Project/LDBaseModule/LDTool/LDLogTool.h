//
//  LDLogTool.h
//  Project
//
//  Created by 令达 on 2018/4/8.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LDLogTool : NSObject
+ (void)configDDLog;
void Log(id message);
+ (void)Log:(id) message;
@end
