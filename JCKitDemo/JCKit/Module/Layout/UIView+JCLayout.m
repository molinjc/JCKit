//
//  UIView+JCLayout.m
//  JCAutoLayoutTest
//
//  Created by 林建川 on 16/7/19.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIView+JCLayout.h"
#import <objc/runtime.h>

/**
 判断文件是否存在，再导入使用，避免文件不存在的情况；
 否则自定义一个1.0浮点数的宏
 */
#if __has_include("UIScreen+JCScale.h")
#import "UIScreen+JCScale.h"
#else
#define __scale 1.0
#endif

/**
 *  判断有没设置translatesAutoresizingMaskIntoConstraints，YES是没有设置，就把它设置为NO
 */
#define ENOUGHCONSTRAINTS if (self.translatesAutoresizingMaskIntoConstraints) {\
self.translatesAutoresizingMaskIntoConstraints = NO;\
}

/**
 *  判断是否有父视图，没有就结束，抛出异常
 */
#define IFSUBVIEWS if (!self.subviews) {\
NSParameterAssert(self);\
return;\
}

/**
 *  约束字典添加约束，参照物是父视图
 */
#define layoutConstraints_Super_AddObject_forKey(key) [self.layoutConstraints setObject:layoutConstraint forKey:[self keyWithLayoutAttribute:key]];
/**
 *  约束字典添加约束，参照物是同层视图
 */
#define layoutConstraints_SameLayer_AddObject_forKey(key) [self.layoutConstraints setObject:layoutConstraint forKey:[NSString stringWithFormat:@"sameLayer%@",[self keyWithLayoutAttribute:key]]];

#define layoutConstraints_SameLayer_ContraryAttribute_AddObject_forKey(key) [self.layoutConstraints setObject:layoutConstraint forKey:[NSString stringWithFormat:@"sameLayer%@_C",[self keyWithLayoutAttribute:key]]];


NSString *const left = @"Left";
NSString *const right = @"Right";
NSString *const top = @"Top";
NSString *const bottom = @"Bottom";
NSString *const centerX = @"CenterX";
NSString *const centerY = @"CenterY";
NSString *const width = @"Width";
NSString *const height = @"Height";

NSString *const sameLayerLeft = @"sameLayerLeft";
NSString *const sameLayerRight = @"sameLayerRight";
NSString *const sameLayerTop = @"sameLayerTop";
NSString *const sameLayerBottom = @"sameLayerBottom";
NSString *const sameLayerCenterX = @"sameLayerCenterX";
NSString *const sameLayerCenterY = @"sameLayerCenterY";
NSString *const sameLayerWidth = @"sameLayerWidth";
NSString *const sameLayerHeight = @"sameLayerHeight";

NSString *const sameLayerLeft_C = @"sameLayerLeft_C";
NSString *const sameLayerRight_C = @"sameLayerRight_C";
NSString *const sameLayerTop_C = @"sameLayerTop_C";
NSString *const sameLayerBottom_C = @"sameLayerBottom_C";


static const void *kLayoutConstraints = &kLayoutConstraints;

@interface UIView ()

@property (nonatomic, strong) NSMutableDictionary *layoutConstraints;

@end

@implementation UIView (JCLayout)

- (UIView *(^)())layoutScale {
    return ^() {
        [self.layoutConstraints enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSLayoutConstraint *constraint, BOOL * _Nonnull stop) {
            constraint.constant *= __scale;
        }];
        [self.superview layoutIfNeeded]; 
        return self;
    };
}

- (UIView *(^)())layoutRemoveAll {
    return ^() {
        [self.layoutConstraints enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSLayoutConstraint *constraint, BOOL * _Nonnull stop) {
            [self.superview removeConstraint:constraint];
        }];
        [self.superview layoutIfNeeded];
        return self;
    };
}

#pragma mark - 参照父视图属性

/**
 *  left，相当于x，参照俯视图的NSLayoutAttributeLeft
 */
