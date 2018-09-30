//
//  LDXMLParseTool.h
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/3.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDXMLParseTool : NSObject<NSXMLParserDelegate>
+ (id)parseData:(NSString *)XMLString;
@end
