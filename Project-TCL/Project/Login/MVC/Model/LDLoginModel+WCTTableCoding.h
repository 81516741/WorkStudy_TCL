//
//  LDLoginModel+WCTTableCoding.h
//  Project
//
//  Created by 令达 on 2018/4/10.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDLoginModel.h"
#import <WCDB/WCDB.h>

@interface LDLoginModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(name)
WCDB_PROPERTY(image)
WCDB_PROPERTY(models)

@end
