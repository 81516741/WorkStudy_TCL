//
//  ConfigModel.mm
//  Project
//
//  Created by lingda on 2018/10/18.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "ConfigModel+WCTTableCoding.h"
#import "ConfigModel.h"
#import <WCDB/WCDB.h>
#import <MJExtension/MJExtension.h>
@implementation ConfigModel
MJCodingImplementation
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"companyname":@"NameModel",
             @"ad":@"ADModel",
             @"brandname":@"NameModel",
             @"clkdevs":@"CLKDevsModel",
             @"apconfig":@"APConfigModel",
             @"categoryname":@"CategorynameModel",
             };
}

WCDB_IMPLEMENTATION(ConfigModel)
WCDB_SYNTHESIZE(ConfigModel,  companyname)
WCDB_SYNTHESIZE(ConfigModel,  ad)
WCDB_SYNTHESIZE(ConfigModel,  brandname)
WCDB_SYNTHESIZE(ConfigModel,  clkdevs)
WCDB_SYNTHESIZE(ConfigModel,  apconfig)
WCDB_SYNTHESIZE(ConfigModel,  categoryname)
WCDB_SYNTHESIZE(ConfigModel,  newhelpandroid)
WCDB_SYNTHESIZE(ConfigModel,  newhelpios)
WCDB_SYNTHESIZE(ConfigModel,  clkdev)
WCDB_SYNTHESIZE(ConfigModel,  cateoptinfosversion)
WCDB_SYNTHESIZE(ConfigModel,  serviceagreement)
WCDB_SYNTHESIZE(ConfigModel,  tvbindphoneurl)
WCDB_SYNTHESIZE(ConfigModel,  scenedevicon)
WCDB_SYNTHESIZE(ConfigModel,  reconcnt)
WCDB_SYNTHESIZE(ConfigModel,  scanuseridurl)
WCDB_SYNTHESIZE(ConfigModel,  reqsharedevurl)
WCDB_SYNTHESIZE(ConfigModel,  helpandroid)
WCDB_SYNTHESIZE(ConfigModel,  sharecbctime)
WCDB_SYNTHESIZE(ConfigModel,  logontimeoutlen)
WCDB_SYNTHESIZE(ConfigModel,  banner)
WCDB_SYNTHESIZE(ConfigModel,  IOSConfigConsistant)
WCDB_SYNTHESIZE(ConfigModel,  configConsistant)
WCDB_SYNTHESIZE(ConfigModel,  invitecontent)
WCDB_SYNTHESIZE(ConfigModel,  helpios)
WCDB_SYNTHESIZE(ConfigModel,  acdirections)
WCDB_SYNTHESIZE(ConfigModel,  backreconinterval)
WCDB_SYNTHESIZE(ConfigModel,  configversion)
WCDB_SYNTHESIZE(ConfigModel,  wifiexchangelimit)
WCDB_SYNTHESIZE(ConfigModel,  sceneversion)
WCDB_SYNTHESIZE(ConfigModel,  uploadsizelimit)
WCDB_SYNTHESIZE(ConfigModel,  bannerpic)
WCDB_SYNTHESIZE(ConfigModel,  reconinterval)
WCDB_SYNTHESIZE(ConfigModel,  heartbeattime)
WCDB_SYNTHESIZE(ConfigModel,  privacypolicy)
WCDB_SYNTHESIZE(ConfigModel,  reportvideotime)
WCDB_SYNTHESIZE(ConfigModel,  sharedevurl)
WCDB_SYNTHESIZE(ConfigModel,  IOSWifiPrivateAPI)
WCDB_SYNTHESIZE(ConfigModel,  logontimeoutcnt)
WCDB_SYNTHESIZE(ConfigModel,  flatlocationversion)
WCDB_SYNTHESIZE(ConfigModel,  randCode)
WCDB_SYNTHESIZE(ConfigModel,  currentUserID)
WCDB_SYNTHESIZE(ConfigModel,  currentUserPassword)

@end

