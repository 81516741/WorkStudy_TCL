//
//  LDSocketTool+homeReceive.m
//  Project
//
//  Created by lingda on 2018/10/19.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDSocketTool+homeReceive.h"
#import "MessageIDConst.h"
#import "ErrorCode.h"
#import "NSString+tcl_parseXML.h"
#import "XMLTool.h"
#import <GDataXML_HTML/GDataXMLNode.h>

#import <MJExtension/MJExtension.h>
#import "LDDBTool+initiative.h"
#import "LDDBTool+home.h"
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
    NSDictionary * dataDic = [XMLTool dicFromXML:message];
    if ([messageIDPrefix isEqualToString:kGetDeviceListIDPrefix]) {
        [self handleDeviceListMessage:dataDic errorDes:messageError success:success failure:failure];
    } else if ([messageIDPrefix isEqualToString:kGetSceneListIDPrefix]) {
        [self handleSceneMessage:dataDic errorDes:messageError success:success failure:failure];
    } else if ([messageIDPrefix isEqualToString:kGetUserInfoIDPrefix]) {
        [self handleUserInfoMessage:dataDic errorDes:messageError success:success failure:failure];
    }
}
- (void)handleDeviceListMessage:(NSDictionary *)dataDic errorDes:(NSString *)errorDes  success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    NSString * deviceXML = dataDic[@"message"][@"body"];
    NSDictionary * deviceDicList = [XMLTool dicFromXML:deviceXML][@"msg"][@"getCtrDev"][@"group"][@"items"][@"item"];
    NSArray * deviceList = [DeviceModel mj_objectArrayWithKeyValuesArray:deviceDicList];
    ConfigModel * configModel = [LDDBTool getConfigModel];
    for (DeviceModel * device in deviceList) {
        device.currentUserID = configModel.currentUserID;
    }
    [LDDBTool saveDeviceList:deviceList];
    if (success) {
        success(deviceList);
    }
}

- (void)handleSceneMessage:(NSDictionary *)dataDic errorDes:(NSString *)errorDes  success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    NSArray * sceneDicList = dataDic[@"iq"][@"getscenesbyuserid"][@"item"];
    NSArray * sceneList = [SceneModel mj_objectArrayWithKeyValuesArray:sceneDicList];
    ConfigModel * configModel = [LDDBTool getConfigModel];
    for (SceneModel * model in sceneList) {
        model.currentUserID = configModel.currentUserID;
    }
    [LDDBTool saveSceneModels:sceneList];
    if (success) {
        success(sceneList);
    }
}

- (void)handleUserInfoMessage:(NSDictionary *)dataDic errorDes:(NSString *)errorDes  success:(LDSocketToolBlock)success failure:(LDSocketToolBlock)failure {
    NSDictionary * userInfoDic = dataDic[@"iq"][@"getuserinfo"];
    UserInfoModel * userInfoModel = [UserInfoModel mj_objectWithKeyValues:userInfoDic];
    [LDDBTool saveUserInfo:userInfoModel];
    if (success) {
        success(userInfoModel);
    }
}
@end
