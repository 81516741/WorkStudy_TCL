//
//  HTTPModel.h
//  btc
//
//  Created by lingda on 2017/8/25.
//  Copyright © 2017年 btc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LDHTTPModel;
typedef enum {
    LDHTTPTypePost = 1,
    LDHTTPTypeGet,
    LDHTTPTypeUploadImage
}LDHTTPType;

typedef void(^ _Nonnull Block)( LDHTTPModel * _Nonnull );

@interface LDHTTPModel : NSObject

/**
 快速生成请求模型
 
 @param taskDescription 请求的描述
 @param VCName 发起请求的控制器的名字
 @param dataClass 返回数据需要转成的模型类型，可以为nil
 */
+(LDHTTPModel *)model:(NSString *)taskDescription VCName:(NSString *)VCName dataClass:(Class)dataClass;

/**
 * 请求类型
 */
@property(nonatomic ,assign ) LDHTTPType httpType;
/**
 * 请求参数
 */
@property(nonatomic ,strong ,nonnull) id parameters;
/**
 * 上传图片的参数
 */
@property(nonatomic ,strong ,nonnull) id imageParameters;

/**
 每次请求的token
 */
@property (copy ,nonatomic,nullable)NSString * token;

/**
 * 用于请求的url
 */
@property(nonatomic ,copy ,nonnull) NSString * url;
/**
 * 响应的原始数据
 */
@property(nonatomic ,strong ,nullable) NSDictionary * dataOrigin;

/**
 * 响应数据
 */
@property(nonatomic ,strong ,nullable) id data;

/**
 * 用来判断请求状态成功or失败
 */
@property(nonatomic,assign)NSInteger status;

/**
 * AFN返回的error
 */
@property(nonatomic ,strong ,nullable) NSError * errorOfAFN;
/**
 * 自己服务器返回的error
 */
@property(nonatomic ,strong ,nullable) NSString * errorOfMy;

/**
 * 用于取消HTTP请求的标记
 */
@property(nonatomic ,copy, nullable) NSString * taskDescription;
/**
 发起请求的控制器名字
 */
@property (copy ,nonatomic, nullable)NSString * VCName;
/**
 * 响应数据模型的类型
 */
@property(nonatomic ,strong ,nullable) Class dataClass;

@end

@interface LDHTTPUpdateTokenModel:NSObject
@property (strong ,nonatomic,nullable)LDHTTPModel * httpModel;
@property (copy ,nonatomic)Block success;
@property (copy ,nonatomic)Block failure;
@end

