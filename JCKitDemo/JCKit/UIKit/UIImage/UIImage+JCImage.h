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

/**
 根据图片名设置图片方向
 */
+ (UIImage *)imageNamed:(NSString *)name orientation:(UIImageOrientation)orientation;
+ (UIImage *)imageNamed:(NSString *)name scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

/**
 根据图片路径设置图片方向
 */
+ (UIImage *)imageWithContentsOfFile:(NSString *)path orientation:(UIImageOrientation)orientation;
+ (UIImage *)imageWithContentsOfFile:(NSString *)path scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

/**
 设置图片方向
 */
- (UIImage *)orientation:(UIImageOrientation)orientation;

@end

@interface UIImage (JCGIF)

/**
 加载未知的Data(不知道是不是Gif)生成图片
 */
+ (UIImage *)imageWithUnknownData:(NSData *)data;

/**
 根据Gif图片名生成UImage对象
 */
+ (UIImage *)animatedGIFNamed:(NSString *)name;

/**
 根据Gif图片的data数据生成UIImage对象
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data;

@end
