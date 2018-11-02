//
//  ConfigModel.h
//  Project
//
//  Created by lingda on 2018/10/18.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    otherDeviceLoginStateNone = 0,//其他设备没有登录
    otherDeviceLogined,//其他设备登录了，我被挤下线
    myDeviceRelogin,//挤下线后，我选择了重登录
    myDeviceLoginOut//挤下线后，我选择退出登录
}OtherDeviceLoginState;

@class SceneVersionModel,SceneDevIconModel,NameModel,ADModel,CLKDevsModel,APConfigModel,CategorynameModel;

@interface ConfigModel : NSObject
@property (nonatomic , strong) NSArray               * companyname;
@property (nonatomic , strong) NSArray              * ad;
@property (nonatomic , strong) NSArray              * brandname;
@property (nonatomic , strong) NSArray              * clkdevs;
@property (nonatomic , strong) NSArray              * apconfig;
@property (nonatomic , strong) NSArray              * categoryname;
@property (nonatomic , strong) SceneVersionModel    * sceneversion;
@property (nonatomic , strong) SceneDevIconModel    * scenedevicon;
@property (nonatomic , copy) NSString              * newhelpandroid;
@property (nonatomic , copy) NSString              * newhelpios;
@property (nonatomic , copy) NSString              * clkdev;
@property (nonatomic , copy) NSString              * cateoptinfosversion;
@property (nonatomic , copy) NSString              * serviceagreement;
@property (nonatomic , copy) NSString              * tvbindphoneurl;
@property (nonatomic , copy) NSString              * reconcnt;
@property (nonatomic , copy) NSString              * scanuseridurl;
@property (nonatomic , copy) NSString              * reqsharedevurl;
@property (nonatomic , copy) NSString              * helpandroid;
@property (nonatomic , copy) NSString              * sharecbctime;
@property (nonatomic , copy) NSString              * logontimeoutlen;
@property (nonatomic , copy) NSString              * banner;
@property (nonatomic , copy) NSString              * IOSConfigConsistant;
@property (nonatomic , copy) NSString              * configConsistant;
@property (nonatomic , copy) NSString              * invitecontent;
@property (nonatomic , copy) NSString              * helpios;
@property (nonatomic , copy) NSString              * acdirections;
@property (nonatomic , copy) NSString              * backreconinterval;
@property (nonatomic , copy) NSString              * configversion;
@property (nonatomic , copy) NSString              * wifiexchangelimit;
@property (nonatomic , copy) NSString              * uploadsizelimit;
@property (nonatomic , copy) NSString              * bannerpic;
@property (nonatomic , copy) NSString              * reconinterval;
@property (nonatomic , copy) NSString              * heartbeattime;
@property (nonatomic , copy) NSString              * privacypolicy;
@property (nonatomic , copy) NSString              * reportvideotime;
@property (nonatomic , copy) NSString              * sharedevurl;
@property (nonatomic , copy) NSString              * IOSWifiPrivateAPI;
@property (nonatomic , copy) NSString              * logontimeoutcnt;
@property (nonatomic , copy) NSString              * flatlocationversion;

@property (nonatomic,strong)NSString * randCode;//保存登录成功后的会话随机数
@property (nonatomic,strong)NSString * currentUserID;//当前用户的智讯ID
@property (nonatomic,strong)NSString * currentUserPassword;//当前用户的密码摘要
/*otherDeviceLoginState 用来确定是否要重新登录的，可以直接搜项目全局
看有哪些地方赋值和使用，一看就明白的*/
@property(assign, nonatomic) OtherDeviceLoginState otherDeviceLoginState;


@end

@interface SceneDevIconModel :NSObject

