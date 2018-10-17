//
//  LDSocketTool+home.m
//  TestSocket
//
//  Created by lingda on 2018/10/10.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDSocketTool+home.h"
#import "MessageIDConst.h"
#import "LDSysTool.h"
#import "GDataXMLNode.h"
#import "NSString+tcl_parseXML.h"
#import "DeviceModel.h"
#import <MJExtension/MJExtension.h>
#import "LDDBTool+home.h"

@implementation LDSocketTool (home)

+ (void)getDeviceListSuccess:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure
{
    NSString * messageID = getMessageID(kGetDeviceListIDPrefix);
    NSString * message = [NSString stringWithFormat:@"\
<message id=\"%@\" type=\"chat\" to=\"tcl.com\">\
  <body>\
    <msg cmd=\"getCtrDev\" type=\"common\" seq=\"%@\">\
        <getCtrDev>\
            <thirdlabel>jdiot</thirdlabel>\
        </getCtrDev>\
    </msg>\
  </body>\
  <x xmlns=\"tcl:im:attribute\">\
    <apptype>0</apptype>\
    <msgtype>1</msgtype>\
  </x>\
</message>",
    messageID,kGetDeviceListIDPrefix];
    [self sendMessage:message messageID:messageID success:success failure:failure];
}
- (void)receiveHomeModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix messageError:(NSString *)messageError success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:message error:nil];
    if (doc == nil) {
        NSLog(@"\n无法将下面的XML解析成Document\n%@",message);
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
        [deviceList addObject:itemDic];
    }
    NSArray * arr = [DeviceModel mj_objectArrayWithKeyValuesArray:deviceList];
    [LDDBTool saveDeviceList:arr];
    success(arr);
    
}
@end
