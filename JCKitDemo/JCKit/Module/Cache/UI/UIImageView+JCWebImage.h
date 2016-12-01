//
//  UIImageView+JCWebImage.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/1.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JCWebImage)

- (void)setImageWithURL:(NSURL *)url;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url completed:(void (^)(UIImage *image))completedBlock;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *image))completedBlock;


- (void)setImageGIFWithURL:(NSURL *)url;

- (void)setImageGIFWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageGIFWithURL:(NSURL *)url completed:(void (^)(UIImage *image))completedBlock;

- (void)setImageGIFWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *image))completedBlock;

@end
