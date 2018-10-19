//
//  NSString+ld_Security.m
//  DigitalAndSecurity
//
//  Created by ld on 2017/12/1.
//  Copyright © 2017年 ld. All rights reserved.
//

#import "NSString+ld_Security.h"
#import <CommonCrypto/CommonCrypto.h>
    
typedef NS_ENUM(NSInteger,EncryptionType){
    EncryptionTypeAES = 0,
    EncryptionTypeDES
};
    
@implementation NSString (ld_Security)
#pragma mark - 散列函数
- (NSString *)md5String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}
    
- (NSString *)sha1String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}
    
- (NSString *)sha256String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
    
- (NSString *)sha512String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}
    
#pragma mark - HMAC 散列函数
- (NSString *)hmacMD5StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}
    
- (NSString *)hmacSHA1StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}
    
- (NSString *)hmacSHA256StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
    
- (NSString *)hmacSHA512StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}
    
- (NSString *)AESEncrypt:(NSString *)key
    {
        NSString * sha256Str = [key sha256String];
        NSData * iv = [[sha256Str dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(0, 8)];
        NSString * encryptStr = [NSString encryptString:self keyString:key iv:iv type:EncryptionTypeAES];
        return encryptStr;
    }
    
- (NSString *)AESDecrypt:(NSString *)key
    {
        NSString * sha256Str = [key sha256String];
        NSData * iv = [[sha256Str dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(0, 8)];
        NSString * decryptStr = [NSString  decryptString:self keyString:key iv:iv type:EncryptionTypeAES];
        return decryptStr;
    }
    
- (NSString *)DESEncrypt:(NSString *)key
    {
        NSString * sha256Str = [key sha256String];
        NSData * iv = [[sha256Str dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(0, 8)];
        NSString * encryptStr = [NSString encryptString:self keyString:key iv:iv type:EncryptionTypeDES];
        return encryptStr;
    }
    
- (NSString *)DESDecrypt:(NSString *)key
    {
        NSString * sha256Str = [key sha256String];
        NSData * iv = [[sha256Str dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(0, 8)];
        NSString * decryptStr = [NSString  decryptString:self keyString:key iv:iv type:EncryptionTypeDES];
        return decryptStr;
    }
    
    /**
     *  加密字符串并返回base64编码字符串
     *
     *  @param string    要加密的字符串
     *  @param keyString 加密密钥
     *  @param iv        初始化向量(8个字节)
     *
     *  @return 返回加密后的base64编码字符串
     */
+ (NSString *)encryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv type:(EncryptionType) type
    {
        /**
         algorithm   kCCAlgorithmAES     高级加密标准，128位(默认)
         algorithm   kCCAlgorithmDES     数据加密标准
         */
        int algorithm,keySize,blockSize;
        switch (type) {
            case EncryptionTypeAES:
            algorithm = kCCAlgorithmAES;
            keySize = kCCKeySizeAES128;
            blockSize = kCCBlockSizeAES128;
            break;
            case EncryptionTypeDES:
            algorithm = kCCAlgorithmDES;
            keySize = kCCKeySizeDES;
            blockSize = kCCBlockSizeDES;
            break;
        }
        
        // 设置秘钥
        NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
        uint8_t cKey[keySize];
        bzero(cKey, sizeof(cKey));
        [keyData getBytes:cKey length:keySize];
        
        // 设置iv
        uint8_t cIv[blockSize];
        bzero(cIv, blockSize);
        int option = 0;
        if (iv) {
            [iv getBytes:cIv length:blockSize];
            option = kCCOptionPKCS7Padding;
        } else {
            option = kCCOptionPKCS7Padding | kCCOptionECBMode;
        }
        
        // 设置输出缓冲区
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        size_t bufferSize = [data length] + blockSize;
        void *buffer = malloc(bufferSize);
        
        // 开始加密
        size_t encryptedSize = 0;
        
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              algorithm,
                                              option,
                                              cKey,
                                              keySize,
                                              cIv,
                                              [data bytes],
                                              [data length],
                                              buffer,
                                              bufferSize,
                                              &encryptedSize);
        
        NSData *result = nil;
        if (cryptStatus == kCCSuccess) {
            result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
        } else {
            free(buffer);
            NSLog(@"[错误] 加密失败|状态编码: %d", cryptStatus);
        }
        
        return [result base64EncodedStringWithOptions:0];
    }
    /**
     *  解密字符串
     *
     *  @param string    加密并base64编码后的字符串
     *  @param keyString 解密密钥
     *  @param iv        初始化向量(8个字节)
     *
     *  @return 返回解密后的字符串
     */
+ (NSString *)decryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv  type:(EncryptionType) type
    {
        /**
         algorithm   kCCAlgorithmAES     高级加密标准，128位(默认)
         algorithm   kCCAlgorithmDES     数据加密标准
         */
        int algorithm,keySize,blockSize;
        switch (type) {
            case EncryptionTypeAES:
            algorithm = kCCAlgorithmAES;
            keySize = kCCKeySizeAES128;
            blockSize = kCCBlockSizeAES128;
            break;
            case EncryptionTypeDES:
            algorithm = kCCAlgorithmDES;
            keySize = kCCKeySizeDES;
            blockSize = kCCBlockSizeDES;
            break;
        }
        
        // 设置秘钥
        NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
        uint8_t cKey[keySize];
        bzero(cKey, sizeof(cKey));
        [keyData getBytes:cKey length:keySize];
        
        // 设置iv
        uint8_t cIv[blockSize];
        bzero(cIv, blockSize);
        int option = 0;
        if (iv) {
            [iv getBytes:cIv length:blockSize];
            option = kCCOptionPKCS7Padding;
        } else {
            option = kCCOptionPKCS7Padding | kCCOptionECBMode;
        }
        
        // 设置输出缓冲区
        NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
        size_t bufferSize = [data length] + blockSize;
        void *buffer = malloc(bufferSize);
        
        // 开始解密
        size_t decryptedSize = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              algorithm,
                                              option,
                                              cKey,
                                              keySize,
                                              cIv,
                                              [data bytes],
                                              [data length],
                                              buffer,
                                              bufferSize,
                                              &decryptedSize);
        
        NSData *result = nil;
        if (cryptStatus == kCCSuccess) {
            result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
        } else {
            free(buffer);
            NSLog(@"[错误] 解密失败|状态编码: %d", cryptStatus);
        }
        
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
#pragma mark - 文件散列函数
    
#define FileHashDefaultChunkSizeForReadingData 4096
    
- (NSString *)fileMD5Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}
    
- (NSString *)fileSHA1Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}
    
    
- (NSString *)fileSHA256Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
    
- (NSString *)fileSHA512Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}
    
#pragma mark - 助手方法
    /**
     *  返回二进制 Bytes 流的字符串表示形式
     *
     *  @param bytes  二进制 Bytes 数组
     *  @param length 数组长度
     *
     *  @return 字符串表示形式
     */
- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}
    @end
