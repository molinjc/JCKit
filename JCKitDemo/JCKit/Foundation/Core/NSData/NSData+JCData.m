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

@end