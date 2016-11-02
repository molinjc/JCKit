//
//  UITextField+JCTextField.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (JCTextField)

/**
 设置Placeholder占位符的颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor;

/**
 添加正则表达式以及回调(block)
 @param predicate 正则表达式
 @param block     回调结果 YES：满足  NO：不满足
 */
- (void)addPredicate:(NSString *)predicate action:(void (^)(BOOL))block;

/**
 清除正则表达式的Target
 */
- (void)removePredicateTarget;

@end
