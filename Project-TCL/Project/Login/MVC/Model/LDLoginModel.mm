//
//  LDLoginModel.mm
//  Project
//
//  Created by 令达 on 2018/4/10.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDLoginModel+WCTTableCoding.h"
#import "LDLoginModel.h"
#import <WCDB/WCDB.h>
#import <MJExtension/MJExtension.h>

@implementation LDLoginModel
MJCodingImplementation
WCDB_IMPLEMENTATION(LDLoginModel)
WCDB_SYNTHESIZE(LDLoginModel, name)
WCDB_SYNTHESIZE(LDLoginModel, image)
WCDB_SYNTHESIZE(LDLoginModel, models)
  
@end
