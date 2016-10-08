//
//  UIImage+JCImage.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIImage+JCImage.h"
#import "NSData+JCData.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (JCImage)

#pragma mark - 颜色

- (UIImage *)tintedImageWithColor:(UIColor *)color {
    return [self tintedImageWithColor:color rect:CGRectMake(0, 0, self.size.width, self.size.height) alpha:1.0];
}

- (UIImage *)tintedImageWithColor:(UIColor *)color rect:(CGRect)rect {
    return [self tintedImageWithColor:color rect:rect alpha:1.0];
}

- (UIImage *)tintedImageWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    return [self tintedImageWithColor:color rect:CGRectMake(0, 0, self.size.width, self.size.height) alpha:alpha];
}

/**
 图片着色
 @param color 颜色
 @param rect  范围
 @param alpha 颜色的透明度 0~1
 */
- (UIImage *)tintedImageWithColor:(UIColor *)color rect:(CGRect)rect alpha:(CGFloat)alpha {
    CGRect imageRect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawInRect:imageRect];
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, alpha);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, rect);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                             scale:self.scale
                                       orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return darkImage;
}

/**
 生成一张纯色的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage;
}

#pragma mark - Image Size

/**
 等比例缩放图片
 */
- (UIImage *)toScale:(CGFloat)scale {
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0.0, 0.0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaleImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage ;
}

/**
 调整图片大小
 */
- (UIImage *)resize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    
    //从当前context中创建一个改变大小后的图片
    UIImage *resizeImage =UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return resizeImage ;
}

/**
 所占的内存大小
 */
- (NSUInteger)memorySize {
    return CGImageGetHeight(self.CGImage) * CGImageGetBytesPerRow(self.CGImage);
}

#pragma mark - 截图

/**
 将View转换成图片(截图)
 */
+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 方向

/**
 根据图片名设置图片方向
 */
+ (UIImage *)imageNamed:(NSString *)name orientation:(UIImageOrientation)orientation {
    UIImage *image = [UIImage imageNamed:name];
    return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:orientation];
}

+ (UIImage *)imageNamed:(NSString *)name scale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
    UIImage *image = [UIImage imageNamed:name];
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:orientation];
}

/**
 根据图片路径设置图片方向
 */
+ (UIImage *)imageWithContentsOfFile:(NSString *)path orientation:(UIImageOrientation)orientation {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:orientation];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path scale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:orientation];
}

/**
 设置图片方向
 */
- (UIImage *)orientation:(UIImageOrientation)orientation {
    return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:orientation];
}

#pragma mark - 绘制

- (UIImage *)imageWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    return [self imageWithText:text textColor:[UIColor whiteColor] fontSize:fontSize];
}

- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    // 文字居中显示在画布上
    NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;   // 文字居中
    return [self imageWithText:text textColor:textColor fontSize:fontSize paragraphStyle:paragraphStyle];
}

/**
 图片上绘制文字
 @param text      所要绘制的文字
 @param textColor 文字的颜色
 @param fontSize  文字的大小，这里没有 * __scale，所以要文字适配，可能要在传入参数之前就要做适配了。
 @param paragraphStyle 文字的样式
 @return 返回新的图片
 */
- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(self.size.width, self.size.height);  // 画布大小
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);        // 创建一个基于位图的上下文
    [self drawAtPoint:CGPointMake(0.0, 0.0)];
    
   
    CGSize textSize = [text boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGRect rect = CGRectMake((size.width - textSize.width) / 2,
                             (size.height - textSize.height) / 2,
                             textSize.width,
                             textSize.height);
    // 绘制文字
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:font,
                                           NSForegroundColorAttributeName:textColor,
                                           NSParagraphStyleAttributeName:paragraphStyle}];
    
    // 返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation UIImage (JCGIF)

/**
 加载未知的Data(不知道是不是Gif)生成图片
 */
+ (UIImage *)imageWithUnknownData:(NSData *)data {
    NSString *imageContentType = data.imageDataContentType;
    if ([imageContentType isEqualToString:@"image/gif"]) {
        return [UIImage animatedGIFWithData:data];
    }else {
        return [UIImage imageWithData:data];
    }
}

/**
 根据Gif图片名生成UImage对象
 */
+ (UIImage *)animatedGIFNamed:(NSString *)name {
    NSString *gifName = name;
    if ([UIScreen mainScreen].scale > 1.0f) {
        gifName = [name stringByAppendingString:@"@2x"];
    }
    NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:retinaPath];
    if (data) {
        return [UIImage animatedGIFWithData:data];
    }
    return [UIImage imageNamed:name];
}

/**
 根据Gif图片的data数据生成UIImage对象
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i=0; i<count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!duration) {
            duration = (1.0 / 10.0) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}

+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
