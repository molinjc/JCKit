//
//  UIButton+JCButtonSimplify.h
//  JCObserveTarget
//
//  Created by 林建川 on 16/8/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JCButtonSimplify)

// 设置标题，状态默认UIControlStateNormal
@property (nonatomic, weak, readonly) UIButton *(^titleSet)(NSString *);

// 设置标题和状态
@property (nonatomic, weak, readonly) UIButton *(^titleOrStateSet)(NSString *,UIControlState);

// 设置标题颜色
@property (nonatomic, weak, readonly) UIButton *(^titleColorSet)(UIColor *);

// 设置标题颜色和状态
@property (nonatomic, weak, readonly) UIButton *(^titleColorOrStateSet)(UIColor *,UIControlState);

// 设置字体大小
@property (nonatomic, weak, readonly) UIButton *(^fontSize)(CGFloat);

// 设置标题富文本的样式
@property (nonatomic, weak, readonly) UIButton *(^attributedTitleSet)(NSAttributedString *);

// 设置标题富文本的样式和状态
@property (nonatomic, weak, readonly) UIButton *(^attributedTitleOrStateSet)(NSAttributedString *,UIControlState);

// 设置图片
@property (nonatomic, weak, readonly) UIButton *(^imageSet)(UIImage *);

// 设置图片和状态
@property (nonatomic, weak, readonly) UIButton *(^imageOrStateSet)(UIImage *,UIControlState);

// 设置背景图片
@property (nonatomic, weak, readonly) UIButton *(^backgroundImageSet)(UIImage *);

// 设置背景图片和状态
@property (nonatomic, weak, readonly) UIButton *(^backgroundImageOrStateSet)(UIImage *,UIControlState);

// 设置触摸区域
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;

// 是否显示菊花指示器
@property (nonatomic, weak, readonly) UIButton *(^showIndicator)(BOOL);

@end