@implementation SceneDevIconModel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ECT_100":@"ECT-100",
             @"WDR_200":@"WDR-200",
             @"BCD_216":@"BCD-216",
             @"zytdsp_chn":@"zytdsp-chn"
             };
}
WCDB_IMPLEMENTATION(SceneDevIconModel)
WCDB_SYNTHESIZE(SceneDevIconModel, annica)
WCDB_SYNTHESIZE(SceneDevIconModel, AB)
WCDB_SYNTHESIZE(SceneDevIconModel, MM)
WCDB_SYNTHESIZE(SceneDevIconModel, bql)
WCDB_SYNTHESIZE(SceneDevIconModel, DSeries)
WCDB_SYNTHESIZE(SceneDevIconModel, GD)
WCDB_SYNTHESIZE(SceneDevIconModel, ZJRQR)
WCDB_SYNTHESIZE(SceneDevIconModel, ZJRQR2P)
WCDB_SYNTHESIZE(SceneDevIconModel, SPFWASUB)
WCDB_SYNTHESIZE(SceneDevIconModel, SP)
WCDB_SYNTHESIZE(SceneDevIconModel, SW)
WCDB_SYNTHESIZE(SceneDevIconModel, SW1)
WCDB_SYNTHESIZE(SceneDevIconModel, SW2)
WCDB_SYNTHESIZE(SceneDevIconModel, SW3)
WCDB_SYNTHESIZE(SceneDevIconModel, SW4)
WCDB_SYNTHESIZE(SceneDevIconModel, DS)
WCDB_SYNTHESIZE(SceneDevIconModel, xhyds)
WCDB_SYNTHESIZE(SceneDevIconModel, ECT)
WCDB_SYNTHESIZE(SceneDevIconModel, ECT_100)
WCDB_SYNTHESIZE(SceneDevIconModel, VM)
WCDB_SYNTHESIZE(SceneDevIconModel, hmvm)
WCDB_SYNTHESIZE(SceneDevIconModel, EF)
WCDB_SYNTHESIZE(SceneDevIconModel, BS)
WCDB_SYNTHESIZE(SceneDevIconModel, SOS)
WCDB_SYNTHESIZE(SceneDevIconModel, hmsos)
WCDB_SYNTHESIZE(SceneDevIconModel, hmbs)
WCDB_SYNTHESIZE(SceneDevIconModel, LioneerSWO)
WCDB_SYNTHESIZE(SceneDevIconModel, SWO)
WCDB_SYNTHESIZE(SceneDevIconModel, ZHSWO)
WCDB_SYNTHESIZE(SceneDevIconModel, CLKSN95Y)
WCDB_SYNTHESIZE(SceneDevIconModel, CLF6NK4U)
WCDB_SYNTHESIZE(SceneDevIconModel, CL)
WCDB_SYNTHESIZE(SceneDevIconModel, AC)
WCDB_SYNTHESIZE(SceneDevIconModel, LY)
WCDB_SYNTHESIZE(SceneDevIconModel, BCD_216)
WCDB_SYNTHESIZE(SceneDevIconModel, GS)
WCDB_SYNTHESIZE(SceneDevIconModel, hmgs)
WCDB_SYNTHESIZE(SceneDevIconModel, GL)
WCDB_SYNTHESIZE(SceneDevIconModel, tsgl)
WCDB_SYNTHESIZE(SceneDevIconModel, SLK)
WCDB_SYNTHESIZE(SceneDevIconModel, WDR_200)
WCDB_SYNTHESIZE(SceneDevIconModel, PDB)
WCDB_SYNTHESIZE(SceneDevIconModel, ToseePDB)
WCDB_SYNTHESIZE(SceneDevIconModel, ZSC)
WCDB_SYNTHESIZE(SceneDevIconModel, ZSC4)
WCDB_SYNTHESIZE(SceneDevIconModel, RT)
WCDB_SYNTHESIZE(SceneDevIconModel, RT249B01)
WCDB_SYNTHESIZE(SceneDevIconModel, CA)
WCDB_SYNTHESIZE(SceneDevIconModel, ID)
WCDB_SYNTHESIZE(SceneDevIconModel, hmid)
WCDB_SYNTHESIZE(SceneDevIconModel, EFRBPKS5)
WCDB_SYNTHESIZE(SceneDevIconModel, zmwl)
WCDB_SYNTHESIZE(SceneDevIconModel, PW)
WCDB_SYNTHESIZE(SceneDevIconModel, DW)
WCDB_SYNTHESIZE(SceneDevIconModel, SD)
WCDB_SYNTHESIZE(SceneDevIconModel, hmsd)
WCDB_SYNTHESIZE(SceneDevIconModel, JSSeries)
WCDB_SYNTHESIZE(SceneDevIconModel, SC)
WCDB_SYNTHESIZE(SceneDevIconModel, htgw)
WCDB_SYNTHESIZE(SceneDevIconModel, GW)
WCDB_SYNTHESIZE(SceneDevIconModel, WH)
WCDB_SYNTHESIZE(SceneDevIconModel, EWH)
WCDB_SYNTHESIZE(SceneDevIconModel, Z2)
WCDB_SYNTHESIZE(SceneDevIconModel, WRS)
WCDB_SYNTHESIZE(SceneDevIconModel, LioneerWRS)
WCDB_SYNTHESIZE(SceneDevIconModel, RF)
WCDB_SYNTHESIZE(SceneDevIconModel, ISeries)
WCDB_SYNTHESIZE(SceneDevIconModel, TRO)
WCDB_SYNTHESIZE(SceneDevIconModel, enecai)
WCDB_SYNTHESIZE(SceneDevIconModel, WL)
WCDB_SYNTHESIZE(SceneDevIconModel, zmlb)
WCDB_SYNTHESIZE(SceneDevIconModel, TV)
WCDB_SYNTHESIZE(SceneDevIconModel, GowildRT)
WCDB_SYNTHESIZE(SceneDevIconModel, RaysgemMM)
WCDB_SYNTHESIZE(SceneDevIconModel, SS)
WCDB_SYNTHESIZE(SceneDevIconModel, zytdsp_chn)

