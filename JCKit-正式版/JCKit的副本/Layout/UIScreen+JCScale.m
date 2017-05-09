//
//  UIView+JCScale.m
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIScreen+JCScale.h"
#import <objc/runtime.h>

static const void *kScale = &kScale;

@implementation UIScreen (JCScale)

void JCSetUITemplateSize(CGSize size) {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat width = screenSize.width;
        if (screenSize.width > screenSize.height) {
            width = screenSize.height;
        }
        scale = width / size.width;
        objc_setAssociatedObject([UIScreen mainScreen], kScale, @(scale), OBJC_ASSOCIATION_COPY_NONATOMIC);
    });
}

CGSize JCSize(CGFloat width, CGFloat height) {
    return CGSizeMake(width, height);
}


/**
 屏幕的大小
 */
CGSize JCScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

- (CGFloat)_scale_ {
    id scaleS = objc_getAssociatedObject(self, kScale);
    CGFloat scaleF = 1;
    if (scaleS) {
        scaleF = [scaleS floatValue];
    }
    return scaleF;
}

/**
 获取当前屏幕的bounds
 */
- (CGRect)currentBounds {
    return [self boundsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

/**
 根据屏幕的旋转方向设置bounds
 @param orientation 界面的当前旋转方向
 */
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation {
    CGRect bounds = [self bounds];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat buffer = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = buffer;
    }
    return bounds;
}

@end
