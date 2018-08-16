//
//  LDXMLParseTool.m
//  TestSocket
//
//  Created by TCL-MAC on 2018/8/3.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDXMLParseTool.h"
#import "GDataXMLNode.h"
@implementation LDXMLParseTool

+ (instancetype)share
{
    static LDXMLParseTool * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LDXMLParseTool new];
    });
    return _instance;
}

+ (id)parseData:(NSData *)data
{
    NSString * XMLString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (XMLString.length <= 0) {
        NSLog(@"xml数据解析错误");
        return nil;
    }
    NSLog(@"\n--------当前要解析的xml数据是--------\n%@",XMLString);
    id parseData;
    if ([XMLString hasPrefix:@"<reply>"] && [XMLString containsString:@"<ip>"] && [XMLString containsString:@"<port>"]) {
        NSLog(@"开始解析IP 和 端口号");
        parseData = [self parseIPAndPort:XMLString];
    } else if ([XMLString containsString:@"<starttls"] && [XMLString containsString:@"<register"]) {
        NSLog(@"开始解析第一次XMPP流的回调数据");
        parseData = [self parseFirstXMPPStream:XMLString];
    } else if ([XMLString containsString:@"<proceed"]) {
        NSLog(@"建立TLS安全连接的回调");
        parseData = @{@"TLS":@"success"};
    }
    if (parseData != nil) {
         NSLog(@"\n--------解析后的数据是--------\n%@",parseData);
        return parseData;
    }
    return XMLString;
}

+ (NSDictionary *)parseIPAndPort:(NSString *)XMLString
{
    NSArray * dataArray = [self parseXMLStringToArray:XMLString];
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < dataArray.count; i ++) {
        GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:dataArray[i] error:nil];
        if (doc == nil) {
            return nil;
        }
        GDataXMLElement * rootElement = [doc rootElement];
        if ([rootElement.name isEqualToString:@"ip"]) {
            [dataDic setObject:[rootElement.children[0] XMLString] forKey:@"ip"];
        }else if ([rootElement.name isEqualToString:@"port"]) {
            [dataDic setObject:[rootElement.children[0] XMLString] forKey:@"port"];
        }else if ([rootElement.name isEqualToString:@"errorcode"]) {
            [dataDic setObject:[rootElement.children[0] XMLString] forKey:@"errorcode"];
        }
        
    }
    return dataDic;
}

+ (NSString *)parseFirstXMPPStream:(NSString *)XMLString
{
    XMLString = [XMLString substringWithRange:[LDXMLParseTool rangeOfStarttls:XMLString]];
    return XMLString;
}

+ (NSArray *)parseXMLStringToArray:(NSString *)XMLString
{
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithXMLString:XMLString error:nil];
    if (doc == nil)
    {
        return nil;
    }
    NSMutableArray *resArray = [[NSMutableArray alloc] initWithCapacity:24];
    GDataXMLElement *fristElement = [doc rootElement];
    
    NSArray *array = [fristElement children];
    if([array count] < 1)
    {
        return nil;
    }
    
    for (int i = 0; i< [array count];i++)
    {
        [resArray addObject:[(GDataXMLElement *)[array objectAtIndex:i] XMLString]];
    }
    return resArray;
}

#pragma mark - private method
+ (NSRange)rangeOfStarttls:(NSString *)XMLString
{
    NSUInteger desXMLStartLocation = [XMLString rangeOfString:@"<starttls"].location;
    NSUInteger desXMLEndLocation = [XMLString rangeOfString:@"</starttls>"].location + @"</starttls>".length;
    return NSMakeRange(desXMLStartLocation, desXMLEndLocation - desXMLStartLocation);
}


@end
