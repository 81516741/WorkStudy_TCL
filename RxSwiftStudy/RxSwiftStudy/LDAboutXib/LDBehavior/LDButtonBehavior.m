//
//  ButtonBehavior.m
//  btc
//
//  Created by lingda on 2017/9/1.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDButtonBehavior.h"
#import "LDTextFieldBehavior.h"
#import "LDImageViewBehavior.h"

@implementation LDButtonBehavior

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.behaviors enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[LDTextFieldBehavior class]]) {
            LDTextFieldBehavior * behavior = (LDTextFieldBehavior *)obj;
            [[behavior.textField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
                [self check];
            }];
            [RACObserve(behavior.textField, text) subscribeNext:^(id  _Nullable x) {
                [self check];
            }];
        }
        
        if ([obj isMemberOfClass:[LDImageViewBehavior class]]) {
            LDImageViewBehavior *  behavior = (LDImageViewBehavior *)obj;
            [RACObserve(behavior.imageView, image) subscribeNext:^(id  _Nullable x) {
                [self check];
            }];
        }
    }];
    [self check];
}


-(BOOL)check
{
    BOOL __block buttonEnable = YES;
    [self.behaviors enumerateObjectsUsingBlock:^(LDBehavior *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        buttonEnable = [obj check] && buttonEnable;
        if (!buttonEnable) {
            *stop = YES;
        }
    }];
    self.button.enabled = buttonEnable;
    if (buttonEnable) {
        [self.button setBackgroundColor:[UIColor redColor]];
    } else {
        [self.button setBackgroundColor:[UIColor lightGrayColor]];
    }
    return buttonEnable;
}

@end
