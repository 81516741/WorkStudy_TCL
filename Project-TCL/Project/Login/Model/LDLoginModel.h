//
//  LDLoginModel.h
//  Project
//
//  Created by 令达 on 2018/4/10.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDLoginModel : NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) NSArray<LDLoginModel *> * models;
@end