@end

@implementation SceneVersionModel
MJCodingImplementation

WCDB_IMPLEMENTATION(SceneVersionModel)
WCDB_SYNTHESIZE(SceneVersionModel, cstconditionver)
WCDB_SYNTHESIZE(SceneVersionModel, cstactionver)
WCDB_SYNTHESIZE(SceneVersionModel, devconditionver)
WCDB_SYNTHESIZE(SceneVersionModel, devactionver)

@end

@implementation NameModel
MJCodingImplementation
WCDB_IMPLEMENTATION(NameModel)
WCDB_SYNTHESIZE(NameModel, enname)
WCDB_SYNTHESIZE(NameModel, znname)
@end

@implementation ADModel
MJCodingImplementation
WCDB_IMPLEMENTATION(ADModel)
WCDB_SYNTHESIZE(ADModel, pic)
WCDB_SYNTHESIZE(ADModel, link)
@end

@implementation CLKDevsModel
MJCodingImplementation
WCDB_IMPLEMENTATION(CLKDevsModel)
WCDB_SYNTHESIZE(CLKDevsModel, ctgr)
WCDB_SYNTHESIZE(CLKDevsModel, page)
@end

@implementation APConfigModel
MJCodingImplementation
WCDB_IMPLEMENTATION(APConfigModel)
WCDB_SYNTHESIZE(APConfigModel, company)
WCDB_SYNTHESIZE(APConfigModel, category)
WCDB_SYNTHESIZE(APConfigModel, ip)
WCDB_SYNTHESIZE(APConfigModel, port)
WCDB_SYNTHESIZE(APConfigModel, pwd)
@end

@implementation CategorynameModel
MJCodingImplementation
WCDB_IMPLEMENTATION(CategorynameModel)
WCDB_SYNTHESIZE(CategorynameModel, company)
WCDB_SYNTHESIZE(CategorynameModel, brand)
WCDB_SYNTHESIZE(CategorynameModel, enname)
WCDB_SYNTHESIZE(CategorynameModel, znname)
WCDB_SYNTHESIZE(CategorynameModel, bgtitle)
WCDB_SYNTHESIZE(CategorynameModel, level)
WCDB_SYNTHESIZE(CategorynameModel, head)
@end
