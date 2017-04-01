//
//  UILabel+JCLabel.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/3/31.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JCLabel)

/**
 设置渐变, 两个颜色
 @param colors 渐变颜色组
 */
- (void)setLinearGradientWithColor:(NSArray <UIColor *> *)colors;

/**
 设置渐变动画
 @param colors 渐变颜色组, 样式为这样的: @[@[color1, color2], ... , @[colorN-1, colorN], ]
 */
- (void)setGradientChromatoAnimation:(NSArray *)colors;

@end
