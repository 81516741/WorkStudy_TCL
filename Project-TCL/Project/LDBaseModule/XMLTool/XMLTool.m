//
//  JsonXMLConvertTool.m
//  TclIntelliCom
//
//  Created by lingda on 2018/11/8.
//  Copyright © 2018年 tcl. All rights reserved.
//

#import "XMLTool.h"
#import "XMLWriter.h"
#import "XMLReader.h"
#import "GDataXMLNode.h"
#import "NSString+str2Dic2str.h"
#import "NSString+tcl_parseXML.h"

@implementation XMLTool
/*
 将
 <confing>
    <attr>
        <name>1</name>
        <address>2</address>
    </attr>
 </config>
 转化成
 <config name='1' address='2'></config>
 */
+(void)handleElementAttr:(GDataXMLElement*)element{
    NSMutableArray * shouldRemoveEle = [NSMutableArray array];
    for (GDataXMLElement*c in element.children) {
        if ([c.name isEqualToString:@"attr"]) {
            for (GDataXMLElement * c1 in c.children) {
                [element addAttribute:c1];
            }
            [shouldRemoveEle addObject:c];
        }
    }
    for (GDataXMLElement * el in shouldRemoveEle) {
        [element removeChild:el];
    }
    for (GDataXMLElement*e in element.children) {
        [self handleElementAttr:e];
    }
}

/*
 将
 <confing>
    <name>
      <id>3</id>
    </name>
    <address>2</address>
 </config>
 转化成
 <config address='2'>
    <name id='3'/>
 </config>
 */
+ (void)handElementText:(GDataXMLElement *)element {
    NSMutableArray * shouldRemoveEle = [NSMutableArray array];
    for (GDataXMLElement * child in element.children) {
        if (child.children.count == 1 && [child.children.firstObject children] == nil) {
            [shouldRemoveEle addObject:child];
            [element addAttribute:child];
        }
    }
    for (GDataXMLElement * el in shouldRemoveEle) {
        [element removeChild:el];
    }
    
    for (GDataXMLElement * el in element.children) {
        [self handElementText:el];
    }
}

+(NSString *)XMLFromJson:(NSString *)jsonStr {
    NSDictionary * dic = jsonStr.toDic;
    if (dic == nil) {
        NSLog(@"需要转成XML的json字符串格式不对");
        return nil;
    }
    NSString * xmlStr = [XMLWriter XMLStringFromDictionary:dic];
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr error:nil];
    GDataXMLElement * rootEle = doc.rootElement;
    [self handleElementAttr:rootEle];
    NSString * result = rootEle.XMLString;
    return result;
}

+ (NSDictionary *)dicFromXML:(NSString *)xmlStr {
    NSError * error = nil;
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr error:&error];
    if (error != nil) {
        NSLog(@"需要转成json的XML格式不对");
        return nil;
    }
    GDataXMLElement * rootEle = doc.rootElement;
    [self handElementText:rootEle];
    NSDictionary * dict = [XMLReader dictionaryForXMLString:rootEle.XMLString error:&error];
    return dict;
}

+ (NSString *)h5ParamFromXML:(NSString *)xmlStr {
    NSError * error = nil;
    NSDictionary * dict = [XMLReader dictionaryForXMLString:xmlStr error:&error][@"message"][@"body"];
    NSString * result0 = [NSString stringWithFormat:@"%@#%@#%@",dict.toStrSmall,xmlStr.tcl_fromID,dict[@"msg"][@"seq"]];
    NSString * result = [result0 stringByReplacingOccurrencesOfString:@"XMLText" withString:@"value"];
    return result;
}

@end
