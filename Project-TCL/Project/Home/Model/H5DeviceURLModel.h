//
//  H5DeviceURLModel.h
//  Project
//
//  Created by lingda on 2018/11/15.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface H5DeviceURLModel : NSObject
@property(copy, nonatomic)NSString * ID;
@property(copy, nonatomic)NSString * modelid;
@property(copy, nonatomic)NSString * menuname;
@property(copy, nonatomic)NSString * des;
@property(copy, nonatomic)NSString * sort;
@property(copy, nonatomic)NSString * status;
@property(copy, nonatomic)NSString * parentid;
@property(copy, nonatomic)NSString * type;
@property(copy, nonatomic)NSString * clickFunction;
@property(copy, nonatomic)NSString * leaf;
@property(copy, nonatomic)NSArray * childrens;
@end
