//
//  NSString+str2Dic2str.h
//  TclIntelliCom
//
//  Created by lingda on 2018/11/7.
//  Copyright © 2018年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (str2Dic2str)
- (NSDictionary *)toDic;
@end


@interface NSDictionary ()
- (NSString *)toStr;
- (NSString *)toStrSmall;
@end

