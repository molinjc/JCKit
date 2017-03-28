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

@interface UIView (JCRect)

@property (nonatomic, assign) CGFloat x;             // frame.origin.x
@property (nonatomic, assign) CGFloat y;             // frame.origin.y
@property (nonatomic, assign) CGFloat width;         // frame.size.width
@property (nonatomic, assign) CGFloat height;        // frame.size.height
@property (nonatomic, assign) CGPoint origin;        // frame.origin
@property (nonatomic, assign) CGSize  size;          // frame.size
@property (nonatomic, assign) CGFloat centerX;       // center.x
@property (nonatomic, assign) CGFloat centerY;       // center.y
@property (nonatomic, assign) CGFloat right;         // frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat bottom;        // frame.origin.y + frame.size.height

@property (nonatomic, assign) CGFloat leftSpacing;   // 左间距
@property (nonatomic, assign) CGFloat rightSpacing;  // 右间距
@property (nonatomic, assign) CGFloat topSpacing;    // 上间距
@property (nonatomic, assign) CGFloat bottomSpacing; // 下间距

@end

/*
             +------------------------------+
             |              |               |
             |             top              |
             |              |               |
             |      +---------------+       |
             |      |-----width-+---|       |
             |      |           |   |       |
             |-left-|         height|-right-|
             |      |           |   |       |
             |      |           |   |       |
             |      +---------------+       |
             |              |               |
             |            bottom            |
             |              |               |
             +------------------------------+
 
 带有Equal的属性，值不变；不带的，会跟设置的尺寸与屏幕的比例相乘。所以最好在AppDelegate的 
 -application:didFinishLaunchingWithOptions:方法里设置JCSetUITemplateSize
 
 */


@interface UIView (JCLayout)

@property (nonatomic, weak, readonly) UIView *(^layoutRemoveAll)();

#pragma mark - 参照父视图属性

// left，相当于x，参照俯视图的NSLayoutAttributeLeft
@property (nonatomic, weak, readonly) UIView  *(^layoutLeft)(CGFloat layoutLeft);
@property (nonatomic, weak, readonly) UIView  *(^layoutLeftEqual)(CGFloat layoutLeft);

// right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight
@property (nonatomic, weak, readonly) UIView *(^layoutRight)(CGFloat layoutRight);
@property (nonatomic, weak, readonly) UIView *(^layoutRightEqual)(CGFloat layoutRight);

// top，相当于y，参照俯视图的NSLayoutAttributeTop
@property (nonatomic, weak, readonly) UIView *(^layoutTop)(CGFloat layoutTop);
@property (nonatomic, weak, readonly) UIView *(^layoutTopEqual)(CGFloat layoutTop);

// bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom
@property (nonatomic, weak, readonly) UIView *(^layoutBottom)(CGFloat layoutBottom);
@property (nonatomic, weak, readonly) UIView *(^layoutBottomEqual)(CGFloat layoutBottom);

// Width， 无参照物，设置自身的宽，NSLayoutAttributeWidth
@property (nonatomic, weak, readonly) UIView *(^layoutWidth)(CGFloat layoutWidth);
@property (nonatomic, weak, readonly) UIView *(^layoutWidthEqual)(CGFloat layoutWidth);

// height，无参照物，设置自身的高，NSLayoutAttributeHeight
@property (nonatomic, weak, readonly) UIView *(^layoutHeight)(CGFloat layoutHeight);
@property (nonatomic, weak, readonly) UIView *(^layoutHeightEqual)(CGFloat layoutHeight);

// CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX
@property (nonatomic, weak, readonly) UIView *(^layoutCenterX)(CGFloat layoutCenterX);
@property (nonatomic, weak, readonly) UIView *(^layoutCenterXEqual)(CGFloat layoutCenterX);

// CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY
@property (nonatomic, weak, readonly) UIView *(^layoutCenterY)(CGFloat layoutCenterY);
@property (nonatomic, weak, readonly) UIView *(^layoutCenterYEqual)(CGFloat layoutCenterY);

/** 四周的边距，实际调用layoutLeft().layoutTop().layoutRight().layoutBottom() */
@property (nonatomic, weak, readonly) UIView *(^layoutEdgeMargin)(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);
@property (nonatomic, weak, readonly) UIView *(^layoutEdgeMarginEqual)(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);

#pragma mark - 参照父视图的属性，是父视图属性的multiplier倍

// left，相当于x，参照俯视图的NSLayoutAttributeLeft的multiplier倍
@property (nonatomic, weak, readonly) UIView  *(^layoutLeftWithMultiplier)(CGFloat multiplier, CGFloat layoutLeft);
@property (nonatomic, weak, readonly) UIView  *(^layoutLeftWithMultiplierEqual)(CGFloat multiplier, CGFloat layoutLeft);

// right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutRightWithMultiplier)(CGFloat multiplier, CGFloat layoutRight);
@property (nonatomic, weak, readonly) UIView *(^layoutRightWithMultiplierEqual)(CGFloat multiplier, CGFloat layoutRight);

// top，相当于y，参照俯视图的NSLayoutAttributeTop的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutTopWithMultiplier)(CGFloat multiplier, CGFloat layoutTop);
@property (nonatomic, weak, readonly) UIView *(^layoutTopWithMultiplierEqual)(CGFloat multiplier, CGFloat layoutTop);

// bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutBottomWithMultiplier)(CGFloat multiplier, CGFloat layoutBottom);
@property (nonatomic, weak, readonly) UIView *(^layoutBottomWithMultiplierEqual)(CGFloat multiplier, CGFloat layoutBottom);

// Width， 无参照物，设置自身的宽，NSLayoutAttributeWidth的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutWidthWithMultiplier)(CGFloat multiplier, CGFloat layoutWidth);
@property (nonatomic, weak, readonly) UIView *(^layoutWidthWithMultiplierEqual)(CGFloat multiplier, CGFloat layoutWidth);

// height，无参照物，设置自身的高，NSLayoutAttributeHeight的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutHeightWithMultiplier)(CGFloat multiplier, CGFloat layoutHeight);
@property (nonatomic, weak, readonly) UIView *(^layoutHeightWithMultiplierEqual)(CGFloat multiplier, CGFloat layoutHeight);

// CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutCenterXWithMultiplier)(CGFloat multiplier, CGFloat layoutCenterX);
@property (nonatomic, weak, readonly) UIView *(^layoutCenterXWithMultiplierEqual)(CGFloat multiplier, CGFloat layoutCenterX);

// CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY的multiplier倍
@property (nonatomic, weak, readonly) UIView *(^layoutCenterYWithMultiplier)(CGFloat multiplier, CGFloat layoutCenterY);
@property (nonatomic, weak, readonly) UIView *(^layoutCenterYWithMultiplierEqual)(CGFloat multiplier, CGFloat layoutCenterY);

#pragma mark - 参照同层级视图相同属性

// 参照同层级view的left
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerLeft)(UIView *sameLayerView,CGFloat left);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerLeftEqual)(UIView *sameLayerView,CGFloat left);

// 参照同层级view的right
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerRight)(UIView *sameLayerView,CGFloat right);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerRightEqual)(UIView *sameLayerView,CGFloat right);

// 参照同层级view的top
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerTop)(UIView *sameLayerView,CGFloat top);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerTopEqual)(UIView *sameLayerView,CGFloat top);

// 参照同层级view的bottom
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerBottom)(UIView *sameLayerView,CGFloat bottom);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerBottomEqual)(UIView *sameLayerView,CGFloat bottom);

// 参照同层级view的width
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerWidth)(UIView *sameLayerView,CGFloat width);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerWidthEqual)(UIView *sameLayerView,CGFloat width);

// 参照同层级view的height
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerHeight)(UIView *sameLayerView,CGFloat height);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerHeightEqual)(UIView *sameLayerView,CGFloat height);

// 参照同层级view的centerX
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterX)(UIView *sameLayerView,CGFloat centerX);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterXEqual)(UIView *sameLayerView,CGFloat centerX);

// 参照同层级view的centerY
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterY)(UIView *sameLayerView,CGFloat centerY);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterYEqual)(UIView *sameLayerView,CGFloat centerY);

#pragma mark - 参照同层级视图相同属性，是同层级视图相同属性的multiplier倍

// 参照同层级view的left，left * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerLeftWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat left);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerLeftWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat left);

// 参照同层级view的right，right * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerRightWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat right);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerRightWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat right);

// 参照同层级view的top，top * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerTopWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat top);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerTopWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat top);

// 参照同层级view的bottom，bottom * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerBottomWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat bottom);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerBottomWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat bottom);

// 参照同层级view的bottom，width * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerWidthWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat width);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerWidthWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat width);

// 参照同层级view的bottom，height * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerHeightWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat height);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerHeightWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat height);

// 参照同层级view的centerX，centerX * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterXWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat centerX);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterXWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat centerX);

// 参照同层级view的centerY，centerY * multiplier
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterYWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat centerY);
@property (nonatomic, weak, readonly) UIView *(^layoutSameLayerCenterYWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat centerY);

#pragma mark - 参照同层级视图相反属性

// 参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right）
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerLeft)(UIView *sameLayerView,CGFloat constant);
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerLeftEqual)(UIView *sameLayerView,CGFloat constant);

// 参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left）
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerRight)(UIView *sameLayerView,CGFloat constant);
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerRightEqual)(UIView *sameLayerView,CGFloat constant);

// 参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom）
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerTop)(UIView *sameLayerView,CGFloat constant);
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerTopEqual)(UIView *sameLayerView,CGFloat constant);

// 参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top）
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerBottom)(UIView *sameLayerView,CGFloat constant);
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerBottomEqual)(UIView *sameLayerView,CGFloat constant);

#pragma mark - 参照同层级视图相反属性，是同层级视图相反属性的multiplier倍

// 参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right），self.right = 同层级view.left * multiplier + constant
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerLeftWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerLeftWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

// 参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left），self.left = 同层级view.right * multiplier + constant
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerRightWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerRightWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

// 参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom），self.bottom = 同层级view.top * multiplier + constant
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerTopWithMultiplier)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerTopWithMultiplierEqual)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

// 参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top），self.top = 同层级view.bottom * multiplier + constant
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerBottomWithMultiplier)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant);
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerBottomWithMultiplierEqual)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant);

#pragma mark - 

- (void)updateLayout;

@end
