//
//  TCLConfigModel.mm
//  Project
//
//  Created by lingda on 2018/10/18.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "TCLConfigModel+WCTTableCoding.h"
#import "TCLConfigModel.h"
#import <WCDB/WCDB.h>
#import <MJExtension/MJExtension.h>
@implementation TCLConfigModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"companyname":@"NameModel",
             @"ad":@"ADModel",
             @"brandname":@"NameModel",
             @"clkdevs":@"CLKDevsModel",
             @"apconfig":@"APConfigModel",
             @"categoryname":@"CategorynameModel",
             };
}


MJCodingImplementation
WCDB_IMPLEMENTATION(TCLConfigModel)

WCDB_SYNTHESIZE(TCLConfigModel,  newhelpandroid)
WCDB_SYNTHESIZE(TCLConfigModel,  newhelpios)
WCDB_SYNTHESIZE(TCLConfigModel,  clkdev)
WCDB_SYNTHESIZE(TCLConfigModel,  cateoptinfosversion)
WCDB_SYNTHESIZE(TCLConfigModel,  companyname)
WCDB_SYNTHESIZE(TCLConfigModel,  serviceagreement)
WCDB_SYNTHESIZE(TCLConfigModel,  tvbindphoneurl)
WCDB_SYNTHESIZE(TCLConfigModel,  scenedevicon)
WCDB_SYNTHESIZE(TCLConfigModel,  reconcnt)
WCDB_SYNTHESIZE(TCLConfigModel,  scanuseridurl)
WCDB_SYNTHESIZE(TCLConfigModel,  reqsharedevurl)
WCDB_SYNTHESIZE(TCLConfigModel,  helpandroid)
WCDB_SYNTHESIZE(TCLConfigModel,  sharecbctime)
WCDB_SYNTHESIZE(TCLConfigModel,  logontimeoutlen)
WCDB_SYNTHESIZE(TCLConfigModel,  banner)
WCDB_SYNTHESIZE(TCLConfigModel,  IOSConfigConsistant)
WCDB_SYNTHESIZE(TCLConfigModel,  ad)
WCDB_SYNTHESIZE(TCLConfigModel,  brandname)
WCDB_SYNTHESIZE(TCLConfigModel,  configConsistant)
WCDB_SYNTHESIZE(TCLConfigModel,  invitecontent)
WCDB_SYNTHESIZE(TCLConfigModel,  helpios)
WCDB_SYNTHESIZE(TCLConfigModel,  acdirections)
WCDB_SYNTHESIZE(TCLConfigModel,  backreconinterval)
WCDB_SYNTHESIZE(TCLConfigModel,  configversion)
WCDB_SYNTHESIZE(TCLConfigModel,  wifiexchangelimit)
WCDB_SYNTHESIZE(TCLConfigModel,  sceneversion)
WCDB_SYNTHESIZE(TCLConfigModel,  uploadsizelimit)
WCDB_SYNTHESIZE(TCLConfigModel,  bannerpic)
WCDB_SYNTHESIZE(TCLConfigModel,  reconinterval)
WCDB_SYNTHESIZE(TCLConfigModel,  heartbeattime)
WCDB_SYNTHESIZE(TCLConfigModel,  privacypolicy)
WCDB_SYNTHESIZE(TCLConfigModel,  reportvideotime)
WCDB_SYNTHESIZE(TCLConfigModel,  sharedevurl)
WCDB_SYNTHESIZE(TCLConfigModel,  IOSWifiPrivateAPI)
WCDB_SYNTHESIZE(TCLConfigModel,  clkdevs)
WCDB_SYNTHESIZE(TCLConfigModel,  apconfig)
WCDB_SYNTHESIZE(TCLConfigModel,  logontimeoutcnt)
WCDB_SYNTHESIZE(TCLConfigModel,  flatlocationversion)
WCDB_SYNTHESIZE(TCLConfigModel,  categoryname)
  
@end

@implementation SceneDevIconModel
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

WCDB_IMPLEMENTATION(SceneVersionModel)
WCDB_SYNTHESIZE(SceneVersionModel, cstconditionver)
WCDB_SYNTHESIZE(SceneVersionModel, cstactionver)
WCDB_SYNTHESIZE(SceneVersionModel, devconditionver)
WCDB_SYNTHESIZE(SceneVersionModel, devactionver)

@end

@implementation NameModel
WCDB_IMPLEMENTATION(NameModel)
WCDB_SYNTHESIZE(NameModel, enname)
WCDB_SYNTHESIZE(NameModel, znname)
@end

@implementation ADModel
WCDB_IMPLEMENTATION(ADModel)
WCDB_SYNTHESIZE(ADModel, pic)
WCDB_SYNTHESIZE(ADModel, link)
@end

@implementation CLKDevsModel
WCDB_IMPLEMENTATION(CLKDevsModel)
WCDB_SYNTHESIZE(CLKDevsModel, ctgr)
WCDB_SYNTHESIZE(CLKDevsModel, page)
@end

@implementation APConfigModel
WCDB_IMPLEMENTATION(APConfigModel)
WCDB_SYNTHESIZE(APConfigModel, company)
WCDB_SYNTHESIZE(APConfigModel, category)
WCDB_SYNTHESIZE(APConfigModel, ip)
WCDB_SYNTHESIZE(APConfigModel, port)
WCDB_SYNTHESIZE(APConfigModel, pwd)
@end

@implementation CategorynameModel
WCDB_IMPLEMENTATION(CategorynameModel)
WCDB_SYNTHESIZE(CategorynameModel, company)
WCDB_SYNTHESIZE(CategorynameModel, brand)
WCDB_SYNTHESIZE(CategorynameModel, enname)
WCDB_SYNTHESIZE(CategorynameModel, znname)
WCDB_SYNTHESIZE(CategorynameModel, bgtitle)
WCDB_SYNTHESIZE(CategorynameModel, level)
WCDB_SYNTHESIZE(CategorynameModel, head)
@end
