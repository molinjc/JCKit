//
//  NSData+JCData.h
//  JCKit
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSData (JCData)

/**
 NSData转NSString
 */
- (NSString *)utf8String;

/**
 从资源里获取data数据
 */
+ (NSData *)dataForResource:(NSString *)name;
+ (NSData *)dataForResource:(NSString *)name ofType:(NSString *)ext;

@end

@interface NSData (JCImage)

/**
 压缩图片成Data数据
 */
+ (NSData *)compressedImage:(UIImage *)image;

/**
 根据压缩质量压缩图片成Data数据
 */
+ (NSData *)compressedImage:(UIImage *)image quality:(CGFloat)quality;

/**
 *  压缩图片在设定的大小内
 *  @param image 图片
 *  @param size  最大的大小
 *  @return data
 */
+ (NSData *)compressedImage:(UIImage *)image limitSize:(NSInteger)size;
+ (NSData *)compressedImageTo100K:(UIImage *)image;
+ (NSData *)compressedImageTo500K:(UIImage *)image;

/**
 图片的Data数据判断是哪个格式图片
 */
- (NSString *)imageDataContentType;

@end
