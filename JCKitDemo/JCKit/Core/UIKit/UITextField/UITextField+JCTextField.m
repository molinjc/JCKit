//
//  UITextField+JCTextField.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UITextField+JCTextField.h"
#import <objc/runtime.h>

@implementation UITextField (JCTextField)

/**
 设置Placeholder占位符的颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [self setValue:placeholderColor forKey:@"_placeholderLabel.textColor"];
}

@end
