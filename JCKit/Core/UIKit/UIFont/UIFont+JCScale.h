//
//  UIFont+JCScale.h
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (JCScale)

/************** 根据比例设置字体大小 *******/
/// systemFontOfSize:
+ (nullable UIFont *)scaleFontOfSize:(CGFloat)fontSize;

/// fontWithName:size:
+ (nullable UIFont *)scaleFontWithName:(nonnull NSString *)fontName size:(CGFloat)fontSize;

/**
 粗体
 */
+ (nullable UIFont *)fontNameWithHelveticaBold:(CGFloat)size;

/**
 斜体
 */
+ (nullable UIFont *)fontNameWithHelveticaOblique:(CGFloat)size;

@end