//
//  TCLSecurityTool.m
//  StaticFrameWork_Example
//
//  Created by lingda on 2019/4/15.
//  Copyright © 2019年 81516741@qq.com. All rights reserved.
//

#import "TCLSecurityTool.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation TCLSecurityTool
+(NSString *)base64Encode:(NSString *)str{
    //1、先转换成二进制数据
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}
+(NSString *)base64Decode:(NSString *)str{
    //注意：该字符串是base64编码后的字符串
    //1、转换为二进制数据（完成了解码的过程）
    NSData *data=[[NSData alloc]initWithBase64EncodedString:str options:0];
    //2、把二进制数据转换成字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
+ (NSString *)md5String:(NSString *)str1 {
    const char *str = str1.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}
+ (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}
+ (NSString *)loginPassword:(NSString *)password {
    NSString * loginPassword = [NSString stringWithFormat:@"TCL%@TCL",self];
    loginPassword = [[self md5String:password] uppercaseString];
    return loginPassword;
}
+ (NSString *)bleDataWithSSID:(NSString *)ssid password:(NSString *)password bindCode:(NSString *)bindCode {
    NSString * msg = [NSString stringWithFormat:@"TCL(SSID:%@;PWD:%@;BIND_CODE:%@;)TCL",ssid,password,bindCode];
    msg = [self base64Encode:msg];
    return msg;
}
+ (NSString *)deCodeBLEData:(NSString *)data {
    NSString * deCodeData= [self base64Decode:data];
    return deCodeData;
}
+ (NSString *)N_UUID {
    return @"0000A007-0000-1000-8000-00805F9B34FB";
}
+ (NSString *)W_UUID {
    return @"0000A1CE-0000-1000-8000-00805F9B34FB";
    
}
+ (NSString *)S_UUID {
    return @"0000FFB1-0000-1000-8000-00805F9B34FB";
    
}
@end
