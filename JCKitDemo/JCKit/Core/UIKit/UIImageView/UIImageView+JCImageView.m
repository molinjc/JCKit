//
//  UIImageView+JCImageView.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIImageView+JCImageView.h"

@implementation UIImageView (JCImageView)

/**
 倒影
 */
- (void)imageReflect {
    CGRect frame = self.frame;
    frame.origin.y += (frame.size.height + 1);
    
    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    self.clipsToBounds = TRUE;
    reflectionImageView.contentMode = self.contentMode;
    [reflectionImageView setImage:self.image];
    reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    CALayer *reflectionLayer = [reflectionImageView layer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.5,0.5);
    gradientLayer.endPoint = CGPointMake(0.5,1.0);
    reflectionLayer.mask = gradientLayer;
    
    [self.superview addSubview:reflectionImageView];
}

/**
 画水印
 @param watermark 水印图
 @param rect 水印图的位置
 */
- (void)watermark:(UIImage *)watermark inRect:(CGRect)rect {
    if (!self.image) {
        self.image = watermark;
        return;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    //原图
    [self.image drawInRect:self.bounds];
    //水印图
    [watermark drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newImage;
}

@end