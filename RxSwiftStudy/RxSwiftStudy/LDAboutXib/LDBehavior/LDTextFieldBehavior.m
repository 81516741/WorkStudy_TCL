//
//  TextFieldBehavior.m
//  btc
//
//  Created by lingda on 2017/9/1.
//  Copyright © 2017年 btc. All rights reserved.
//

#import "LDTextFieldBehavior.h"

@interface LDTextFieldBehavior ()
@property (nonatomic,strong) NSMutableArray * checkSel;
@end

@implementation LDTextFieldBehavior

-(void)setTextField:(UITextField *)textField
{
    _textField = textField;
    [RACObserve(textField,text) subscribeNext:^(id  _Nullable x) {
        [self check];
    }];
    [[textField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self check];
    }];
    
}

- (void)setTextLength:(NSInteger)textLength
{
    _textLength = textLength;
    [self.checkSel addObject:NSStringFromSelector(@selector(checkTextFieldLength:))];
}

- (void)setMinTextLength:(NSInteger)minTextLength
{
    _minTextLength = minTextLength;
    [self.checkSel addObject:NSStringFromSelector(@selector(checkMinTextFieldLength:))];
}

-(BOOL)checkTextFieldLength:(UITextField *)textField
{
    if (textField.text.length > self.textLength) {
        textField.text = [textField.text substringToIndex:self.textLength];
        return YES;
    }
    if (textField.text.length == self.textLength) {
        return YES;
    }
    return NO;
}

-(BOOL)checkMinTextFieldLength:(UITextField *)textField
{
    if (textField.text.length >= self.minTextLength) {
        return YES;
    }
    return NO;
}

-(BOOL)check
{
    BOOL __block result = YES;
    [self.checkSel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        result = [self performSelector:NSSelectorFromString(obj) withObject:self.textField] && result;
#pragma clang diagnostic pop
        if (result == NO) {
            *stop = YES;
        }
    }];
    return result;
}


- (NSMutableArray *)checkSel
{
    if (_checkSel == nil) {
        _checkSel = [NSMutableArray array];
    }
    return _checkSel;
}


@end
