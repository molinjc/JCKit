//
//  UIButton+JCButtonSimplify.m
//  JCObserveTarget
//
//  Created by 林建川 on 16/8/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIButton+JCButtonSimplify.h"

@implementation UIButton (JCButtonSimplify)

- (UIButton *(^)(NSString *))titleSet {
    return ^(NSString *title) {
        self.titleOrStateSet(title,UIControlStateNormal);
        return self;
    };
}

- (UIButton *(^)(NSString *, UIControlState))titleOrStateSet {
    return ^(NSString *title, UIControlState state) {
        [self setTitle:title forState:state];
        return self;
    };
}

- (UIButton *(^)(UIColor *))titleColorSet {
    return ^(UIColor *color) {
        self.titleColorOrStateSet(color,UIControlStateNormal);
        return self;
    };
}

- (UIButton *(^)(UIColor *, UIControlState))titleColorOrStateSet {
    return ^(UIColor *color, UIControlState state) {
        [self setTitleColor:color forState:state];
        return self;
    };
}

- (UIButton *(^)(CGFloat))fontSize {
    return ^(CGFloat size) {
        self.titleLabel.font = [UIFont systemFontOfSize:size];
        return self;
    };
}

- (UIButton *(^)(NSAttributedString *))attributedTitleSet {
    return ^(NSAttributedString *attibutedString) {
        self.attributedTitleOrStateSet(attibutedString,UIControlStateNormal);
        return self;
    };
}

- (UIButton *(^)(NSAttributedString *, UIControlState))attributedTitleOrStateSet {
    return ^(NSAttributedString *attibutedString, UIControlState state) {
        [self setAttributedTitle:attibutedString forState:state];
        return self;
    };
}

- (UIButton *(^)(UIImage *))imageSet {
    return ^(UIImage *image) {
        self.imageOrStateSet(image, UIControlStateNormal);
        return self;
    };
}

- (UIButton *(^)(UIImage *, UIControlState))imageOrStateSet {
    return ^(UIImage *image, UIControlState state) {
        [self setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
        return self;
    };
}

- (UIButton *(^)(UIImage *))backgroundImageSet {
    return ^(UIImage *image) {
        self.backgroundImageOrStateSet(image,UIControlStateNormal);
        return self;
    };
}

- (UIButton *(^)(UIImage *, UIControlState))backgroundImageOrStateSet {
    return ^(UIImage *image, UIControlState state) {
        [self setBackgroundImage:image forState:state];
        return self;
    };
}

@end
