//
//  UILabel+JCLabel.m
//
//  Created by molin.JC on 2017/3/31.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UILabel+JCLabel.h"
#import <objc/runtime.h>

@implementation UILabel (JCLabel)

+ (void)load {
    Method systemMethod_0 = class_getInstanceMethod(self, @selector(textRectForBounds:limitedToNumberOfLines:));
    Method customMethod_0 = class_getInstanceMethod(self, @selector(_textRectForBounds:limitedToNumberOfLines:));
    method_exchangeImplementations(systemMethod_0, customMethod_0);
    
    Method systemMethod_1 = class_getInstanceMethod(self, @selector(drawTextInRect:));
    Method customMethod_1 = class_getInstanceMethod(self, @selector(_drawTextInRect:));
    method_exchangeImplementations(systemMethod_1, customMethod_1);
}

- (void)_drawTextInRect:(CGRect)rect {
    CGRect frame = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [self _drawTextInRect:frame];
}

- (CGRect)_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect rect = [self _textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    CGPoint origin = rect.origin;
    
    switch (self.textVerticalAlignment) {
        case JCTextVerticalAlignmentCenter:
            origin.y = (bounds.size.height - self.textInset.top - self.textInset.bottom) / 2.0 - rect.size.height / 2.0 + self.textInset.top;
            break;
        case JCTextVerticalAlignmentTop:
            origin.y = self.textInset.top;
            break;
        case JCTextVerticalAlignmentBottom:
            origin.y = bounds.size.height - self.textInset.bottom - rect.size.height;
            break;
        default:
            break;
    }
    rect.origin = origin;
    return rect;
}

- (void)setLinearGradientWithColor:(NSArray <UIColor *> *)colors {
    NSAssert(self.superview, @"要先添加到父视图");
    
    CAGradientLayer *chromatoLayer = [CAGradientLayer layer];
    NSMutableArray *cgColors = [NSMutableArray new];
    
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    
    [chromatoLayer setColors:cgColors.mutableCopy];
    cgColors = nil;
    
    [chromatoLayer setStartPoint:CGPointMake(0, 0)];
    [chromatoLayer setEndPoint:CGPointMake(1, 0)];
    chromatoLayer.locations = @[@(0.0f) ,@(1.0f)];
    
    [self.superview.layer addSublayer:chromatoLayer];
    [chromatoLayer setFrame:self.superview.frame];
    chromatoLayer.mask = self.layer;
    chromatoLayer.frame = chromatoLayer.bounds;
}


- (void)setGradientChromatoAnimation:(NSArray *)colors {
    NSAssert(self.superview, @"要先添加到父视图");
    CAGradientLayer *chromatoLayer = [CAGradientLayer layer];
    NSArray *array = colors[0];
    NSMutableArray *color = [NSMutableArray new];
    for (UIColor *co in array) {
        [color addObject:(__bridge id)co.CGColor];
    }
    [chromatoLayer setColors:color];
    [chromatoLayer setStartPoint:CGPointMake(0, 0)];
    [chromatoLayer setEndPoint:CGPointMake(1, 0)];
    chromatoLayer.locations = @[@(0.0f) ,@(1.0f)];
    [chromatoLayer setFrame:self.superview.frame];
    
    CAKeyframeAnimation *chromateAnimate = [self _chromatoAnimationWithColor:colors];
    
    [chromatoLayer addAnimation:chromateAnimate forKey:@"chromateAnimate"];
    
    [self.superview.layer addSublayer:chromatoLayer];
    chromatoLayer.mask = self.layer;
    chromatoLayer.frame = chromatoLayer.bounds;
}

/** 实现动画 */
- (CAKeyframeAnimation *)_chromatoAnimationWithColor:(NSArray *)colors {
    CAKeyframeAnimation *chromateAnimate = [CAKeyframeAnimation animationWithKeyPath:@"colors"];
    NSMutableArray *values = [NSMutableArray new];
    NSMutableArray *keyTimes = [NSMutableArray new];
    
    float time = 0;
    float t = 1.0 / (colors.count - 1);
    
    for (int i = 0; i < colors.count; i++) {
        NSArray *array = colors[i];
        NSMutableArray *values2 = [NSMutableArray new];
        for (UIColor *color in array) {
            [values2 addObject:(__bridge id)color.CGColor];
        }
        [values addObject:values2];
        if (i == 0) {
            [keyTimes addObject:@(i)];
        }else if (i == colors.count - 1) {
            [keyTimes addObject:@(1)];
        }else {
            time += t;
            [keyTimes addObject:@(time)];
        }
    }
    
    chromateAnimate.values = values;
    chromateAnimate.keyTimes = keyTimes;
    chromateAnimate.duration = keyTimes.count / 2;
    chromateAnimate.removedOnCompletion = NO;
    chromateAnimate.repeatCount = MAXFLOAT;
    
    return chromateAnimate;
}

#pragma mark - Set/Get

- (void)setTextVerticalAlignment:(JCTextVerticalAlignment)textVerticalAlignment {
    objc_setAssociatedObject(self, _cmd, @(textVerticalAlignment), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsDisplay];
}

- (JCTextVerticalAlignment)textVerticalAlignment {
    return [objc_getAssociatedObject(self, @selector(setTextVerticalAlignment:)) integerValue];
}

- (void)setTextInset:(UIEdgeInsets)textInset {
    objc_setAssociatedObject(self, _cmd, [NSValue valueWithUIEdgeInsets:textInset], OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsDisplay];
}

- (UIEdgeInsets)textInset {
    return [objc_getAssociatedObject(self, @selector(setTextInset:)) UIEdgeInsetsValue];
}

@end
