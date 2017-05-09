//
//  UILabel+JCLabel.h
//
//  Created by molin.JC on 2017/3/31.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 垂直对齐方式
 - JCTextVerticalAlignmentCenter: 垂直居中
 - JCTextVerticalAlignmentTop: 垂直顶部对齐
 - JCTextVerticalAlignmentBottom: 垂直底部对齐
 */
typedef NS_ENUM(NSUInteger, JCTextVerticalAlignment) {
    JCTextVerticalAlignmentCenter = 0,
    JCTextVerticalAlignmentTop,
    JCTextVerticalAlignmentBottom,
};

@interface UILabel (JCLabel)

/** 垂直对齐方式 */
@property (nonatomic, assign) JCTextVerticalAlignment textVerticalAlignment;
/** 文本显示内距 */
@property (nonatomic, assign) UIEdgeInsets textInset;

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
