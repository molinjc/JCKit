//
//  UIColor+JCColor.h
//  JCKit
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JCColor)

/**
 十六进制数值的颜色，（0x666666）
 */
+ (UIColor *)colorWithRGB16:(uint32_t)value;
+ (UIColor *)colorWithRGB16:(uint32_t)value alphe:(CGFloat)alpha;

/**
 RGB颜色各个部分数值，0~1之间的浮点数
 */
@property (nonatomic, readonly) CGFloat RGB_red;
@property (nonatomic, readonly) CGFloat RGB_green;
@property (nonatomic, readonly) CGFloat RGB_blue;

/**
 颜色的透明度，0~1之间的浮点数
 */
@property (nonatomic, readonly) CGFloat alpha;

@end
