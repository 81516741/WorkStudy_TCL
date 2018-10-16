//
//  TextFieldBehavior.h
//  btc
//
//  Created by lingda on 2017/9/1.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDBehavior.h"

@interface LDTextFieldBehavior : LDBehavior

/**
 内容的最大长度
 */
@property (assign ,nonatomic)IBInspectable NSInteger textLength;

/**
 内容最小长度
 */
@property (assign ,nonatomic)IBInspectable NSInteger minTextLength;
/**
 此行为关联的控件
 */
@property (nonatomic,weak)IBOutlet UITextField * textField;

@end
