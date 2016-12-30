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

+ (UIImage *)imageWithName:(NSString *)name {
    if (!name.length) {
        return nil;
    }
    // 按屏幕的比例查找对应的几x图
    NSString *res = name.stringByDeletingPathExtension;
    if ([UIScreen mainScreen].scale == 2.0f) {
        res = [name stringByAppendingString:@"@2x"];
    }else if ([UIScreen mainScreen].scale == 3.0f) {
        res = [name stringByAppendingString:@"@3x"];
    }
    
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp"];
    
    for (NSString *e in exts) {
        path = [[NSBundle mainBundle] pathForResource:res ofType:e];
        if (path) {
            break;
        }
    }
    
    if (path) {
        return [UIImage imageWithContentsOfFile:path];
    }
    
    // 还是没查找到，就直接用系统
    return [UIImage imageNamed:name];
}

/**
 原图
 */
- (UIImage *)originalImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

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

/**
 灰度图片
 */
- (UIImage*)grayImage {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,self.size.width,self.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    return grayImage;
}

/**
 取图片某点像素的颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    if (!CGRectContainsPoint(CGRectMake(0, 0, width, height), point)) {
        return nil;
    }
    
    CGFloat pointX = trunc(point.x);  // 取整，
    CGFloat pointY = trunc(point.y);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY- height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), self.CGImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/**
 设置图片透明度
 */
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
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
 设置图片圆角
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f,0.f,self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    
    //根据矩形画带圆角的曲线
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    [self drawInRect:rect];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

/**
 所占的内存大小
 */
- (NSUInteger)memorySize {
    return CGImageGetHeight(self.CGImage) * CGImageGetBytesPerRow(self.CGImage);
}

/**
 从中心向外拉伸
 */
- (UIImage *)centerOutwardStretching {
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
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

/**
 截取image里的rect区域内的图片
 */
- (UIImage *)subimageInRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
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

/**
 水平翻转
 */
- (UIImage *)flipHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    CGContextRotateCTM(ctx, M_PI);
    CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 垂直翻转
 */
- (UIImage *)flipVertical {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

/**
 将图片旋转弧度radians
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians {
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, radians);
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 将图片旋转角度degrees
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    return [self imageRotatedByRadians:JCDegreesToRadians(degrees)];
}

/// 由角度转换弧度
CGFloat JCDegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;}

/// 由弧度转换角度
CGFloat JCRadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;}

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
    return [self imageWithText:text textColor:textColor font:font paragraphStyle:paragraphStyle];
}

- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;   // 文字居中
    return [self imageWithText:text textColor:textColor font:font paragraphStyle:paragraphStyle];
}

- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle {
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

#pragma mark - GIF

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
    NSString *ext = name.pathExtension;
    if (!ext.length) {
        ext = @"gif";
    }else {
        ext = nil;
    }
    NSString *gifName = name;
    if ([UIScreen mainScreen].scale > 1.0f) {
        gifName = [name stringByAppendingString:@"@2x"];
    }
    NSString *retinaPath = [[NSBundle mainBundle] pathForResource:gifName ofType:ext];
    if (!retinaPath) {
        retinaPath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    }
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

@implementation UIImage (JCQRCode)

/**
 生成二维码图片
 @param string 信息
 @param size 大小
 */
+ (UIImage *)QRCodeImageWithString:(NSString *)string size:(CGFloat)size {
    NSData *stringData = [[string description] dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *QRFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [QRFilter setValue:stringData forKey:@"inputMessage"];
    [QRFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGRect extent = CGRectIntegral(QRFilter.outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(cs);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:QRFilter.outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *reusult = [UIImage imageWithCGImage:scaledImage];
    CGContextRelease(bitmapRef);
    CGImageRelease(scaledImage);
    CGImageRelease(bitmapImage);
    return reusult;
}

/**
 二维码图片内容信息
 */
- (NSString *)QRCodeImageContext {
    CIContext *content = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:content options:nil];
    CIImage *cimage = [CIImage imageWithCGImage:self.CGImage];
    NSArray *features = [detector featuresInImage:cimage];
    CIQRCodeFeature *f = [features firstObject];
    return f.messageString;
}

@end
