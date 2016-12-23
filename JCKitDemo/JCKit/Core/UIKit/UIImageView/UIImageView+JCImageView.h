//
//  UIImageView+JCImageView.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JCImageView)

/**
 倒影
 */
- (void)imageReflect;

/**
 画水印, 先设置image，否则watermark就赋值给image
 @param watermark 水印图
 @param rect 水印图的位置
 */
- (void)watermark:(UIImage *)watermark inRect:(CGRect)rect;

@end