- (UIView *(^)(CGFloat layoutLeft))layoutLeft {
    return ^(CGFloat layoutLeft) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[left];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeLeft constant:layoutLeft multiplier:1.0f];
        }else {
            constraint.constant = layoutLeft;
        }
        return self;
    };
}

/**
 *  right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight
 */
- (UIView *(^)(CGFloat layoutRight))layoutRight {
    return ^(CGFloat layoutRight) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[right];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeRight constant:-layoutRight multiplier:1.0f];
        }else {
            constraint.constant = -layoutRight;
        }
        return self;
    };
}

/**
 *  top，相当于y，参照俯视图的NSLayoutAttributeTop
 */
- (UIView *(^)(CGFloat layoutTop))layoutTop {
    return ^(CGFloat layoutTop) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[top];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeTop constant:layoutTop multiplier:1.0f];
        }else {
            constraint.constant = layoutTop;
        }
        return self;
    };
}

/**
 *  bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom
 */
- (UIView *(^)(CGFloat layoutBottom))layoutBottom {
    return ^(CGFloat layoutBottom) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[bottom];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeBottom constant:-layoutBottom multiplier:1.0f];
        }else {
            constraint.constant = -layoutBottom;
        }
        return self;
    };
}

/**
 *  Width， 无参照物，设置自身的宽，NSLayoutAttributeWidth
 */
- (UIView *(^)(CGFloat layoutWidth))layoutWidth {
    return ^(CGFloat layoutWidth) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[width];
        if (!constraint) {
            [self addToSelfConstraintWithAttribute:NSLayoutAttributeWidth constant:layoutWidth multiplier:1.0f];
        }else {
            constraint.constant = layoutWidth;
        }
        return self;
    };
}

/**
 *  height，无参照物，设置自身的高，NSLayoutAttributeHeight
 */
- (UIView *(^)(CGFloat layoutHeight))layoutHeight {
    return ^(CGFloat layoutHeight) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[height];
        if (!constraint) {
            [self addToSelfConstraintWithAttribute:NSLayoutAttributeHeight constant:layoutHeight multiplier:1.0f];
        }else {
            constraint.constant = layoutHeight;
        }
        return self;
    };
}

/**
 *  CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX
 */
- (UIView *(^)(CGFloat layoutCenterX))layoutCenterX {
    return ^(CGFloat layoutCenterX) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[centerX];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeCenterX constant:layoutCenterX multiplier:1.0f];
        }else {
            constraint.constant = layoutCenterX;
        }
        return self;
    };
}

/**
 *  CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY
 */
- (UIView *(^)(CGFloat layoutCenterY))layoutCenterY {
    return ^(CGFloat layoutCenterY) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[centerY];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeCenterY constant:layoutCenterY multiplier:1.0f];
        }else {
            constraint.constant = layoutCenterY;
        }

        return self;
    };
}

#pragma mark - 参照父视图的属性，是父视图属性的multiplier倍

