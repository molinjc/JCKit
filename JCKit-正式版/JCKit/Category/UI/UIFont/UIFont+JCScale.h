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
+ (UIFont *)scaleFontOfSize:(CGFloat)fontSize;

/// fontWithName:size:
+ (UIFont *)scaleFontWithName:(NSString *)fontName size:(CGFloat)fontSize;

/**
 粗体
 */
+ (UIFont *)fontNameWithHelveticaBold:(CGFloat)size;

/**
 斜体
 */
+ (UIFont *)fontNameWithHelveticaOblique:(CGFloat)size;

/**
 加载本地TTF字体，字体大小默认15
 */
+ (UIFont *)fontWithTTFAtPath:(NSString *)path;

/**
 加载本地TTF字体
 @param path 本地TTF字体的路径
 @param size 字体大小
 */
+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size;

@end