@property (nonatomic , copy) NSString              * AB;
@property (nonatomic , copy) NSString              * MM;
@property (nonatomic , copy) NSString              * bql;
@property (nonatomic , copy) NSString              * DSeries;
@property (nonatomic , copy) NSString              * GD;
@property (nonatomic , copy) NSString              * ZJRQR;
@property (nonatomic , copy) NSString              * ZJRQR2P;
@property (nonatomic , copy) NSString              * SPFWASUB;
@property (nonatomic , copy) NSString              * SP;
@property (nonatomic , copy) NSString              * SW;
@property (nonatomic , copy) NSString              * SW1;
@property (nonatomic , copy) NSString              * SW2;
@property (nonatomic , copy) NSString              * SW3;
@property (nonatomic , copy) NSString              * SW4;
@property (nonatomic , copy) NSString              * DS;
@property (nonatomic , copy) NSString              * xhyds;
@property (nonatomic , copy) NSString              * ECT;
@property (nonatomic , copy) NSString              * ECT_100;
@property (nonatomic , copy) NSString              * VM;
@property (nonatomic , copy) NSString              * hmvm;
@property (nonatomic , copy) NSString              * EF;
@property (nonatomic , copy) NSString              * BS;
@property (nonatomic , copy) NSString              * SOS;
@property (nonatomic , copy) NSString              * hmsos;
@property (nonatomic , copy) NSString              * hmbs;
@property (nonatomic , copy) NSString              * LioneerSWO;
@property (nonatomic , copy) NSString              * SWO;
@property (nonatomic , copy) NSString              * ZHSWO;
@property (nonatomic , copy) NSString              * CLKSN95Y;
@property (nonatomic , copy) NSString              * CLF6NK4U;
@property (nonatomic , copy) NSString              * CL;
@property (nonatomic , copy) NSString              * AC;
@property (nonatomic , copy) NSString              * LY;
@property (nonatomic , copy) NSString              * BCD_216;
@property (nonatomic , copy) NSString              * GS;
@property (nonatomic , copy) NSString              * hmgs;
@property (nonatomic , copy) NSString              * GL;
@property (nonatomic , copy) NSString              * tsgl;
@property (nonatomic , copy) NSString              * SLK;
@property (nonatomic , copy) NSString              * WDR_200;
@property (nonatomic , copy) NSString              * PDB;
@property (nonatomic , copy) NSString              * ToseePDB;
@property (nonatomic , copy) NSString              * ZSC;
@property (nonatomic , copy) NSString              * ZSC4;
@property (nonatomic , copy) NSString              * RT;
@property (nonatomic , copy) NSString              * RT249B01;
@property (nonatomic , copy) NSString              * CA;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * hmid;
@property (nonatomic , copy) NSString              * EFRBPKS5;
@property (nonatomic , copy) NSString              * zmwl;
@property (nonatomic , copy) NSString              * PW;
@property (nonatomic , copy) NSString              * DW;
@property (nonatomic , copy) NSString              * SD;
@property (nonatomic , copy) NSString              * hmsd;
@property (nonatomic , copy) NSString              * JSSeries;
@property (nonatomic , copy) NSString              * SC;
@property (nonatomic , copy) NSString              * htgw;
@property (nonatomic , copy) NSString              * GW;
@property (nonatomic , copy) NSString              * WH;
@property (nonatomic , copy) NSString              * EWH;
@property (nonatomic , copy) NSString              * annica;
@property (nonatomic , copy) NSString              * Z2;
@property (nonatomic , copy) NSString              * WRS;
@property (nonatomic , copy) NSString              * LioneerWRS;
@property (nonatomic , copy) NSString              * RF;
@property (nonatomic , copy) NSString              * ISeries;
@property (nonatomic , copy) NSString              * TRO;
@property (nonatomic , copy) NSString              * enecai;
@property (nonatomic , copy) NSString              * WL;
@property (nonatomic , copy) NSString              * zmlb;
@property (nonatomic , copy) NSString              * TV;
@property (nonatomic , copy) NSString              * GowildRT;
@property (nonatomic , copy) NSString              * RaysgemMM;
@property (nonatomic , copy) NSString              * SS;
@property (nonatomic , copy) NSString              * zytdsp_chn;
@end


@interface SceneVersionModel :NSObject

@property (nonatomic , copy) NSString              * cstconditionver;
@property (nonatomic , copy) NSString              * cstactionver;
@property (nonatomic , copy) NSString              * devconditionver;
@property (nonatomic , copy) NSString              * devactionver;

@end


@interface NameModel : NSObject
@property(copy, nonatomic) NSString * enname;
@property(copy, nonatomic) NSString * znname;
@end

@interface ADModel : NSObject
@property(copy, nonatomic) NSString * pic;
@property(copy, nonatomic) NSString * link;
@end

@interface CLKDevsModel : NSObject
@property(copy, nonatomic) NSString * ctgr;
@property(copy, nonatomic) NSString * page;
@end

@interface APConfigModel : NSObject
@property(copy, nonatomic) NSString * company;
@property(copy, nonatomic) NSString * category;
@property(copy, nonatomic) NSString * ip;
@property(copy, nonatomic) NSString * port;
@property(copy, nonatomic) NSString * pwd;
@end

@interface CategorynameModel : NSObject
@property(copy, nonatomic) NSString * company;
@property(copy, nonatomic) NSString * brand;
@property(copy, nonatomic) NSString * enname;
@property(copy, nonatomic) NSString * znname;
@property(copy, nonatomic) NSString * bgtitle;
@property(copy, nonatomic) NSString * level;
@property(copy, nonatomic) NSString * head;
@end
