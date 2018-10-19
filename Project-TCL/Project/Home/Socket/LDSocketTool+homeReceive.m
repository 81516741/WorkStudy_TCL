//
//  LDSocketTool+homeReceive.m
//  Project
//
//  Created by lingda on 2018/10/19.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDSocketTool+homeReceive.h"
#import "MessageIDConst.h"
#import "DeviceModel.h"
#import "LDDBTool+home.h"
#import <GDataXML_HTML/GDataXMLNode.h>
#import <MJExtension/MJExtension.h>

@implementation LDSocketTool (homeReceive)
- (void)receiveHomeModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix messageError:(NSString *)messageError success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if (![messageError isEqualToString:@"成功"]) {
        if (failure) {
            failure(messageError);
        }
    }
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:message error:nil];
    if (doc == nil) {
        NSLog(@"\n无法将下面的XML解析成Document\n%@",message);
        if (failure) {
            failure(@"请找个空旷的地方再试试");
        }
        return;
    }
    if ([messageIDPrefix isEqualToString:kGetDeviceListIDPrefix]) {
        [self handleDeviceListMessage:doc errorDes:messageError success:success failure:failure];
    }
}
- (void)handleDeviceListMessage:(GDataXMLDocument *)doc errorDes:(NSString *)errorDes  success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    NSMutableArray * deviceList = [NSMutableArray array];
    NSArray * items = [[[[[[[doc.rootElement children].lastObject children].firstObject children].firstObject children].firstObject children] lastObject] children];
    for (GDataXMLElement * itemEle in items) {
        NSMutableDictionary * itemDic = [NSMutableDictionary dictionary];
        for (GDataXMLNode * node in itemEle.attributes) {
            [itemDic setObject:node.stringValue forKey:node.name];
        }
        [itemDic setObject:@"2004050" forKey:@"licenseid"];
        [deviceList addObject:itemDic];
    }
    NSArray * data = [DeviceModel mj_objectArrayWithKeyValuesArray:deviceList];
    [LDDBTool saveDeviceList:data];
    if (success) {
        success(data);
    }
    
}
@end
