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

@end

@interface NSData (JCImage)

/**
 *  压缩图片在设定的大小内
 *  @param image 图片
 *  @param size  最大的大小
 *  @return data
 */
+ (NSData *)compressedImage:(UIImage *)image limitSize:(NSInteger)size;

/**
 图片的Data数据判断是哪个格式图片
 */
- (NSString *)imageDataContentType;

@end