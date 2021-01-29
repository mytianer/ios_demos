//
//  UITextField+Helper.m
//  Xchat
//
//  Created by zwj on 2020/12/25.
//

#import "UITextField+Helper.h"
#import <objc/runtime.h>

static const NSString * maxLengthKey = @"UITextField.maxLengthKey";

@implementation UITextField(helper)


- (void)setMaxLength:(int)maxLength {
    objc_setAssociatedObject(self,
                             &maxLengthKey,
                             @(maxLength),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (maxLength > 0) {
        [self addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (int)maxLength {
    return [objc_getAssociatedObject(self, &maxLengthKey) intValue];
}

-(void)textFieldDidChanged:(UITextField *)tf {
    NSString * toBeString = tf.text;
    if (tf.maxLength > 0 && toBeString.length > 0 && toBeString.length > tf.maxLength) {
        tf.text = [toBeString substringToIndex:tf.maxLength];
    }
}


@end
