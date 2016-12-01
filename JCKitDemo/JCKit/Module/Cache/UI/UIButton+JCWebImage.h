//
//  UIButton+JCWebImage.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/1.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JCWebImage)

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(void (^)(UIImage *image))completedBlock;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(void (^)(UIImage *image))completedBlock;



- (void)setImageGIFWithURL:(NSURL *)url forState:(UIControlState)state;

- (void)setImageGIFWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setImageGIFWithURL:(NSURL *)url forState:(UIControlState)state completed:(void (^)(UIImage *image))completedBlock;

- (void)setImageGIFWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(void (^)(UIImage *image))completedBlock;

@end