/**
 *  left，相当于x，参照俯视图的NSLayoutAttributeLeft的multiplier倍
 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutLeft))layoutLeftWithMultiplier {
    return ^(CGFloat multiplier, CGFloat layoutLeft) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[left];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeLeft constant:layoutLeft multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeLeft constant:layoutLeft multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight的multiplier倍
 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutRight))layoutRightWithMultiplier {
    return ^(CGFloat multiplier, CGFloat layoutRight) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[right];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeRight constant:-layoutRight multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeRight constant:-layoutRight multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  top，相当于y，参照俯视图的NSLayoutAttributeTop的multiplier倍
 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutTop))layoutTopWithMultiplier {
    return ^(CGFloat multiplier, CGFloat layoutTop) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[top];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeTop constant:layoutTop multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeTop constant:layoutTop multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom的multiplier倍
 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutBottom))layoutBottomWithMultiplier {
    return ^(CGFloat multiplier, CGFloat layoutBottom) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[bottom];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeBottom constant:-layoutBottom multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeBottom constant:-layoutBottom multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  Width， 参照物，设置自身的宽，NSLayoutAttributeWidth的multiplier倍
 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutWidth))layoutWidthWithMultiplier {
    return ^(CGFloat multiplier, CGFloat layoutWidth) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[width];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeWidth constant:layoutWidth multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeWidth constant:layoutWidth multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  height，参照物，设置自身的高，NSLayoutAttributeHeight的multiplier倍
 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutHeight))layoutHeightWithMultiplier {
    return ^(CGFloat multiplier, CGFloat layoutHeight) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[height];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeHeight constant:layoutHeight multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeHeight constant:layoutHeight multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX的multiplier倍
 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutCenterX))layoutCenterXWithMultiplier {
    return ^(CGFloat multiplier, CGFloat layoutCenterX) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[centerX];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeCenterX constant:layoutCenterX multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeCenterX constant:layoutCenterX multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY的multiplier倍
 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutCenterY))layoutCenterYWithMultiplier {
    return ^(CGFloat multiplier, CGFloat layoutCenterY) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[centerY];
        if (!constraint) {
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeCenterY constant:layoutCenterY multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithAttribute:NSLayoutAttributeCenterY constant:layoutCenterY multiplier:multiplier];
        }
        return self;
    };
}

#pragma mark - 参照同层级视图相同属性

/**
 *  参照同层级view的left
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat left))layoutSameLayerLeft {
    return ^(UIView *sameLayerView, CGFloat left) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerLeft];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeLeft constant:left multiplier:1.0f];
        }else {
            constraint.constant = left;
        }
        return self;
    };
}

/**
 *  参照同层级view的right
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat right))layoutSameLayerRight {
    return ^(UIView *sameLayerView, CGFloat right) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerRight];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeRight constant:right multiplier:1.0f];
        }else {
            constraint.constant = right;
        }
        return self;
    };
}

/**
 *  参照同层级view的top
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat top))layoutSameLayerTop {
    return ^(UIView *sameLayerView, CGFloat top) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerTop];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeTop constant:top multiplier:1.0f];
        }else {
            constraint.constant = top;
        }
        return self;
    };
}

/**
 *  参照同层级view的bottom
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat bottom))layoutSameLayerBottom {
    return ^(UIView *sameLayerView, CGFloat bottom) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerBottom];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeBottom constant:bottom multiplier:1.0f];
        }else {
            constraint.constant = bottom;
        }
        return self;
    };
}

/**
 *  参照同层级view的width
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat width))layoutSameLayerWidth {
    return ^(UIView *sameLayerView, CGFloat width) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerWidth];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeWidth constant:width multiplier:1.0f];
        }else {
            constraint.constant = width;
        }
        return self;
    };
}

/**
 *  参照同层级view的height
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat height))layoutSameLayerHeight {
    return ^(UIView *sameLayerView, CGFloat height) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerHeight];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeHeight constant:height multiplier:1.0f];
        }else {
            constraint.constant = height;
        }
        return self;
    };
}

/**
 *  参照同层级view的centerX
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat centerX))layoutSameLayerCenterX {
    return ^(UIView *sameLayerView, CGFloat centerX) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerCenterX];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeCenterX constant:centerX multiplier:1.0f];
        }else {
            constraint.constant = centerX;
        }
        return self;
    };
}

/**
 *  参照同层级view的centerY
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat centerY))layoutSameLayerCenterY {
    return ^(UIView *sameLayerView, CGFloat centerY) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerCenterY];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeCenterY constant:centerY multiplier:1.0f];
        }else {
            constraint.constant = centerY;
        }
        return self;
    };
}

#pragma mark - 参照同层级视图相同属性，是同层级视图的multiplier倍

/**
 *  参照同层级view的left
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat left))layoutSameLayerLeftWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat left) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerLeft];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeLeft constant:left multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeLeft constant:left multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的right
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat right))layoutSameLayerRightWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat right) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerRight];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeRight constant:right multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeRight constant:right multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的top
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat top))layoutSameLayerTopWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat top) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerTop];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeTop constant:top multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeTop constant:top multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的bottom
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat bottom))layoutSameLayerBottomWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat bottom) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerBottom];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeBottom constant:bottom multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeBottom constant:bottom multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的width
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat width))layoutSameLayerWidthWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat width) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerWidth];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeWidth constant:width multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeWidth constant:width multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的width
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat height))layoutSameLayerHeightWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat height) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerHeight];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeHeight constant:height multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeHeight constant:height multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的centerX
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat centerX))layoutSameLayerCenterXWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat centerX) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerCenterX];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeCenterX constant:centerX multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeCenterX constant:centerX multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的centerY
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat centerY))layoutSameLayerCenterYWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat centerY) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerCenterY];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeCenterY constant:centerY multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute:NSLayoutAttributeCenterY constant:centerY multiplier:multiplier];
        }
        return self;
    };
}

#pragma mark - 参照同层级视图相反属性

/**
 *  参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right）
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat constant))layoutAtSameLayerLeft {
    return ^(UIView *sameLayerView, CGFloat constant) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerLeft_C];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeRight attribute2:NSLayoutAttributeLeft constant:-constant multiplier:1.0f];
        }else {
            constraint.constant = -constant;
        }
        return self;
    };
}

/**
 *  参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left）
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat constant))layoutAtSameLayerRight {
    return ^(UIView *sameLayerView, CGFloat constant) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerRight_C];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeLeft attribute2:NSLayoutAttributeRight constant:constant multiplier:1.0f];
        }else {
            constraint.constant = constant;
        }
        return self;
    };
}

/**
 *  参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom）
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat constant))layoutAtSameLayerTop {
    return ^(UIView *sameLayerView, CGFloat constant) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerTop_C];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeBottom attribute2:NSLayoutAttributeTop constant:-constant multiplier:1.0f];
        }else {
            constraint.constant = -constant;
        }
        return self;
    };
}

/**
 *  参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top）
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat constant))layoutAtSameLayerBottom {
    return ^(UIView *sameLayerView, CGFloat constant) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerBottom_C];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeTop attribute2:NSLayoutAttributeBottom constant:constant multiplier:1.0f];
        }else {
            constraint.constant = constant;
        }
        return self;
    };
}

#pragma mark - 参照同层级视图相反属性，是同层级视图相反属性的multiplier倍

/**
 *  参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right）
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant))layoutAtSameLayerLeftWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat constant) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerLeft_C];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeRight attribute2:NSLayoutAttributeLeft constant:constant multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeRight attribute2:NSLayoutAttributeLeft constant:constant multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left）
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant))layoutAtSameLayerRightWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat constant) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerRight_C];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeLeft attribute2:NSLayoutAttributeRight constant:constant multiplier:multiplier];;
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeRight attribute2:NSLayoutAttributeLeft constant:constant multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom）
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant))layoutAtSameLayerTopWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat constant) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerTop_C];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeBottom attribute2:NSLayoutAttributeTop constant:constant multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeBottom attribute2:NSLayoutAttributeTop constant:constant multiplier:multiplier];
        }
        return self;
    };
}

/**
 *  参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top）
 */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant))layoutAtSameLayerBottomWithMultiplier {
    return ^(UIView *sameLayerView, CGFloat multiplier, CGFloat constant) {
        ENOUGHCONSTRAINTS
        NSLayoutConstraint *constraint = self.layoutConstraints[sameLayerBottom_C];
        if (!constraint) {
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeTop attribute2:NSLayoutAttributeBottom constant:constant multiplier:multiplier];
        }else {
            [self.superview removeConstraint:constraint];
            [self addToSuperviewConstraintWithSameLayerView:sameLayerView attribute1:NSLayoutAttributeTop attribute2:NSLayoutAttributeBottom constant:constant multiplier:multiplier];
        }
        return self;
    };
}

