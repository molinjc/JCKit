//
//  NSData+JCData.m
//  JCKit
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSData+JCData.h"

@implementation NSData (JCData)

@end

@implementation NSData (JCImage)

/**
 *  压缩图片在设定的大小内
 *  @param image 图片
 *  @param size  最大的大小
 *  @return data
 */
+ (NSData *)compressedImage:(UIImage *)image limitSize:(NSInteger)size {
    NSInteger imagePixel = CGImageGetWidth(image.CGImage) * CGImageGetHeight(image.CGImage); // 图片像素
    NSInteger imageSize = imagePixel * CGImageGetBitsPerPixel(image.CGImage) / (8 * 1024);   // 图片大小
    if (imageSize > size) {
        float compressedParam = size / imageSize;
        return UIImageJPEGRepresentation(image, compressedParam);
    }
    return UIImagePNGRepresentation(image);
}

/**
 图片的Data数据判断是哪个格式图片
 */
- (NSString *)imageDataContentType {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            if ([self length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            return nil;
    }
    return nil;
}

@end