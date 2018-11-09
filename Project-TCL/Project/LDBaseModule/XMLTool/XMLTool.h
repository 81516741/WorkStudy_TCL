//
//  JsonXMLConvertTool.h
//  TclIntelliCom
//
//  Created by lingda on 2018/11/8.
//  Copyright © 2018年 tcl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLTool : NSObject
+(NSString *)XMLFromJson:(NSString *)jsonStr;
+(NSString *)h5ParamFromXML:(NSString *)xmlStr;
@end