#pragma mark - NSLayoutConstraint

/**
 *  参照物为同层级view,
 *
 *  @param view       同层级view
 *  @param attribute1 约束条件1
 *  @param attribute2 约束条件2
 *  @param constant   常数
 */
- (void)addToSuperviewConstraintWithSameLayerView:(UIView *)view attribute1:(NSLayoutAttribute)attribute1 attribute2:(NSLayoutAttribute)attribute2 constant:(CGFloat)constant multiplier:(CGFloat)multiplier {
    NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute1 relatedBy:NSLayoutRelationEqual toItem:view attribute:attribute2 multiplier:multiplier constant:constant];
    IFSUBVIEWS
    layoutConstraints_SameLayer_ContraryAttribute_AddObject_forKey(attribute1)
    [self.superview addConstraint:layoutConstraint];
//    [self.superview layoutIfNeeded];
}

/**
 *  参照物为同层级view，该约束被添加到父视图
 *
 *  @param view      同层级view
 *  @param attribute 约束条件
 *  @param constant  常数
 */
- (void)addToSuperviewConstraintWithSameLayerView:(UIView *)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant multiplier:(CGFloat)multiplier {
    NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view attribute:attribute multiplier:multiplier constant:constant];
    IFSUBVIEWS
    layoutConstraints_SameLayer_AddObject_forKey(attribute);
    [self.superview addConstraint:layoutConstraint];
