//
//  ButtonBehavior.h
//  btc
//
//  Created by lingda on 2017/9/1.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDBehavior.h"
@interface LDButtonBehavior : LDBehavior


/**
 此行为关联的其它行为
 */
@property (nonatomic,copy)IBOutletCollection(LDBehavior) NSArray * behaviors;

/**
 此行为关联的控件
 */
@property (nonatomic,weak)IBOutlet UIButton * button;
@end
