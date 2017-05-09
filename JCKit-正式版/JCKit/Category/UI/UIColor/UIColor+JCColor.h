//
//  UIColor+JCColor.h
//  JCKit
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR(value) [UIColor colorWithColorObject:value]

@interface UIColor (JCColor)

/** 十六进制数值的颜色，（0x666666） */
+ (UIColor *)colorWithRGB16:(uint32_t)value;
+ (UIColor *)colorWithRGB16:(uint32_t)value alphe:(CGFloat)alpha;

/** RGB颜色各个部分数值，0~1之间的浮点数 */
@property (nonatomic, readonly) CGFloat RGB_red;
@property (nonatomic, readonly) CGFloat RGB_green;
@property (nonatomic, readonly) CGFloat RGB_blue;

/** 颜色的透明度，0~1之间的浮点数 */
@property (nonatomic, readonly) CGFloat alpha;

/** 整数的RGB值转换成颜色类 */
+ (UIColor *)colorWithIntRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha;

/** 将颜色转换成16进制的字符串 */
- (NSString *)stringForRGB16;

/** 随机颜色，透明度默认1 */
+ (UIColor *)randomColor;

/** 随机颜色 */
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

/**
 渐变颜色
 @param c1 开始颜色
 @param c2 结束颜色
 @param height 渐变高度
 */
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(CGFloat)height;

/** object可以是UIColor对象、颜色单词、16进制、RGB值，根据这些创建对此 */
+ (UIColor *)colorWithColorObject:(id)object;

/** 返回颜色是否相同 */
- (BOOL)isEqualToColor:(UIColor *)color;

@end