//    [self.superview layoutIfNeeded];
}

/**
 *  参照物为父视图，该约束被添加到父视图
 *
 *  @param attribute 约束条件
 *  @param constant  常数
 */
- (void)addToSuperviewConstraintWithAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant multiplier:(CGFloat)multiplier {
    NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:attribute multiplier:multiplier constant:constant];
    IFSUBVIEWS
    layoutConstraints_Super_AddObject_forKey(attribute)
    [self.superview addConstraint:layoutConstraint];
//    [self.superview layoutIfNeeded];
}

/**
 *  参照物无，该约束被添加到自身
 *
 *  @param attribute 约束条件
 *  @param constant  常熟
 */
- (void)addToSelfConstraintWithAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant multiplier:(CGFloat)multiplier {
    NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:attribute multiplier:multiplier constant:constant];
    layoutConstraints_Super_AddObject_forKey(attribute)
    [self addConstraint:layoutConstraint];
//    [self layoutIfNeeded];
}

- (NSString *)keyWithLayoutAttribute:(NSLayoutAttribute)attribute {
    switch (attribute) {
        case NSLayoutAttributeLeft:
            return left;
        case NSLayoutAttributeRight:
            return right;
        case NSLayoutAttributeTop:
            return top;
        case NSLayoutAttributeBottom:
            return bottom;
        case NSLayoutAttributeWidth:
            return width;
        case NSLayoutAttributeHeight:
            return height;
        case NSLayoutAttributeCenterX:
            return centerX;
        case NSLayoutAttributeCenterY:
            return centerY;
        case NSLayoutAttributeLeading:
            break;
        case NSLayoutAttributeTrailing:
            break;
        case NSLayoutAttributeBaseline:
            break;
        case NSLayoutAttributeFirstBaseline:
            break;
        case NSLayoutAttributeLeftMargin:
            break;
        case NSLayoutAttributeRightMargin:
            break;
        case NSLayoutAttributeTopMargin:
            break;
        case NSLayoutAttributeBottomMargin:
            break;
        case NSLayoutAttributeLeadingMargin:
            break;
        case NSLayoutAttributeTrailingMargin:
            break;
        case NSLayoutAttributeCenterXWithinMargins:
            break;
        case NSLayoutAttributeCenterYWithinMargins:
            break;
        case NSLayoutAttributeNotAnAttribute:
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - 内部属性Set/Get

- (NSMutableDictionary *)layoutConstraints {
    NSMutableDictionary *_layoutConstraints = objc_getAssociatedObject(self, kLayoutConstraints);
    if (!_layoutConstraints) {
        _layoutConstraints = [NSMutableDictionary new];
        self.layoutConstraints = _layoutConstraints;
    }
    return _layoutConstraints;
}

- (void)setLayoutConstraints:(NSMutableDictionary *)layoutConstraints {
    objc_setAssociatedObject(self, kLayoutConstraints, layoutConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 

- (void)updateLayout {
    NSParameterAssert(self.superview);
    [self.superview layoutSubviews];
}

@end
