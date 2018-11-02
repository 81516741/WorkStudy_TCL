//
//  LDSocketTool+homeReceive.m
//  Project
//
//  Created by lingda on 2018/10/19.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDSocketTool+homeReceive.h"
#import "MessageIDConst.h"
#import "LDDBTool+home.h"
#import "ErrorCode.h"
#import "LDDBTool+initiative.h"
#import "NSString+tcl_parseXML.h"
#import <GDataXML_HTML/GDataXMLNode.h>
#import <MJExtension/MJExtension.h>


#import "DeviceModel.h"
#import "UserInfoModel.h"
#import "SceneModel.h"


@implementation LDSocketTool (homeReceive)
- (void)receiveHomeModuleMessage:(NSString *)message messageIDPrefix:(NSString *)messageIDPrefix messageError:(NSString *)messageError success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    if (![messageError isEqualToString:errorDesSuccess] && ![messageError isEqualToString:errorCodeNone]) {
        if (failure) {
            failure(messageError);
        }
    }
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:message error:nil];
    if ([messageIDPrefix isEqualToString:kGetDeviceListIDPrefix]) {
        doc = [[GDataXMLDocument alloc] initWithXMLString:message.tcl_convertXML  error:nil];
    }
    if (doc == nil) {
        NSLog(@"\n无法将下面的XML解析成Document\n%@",message);
        if (failure) {
            failure(@"请找个空旷的地方再试试");
        }
        return;
    }
    if ([messageIDPrefix isEqualToString:kGetDeviceListIDPrefix]) {
        [self handleDeviceListMessage:doc errorDes:messageError success:success failure:failure];
    } else if ([messageIDPrefix isEqualToString:kGetSceneListIDPrefix]) {
        [self handleSceneMessage:doc errorDes:messageError success:success failure:failure];
    } else if ([messageIDPrefix isEqualToString:kGetUserInfoIDPrefix]) {
        [self handleUserInfoMessage:doc errorDes:messageError success:success failure:failure];
    }
}
- (void)handleDeviceListMessage:(GDataXMLDocument *)doc errorDes:(NSString *)errorDes  success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    NSMutableArray * deviceList = [NSMutableArray array];
    NSArray * items = [[[[[[[doc.rootElement children].lastObject children].firstObject children].firstObject children].firstObject children] lastObject] children];
    ConfigModel * configModel = [LDDBTool getConfigModel];
    for (GDataXMLElement * itemEle in items) {
        NSMutableDictionary * itemDic = [NSMutableDictionary dictionary];
        for (GDataXMLNode * node in itemEle.attributes) {
            [itemDic setObject:node.stringValue forKey:node.name];
        }
        [itemDic setObject:configModel.currentUserID forKey:@"currentUserID"];
        [deviceList addObject:itemDic];
    }
    NSArray * data = [DeviceModel mj_objectArrayWithKeyValuesArray:deviceList];
    [LDDBTool saveDeviceList:data];
    NSArray * devices = [LDDBTool getDeviceList];
    if (success) {
        success(data);
    }
}

- (void)handleSceneMessage:(GDataXMLDocument *)doc errorDes:(NSString *)errorDes  success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    ConfigModel * configModel = [LDDBTool getConfigModel];
    NSMutableArray * sceneArray = [NSMutableArray array];
    for (GDataXMLElement * ele in [doc.rootElement.children.firstObject children]) {
        if (![ele.name isEqualToString:@"errorcode"]) {
            NSMutableDictionary * itemDic = [NSMutableDictionary dictionary];
            for (GDataXMLElement * eleItem in ele.children) {
                [itemDic setObject:eleItem.stringValue forKey:eleItem.name];
            }
            [itemDic setObject:configModel.currentUserID forKey:@"currentUserID"];
            [sceneArray addObject:itemDic];
        }
    }
    NSArray * scenesModels = [SceneModel mj_objectArrayWithKeyValuesArray:sceneArray];
    [LDDBTool saveSceneModels:scenesModels];
    if (success) {
        success(scenesModels);
    }
}

- (void)handleUserInfoMessage:(GDataXMLDocument *)doc errorDes:(NSString *)errorDes  success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    NSArray * elements = [doc.rootElement.children.firstObject children];
    NSMutableDictionary * userInfoDic = [NSMutableDictionary dictionary];
    for (GDataXMLElement * ele in elements) {
        [userInfoDic setObject:ele.stringValue forKey:ele.name];
    }
    UserInfoModel * userInfoModel = [UserInfoModel mj_objectWithKeyValues:userInfoDic];
    [LDDBTool saveUserInfo:userInfoModel];
    if (success) {
        success(userInfoModel);
    }
}
@end
