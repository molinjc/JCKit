//
//  UIImage+JCImage.h
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JCImage)

+ (UIImage *)imageWithName:(NSString *)name;

/**
 原图
 */
- (UIImage *)originalImage;

#pragma mark - 颜色

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
 生成一张纯色的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 灰度图片
 */
- (UIImage*)grayImage;

/**
 设置图片透明度
 */
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

#pragma mark - Image Size

/**
 等比例缩放图片
 */
- (UIImage *)toScale:(CGFloat)scale;

/**
 调整图片大小
 */
- (UIImage *)resize:(CGSize)size;

/**
 所占的内存大小
 */
- (NSUInteger)memorySize;

/**
 从中心向外拉伸
 */
- (UIImage *)centerOutwardStretching;

#pragma mark - 截图

/**
 将View转换成图片(截图)
 */
+ (UIImage *)imageWithView:(UIView *)view;

/**
 截取image里的rect区域内的图片
 */
- (UIImage *)subimageInRect:(CGRect)rect;

#pragma mark - 方向

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

/**
 水平翻转
 */
- (UIImage *)flipHorizontal;

/**
 垂直翻转
 */
- (UIImage *)flipVertical;

#pragma mark - 绘制

/**
 图片上绘制文字
 @param text      所要绘制的文字
 @param textColor 文字的颜色
 @param fontSize  文字的大小，这里没有 * __scale，所以要文字适配，可能要在传入参数之前就要做适配了。
 @param paragraphStyle 文字的样式
 @return 返回新的图片
 */
- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize paragraphStyle:(NSParagraphStyle *)paragraphStyle;
- (UIImage *)imageWithText:(NSString *)text fontSize:(CGFloat)fontSize;
- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;

@end

#pragma mark - GIF

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

@interface UIImage (JCQRCode)

/**
 生成二维码图片
 @param string 信息
 @param size 大小
 */
+ (UIImage *)QRCodeImageWithString:(NSString *)string size:(CGFloat)size;

/**
 二维码图片内容信息
 */
- (NSString *)QRCodeImageContext;

@end
