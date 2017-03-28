//
//  UIView+JCRect.m
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIView+JCRect.h"

@implementation UIView (JCRect)

// @dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成
@dynamic x;
@dynamic y;
@dynamic width;
@dynamic height;
@dynamic origin;
@dynamic size;
@dynamic centerX;
@dynamic centerY;
@dynamic right;
@dynamic bottom;

#pragma mark - Setters

- (void)setLeftSpacing:(CGFloat)leftSpacing {
    self.x = leftSpacing;
}

- (void)setRightSpacing:(CGFloat)rightSpacing {
    UIView *superView = self.superview;
    self.width = superView.width - rightSpacing - self.x;
}

- (void)setTopSpacing:(CGFloat)topSpacing {
    self.y = topSpacing;
}

- (void)setBottomSpacing:(CGFloat)bottomSpacing {
    UIView *superView = self.superview;
    self.height = superView.height - bottomSpacing - self.y;
}

- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setSize:(CGSize)size {
    self.width = size.width;
    self.height = size.height;
}

- (void)setOrigin:(CGPoint)origin {
    self.x = origin.x;
    self.y = origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

#pragma mark - Getters

- (CGFloat)leftSpacing {
    return self.x;
}

- (CGFloat)rightSpacing {
    UIView *superView = self.superview;
    return superView.width - self.width - self.x;
}

- (CGFloat)topSpacing {
    return self.y;
}

- (CGFloat)bottomSpacing {
    UIView *superView = self.superview;
    return superView.height - self.height - self.y;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGSize)size {
    return CGSizeMake(self.width, self.height);
}

- (CGPoint)origin {
    return CGPointMake(self.x, self.y);;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

@end
