//
//  UIView+JCLayout.h
//  JCAutoLayoutTest
//
//  Created by 林建川 on 16/7/19.
//  Copyright © 2016年 molin. All rights reserved.
//

/**
 *  布局类目
 */
#import <UIKit/UIKit.h>


@interface UIView (JCLayout)

@property (nonatomic, weak, readonly) UIView *(^layoutScale)();

@property (nonatomic, weak, readonly) UIView *(^layoutRemoveAll)();

#pragma mark - 参照父视图属性

// left，相当于x，参照俯视图的NSLayoutAttributeLeft
@property (nonatomic, weak, readonly) UIView  *(^layoutLeft)(CGFloat layoutLeft);

// right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight
@property (nonatomic, weak, readonly) UIView *(^layoutRight)(CGFloat layoutRight);

// top，相当于y，参照俯视图的NSLayoutAttributeTop
@property (nonatomic, weak, readonly) UIView *(^layoutTop)(CGFloat layoutTop);

// bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom
@property (nonatomic, weak, readonly) UIView *(^layoutBottom)(CGFloat layoutBottom);

// Width， 无参照物，设置自身的宽，NSLayoutAttributeWidth
@property (nonatomic, weak, readonly) UIView *(^layoutWidth)(CGFloat layoutWidth);

// height，无参照物，设置自身的高，NSLayoutAttributeHeight
@property (nonatomic, weak, readonly) UIView *(^layoutHeight)(CGFloat layoutHeight);

// CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX
@property (nonatomic, weak, readonly) UIView *(^layoutCenterX)(CGFloat layoutCenterX);

// CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY
@property (nonatomic, weak, readonly) UIView *(^layoutCenterY)(CGFloat layoutCenterY);

#pragma mark - 参照父视图的属性，是父视图属性的multiplier倍

// left，相当于x，参照俯视图的NSLayoutAttributeLeft的multiplier倍
@property (nonatomic, weak, readonly) UIView  *(^layoutLeftWithMultiplier)(CGFloat multiplier, CGFloat layoutLeft);

// right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutRightWithMultiplier)(CGFloat multiplier, CGFloat layoutRight);

// top，相当于y，参照俯视图的NSLayoutAttributeTop的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutTopWithMultiplier)(CGFloat multiplier, CGFloat layoutTop);

// bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutBottomWithMultiplier)(CGFloat multiplier, CGFloat layoutBottom);

// Width， 无参照物，设置自身的宽，NSLayoutAttributeWidth的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutWidthWithMultiplier)(CGFloat multiplier, CGFloat layoutWidth);

// height，无参照物，设置自身的高，NSLayoutAttributeHeight的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutHeightWithMultiplier)(CGFloat multiplier, CGFloat layoutHeight);

// CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutCenterXWithMultiplier)(CGFloat multiplier, CGFloat layoutCenterX);

// CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutCenterYWithMultiplier)(CGFloat multiplier, CGFloat layoutCenterY);

#pragma mark - 参照同层级视图相同属性

// 参照同层级view的left
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerLeft)(UIView *sameLayerView,CGFloat left);

// 参照同层级view的right
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerRight)(UIView *sameLayerView,CGFloat right);

// 参照同层级view的top
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerTop)(UIView *sameLayerView,CGFloat top);

// 参照同层级view的bottom
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerBottom)(UIView *sameLayerView,CGFloat bottom);

// 参照同层级view的width
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerWidth)(UIView *sameLayerView,CGFloat width);

// 参照同层级view的height
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerHeight)(UIView *sameLayerView,CGFloat height);

// 参照同层级view的centerX
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterX)(UIView *sameLayerView,CGFloat centerX);

// 参照同层级view的centerY
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterY)(UIView *sameLayerView,CGFloat centerY);

#pragma mark - 参照同层级视图相同属性，是同层级视图相同属性的multiplier倍

// 参照同层级view的left，left * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerLeftWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat left);

// 参照同层级view的right，right * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerRightWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat right);

// 参照同层级view的top，top * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerTopWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat top);

// 参照同层级view的bottom，bottom * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerBottomWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat bottom);

// 参照同层级view的bottom，width * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerWidthWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat width);

// 参照同层级view的bottom，height * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerHeightWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat height);

// 参照同层级view的centerX，centerX * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterXWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat centerX);

// 参照同层级view的centerY，centerY * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterYWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat centerY);

#pragma mark - 参照同层级视图相反属性

// 参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right）
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerLeft)(UIView *sameLayerView,CGFloat constant);

// 参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left）
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerRight)(UIView *sameLayerView,CGFloat constant);

// 参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom）
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerTop)(UIView *sameLayerView,CGFloat constant);

// 参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top）
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerBottom)(UIView *sameLayerView,CGFloat constant);

#pragma mark - 参照同层级视图相反属性，是同层级视图相反属性的multiplier倍

// 参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right），self.right = 同层级view.left * multiplier + constant
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerLeftWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

// 参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left），self.left = 同层级view.right * multiplier + constant
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerRightWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

// 参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom），self.bottom = 同层级view.top * multiplier + constant
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerTopWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

// 参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top），self.top = 同层级view.bottom * multiplier + constant
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerBottomWithMultiplier)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant);

#pragma mark - 

- (void)updateLayout;

@end
