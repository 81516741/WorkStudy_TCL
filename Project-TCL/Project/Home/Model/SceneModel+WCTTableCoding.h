//
//  SceneModel+WCTTableCoding.h
//  Project
//
//  Created by lingda on 2018/10/29.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "SceneModel.h"
#import <WCDB/WCDB.h>

@interface SceneModel (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(operation)
WCDB_PROPERTY(iconUrl)
WCDB_PROPERTY(updatetime)
WCDB_PROPERTY(sceneFlag)
WCDB_PROPERTY(sceneName)
WCDB_PROPERTY(sid)
WCDB_PROPERTY(type)
WCDB_PROPERTY(lasttime)
WCDB_PROPERTY(currentUserID)
@end
