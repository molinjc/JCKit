//
//  UIImage+JCImage.h
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JCImage)

/**
 图片着色
 @param color 颜色
 @param rect  范围
 @param alpha 颜色的透明度 0~1
 */
- (UIImage *)tintedImageWithColor:(UIColor *)color rect:(CGRect)rect alpha:(CGFloat)alpha;
- (UIImage *)tintedImageWithColor:(UIColor *)color;
- (UIImage *)tintedImageWithColor:(UIColor *)color rect:(CGRect)rect;
- (UIImage *)tintedImageWithColor:(UIColor *)color alpha:(CGFloat)alpha;

/**
 等比例缩放图片
 */
- (UIImage *)toScale:(CGFloat)scale;

/**
 调整图片大小
 */
- (UIImage *)resize:(CGSize)size;

/**
 将View转换成图片(截图)
 */
+ (UIImage *)imageWithView:(UIView *)view;

@end
