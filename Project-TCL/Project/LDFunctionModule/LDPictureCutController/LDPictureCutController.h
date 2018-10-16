//
//  PictureCutToolVC.h
//  btc
//
//  Created by lingda on 2017/9/20.
//  Copyright © 2017年 btc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDPictureCutController : UIViewController

/**
 是否是圆形剪裁
 */
@property (assign ,nonatomic)BOOL isCircleShape;

/**
 要剪裁的图片
 */
@property (strong ,nonatomic)UIImage * image;

/**
 宽:高
 */
@property (assign ,nonatomic)CGFloat ratio;

/**
 透明区域离屏幕左右边距
 */
@property (assign ,nonatomic)CGFloat marginLR;

/**
 图片裁剪后的回调
 */
@property(copy,nonatomic) void(^clipPicResult)(UIImage * image);

@end
