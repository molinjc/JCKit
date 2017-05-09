//
//  UIImageView+JCImageView.h
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JCImageView)

/** 设置图片名 */
- (void)setImageNamed:(NSString *)named;

/** 倒影 */
- (void)imageReflect;

/**
 设置渐变动画
 @param colors 渐变颜色组, 样式为这样的: @[@[color1, color2], ... , @[colorN-1, colorN], ]
 */
- (void)gradientChromatoAnimationWithColors:(NSArray *)colors;

/**
 画水印, 先设置image，否则watermark就赋值给image
 @param watermark 水印图
 @param rect 水印图的位置
 */
- (void)watermark:(UIImage *)watermark inRect:(CGRect)rect;

/**
 人脸识别，调整图片显示的位置
 @param aImage 图片
 @param fast YES： 高精度， NO： 低精度
 */
- (void)faceDetectWithImage:(UIImage *)aImage fast:(BOOL)fast;

@end
