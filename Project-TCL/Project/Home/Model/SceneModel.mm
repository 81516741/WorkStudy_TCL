//
//  SceneModel.mm
//  Project
//
//  Created by lingda on 2018/10/29.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "SceneModel+WCTTableCoding.h"
#import "SceneModel.h"
#import <WCDB/WCDB.h>

@implementation SceneModel
WCDB_IMPLEMENTATION(SceneModel)
WCDB_SYNTHESIZE(SceneModel,operation)
WCDB_SYNTHESIZE(SceneModel,iconUrl)
WCDB_SYNTHESIZE(SceneModel,updatetime)
WCDB_SYNTHESIZE(SceneModel,sceneFlag)
WCDB_SYNTHESIZE(SceneModel,sceneName)
WCDB_SYNTHESIZE(SceneModel,sid)
WCDB_SYNTHESIZE(SceneModel,type)
WCDB_SYNTHESIZE(SceneModel,lasttime)
WCDB_SYNTHESIZE(SceneModel,currentUserID)
@end
