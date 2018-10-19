//
//  HTTPModel.m
//  btc
//
//  Created by lingda on 2017/8/25.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDHTTPModel.h"

@implementation LDHTTPModel
+(LDHTTPModel *)model:(NSString *)taskDescription VCName:(NSString *)VCName dataClass:(Class)dataClass
{
    LDHTTPModel * model = [LDHTTPModel new];
    model.taskDescription = taskDescription;
    model.VCName = VCName;
    model.dataClass = dataClass;
    return model;
}
@end

@implementation LDHTTPUpdateTokenModel

@end
