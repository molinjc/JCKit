//
//  UIImage+JCImage.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIImage+JCImage.h"

@implementation UIImage (JCImage)

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
 将View转换成图片(截图)
 */
+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
