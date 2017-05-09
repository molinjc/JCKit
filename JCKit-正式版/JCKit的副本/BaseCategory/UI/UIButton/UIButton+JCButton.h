//
//  UIButton+JCButtonSimplify.h
//  JCObserveTarget
//
//  Created by 林建川 on 16/8/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 针对同时设置了Image和Title的场景时UIButton中的图片和文字的关系 */
typedef NS_ENUM(NSInteger, ButtonImageTitleStyle ) {
    ButtonImageTitleStyleDefault      = 0,     //图片在左，文字在右，整体居中。
    ButtonImageTitleStyleLeft         = 0,     //图片在左，文字在右，整体居中。
    ButtonImageTitleStyleRight        = 2,     //图片在右，文字在左，整体居中。
    ButtonImageTitleStyleTop          = 3,     //图片在上，文字在下，整体居中。
    ButtonImageTitleStyleBottom       = 4,     //图片在下，文字在上，整体居中。
    ButtonImageTitleStyleCenterTop    = 5,     //图片居中，文字在上距离按钮顶部。
    ButtonImageTitleStyleCenterBottom = 6,     //图片居中，文字在下距离按钮底部。
    ButtonImageTitleStyleCenterUp     = 7,     //图片居中，文字在图片上面。
    ButtonImageTitleStyleCenterDown   = 8,     //图片居中，文字在图片下面。
    ButtonImageTitleStyleRightLeft    = 9,     //图片在右，文字在左，距离按钮两边边距
    ButtonImageTitleStyleLeftRight    = 10,    //图片在左，文字在右，距离按钮两边边距
};


@interface UIButton (JCButton)

/** 设置标题，状态默认UIControlStateNormal */
@property (nonatomic, weak, readonly) UIButton *(^titleSet)(NSString *);
/** 设置标题和状态 */
@property (nonatomic, weak, readonly) UIButton *(^titleOrStateSet)(NSString *,UIControlState);
/** 设置标题颜色 */
@property (nonatomic, weak, readonly) UIButton *(^titleColorSet)(UIColor *);
/** 设置标题颜色和状态 */
@property (nonatomic, weak, readonly) UIButton *(^titleColorOrStateSet)(UIColor *,UIControlState);
/** 设置字体大小 */
@property (nonatomic, weak, readonly) UIButton *(^fontSize)(CGFloat);
/** 设置标题富文本的样式 */
@property (nonatomic, weak, readonly) UIButton *(^attributedTitleSet)(NSAttributedString *);
/** 设置标题富文本的样式和状态 */
@property (nonatomic, weak, readonly) UIButton *(^attributedTitleOrStateSet)(NSAttributedString *,UIControlState);
/** 设置图片 */
@property (nonatomic, weak, readonly) UIButton *(^imageSet)(UIImage *);
/** 设置图片和状态 */
@property (nonatomic, weak, readonly) UIButton *(^imageOrStateSet)(UIImage *,UIControlState);
/** 设置背景图片 */
@property (nonatomic, weak, readonly) UIButton *(^backgroundImageSet)(UIImage *);
/** 设置背景图片和状态 */
@property (nonatomic, weak, readonly) UIButton *(^backgroundImageOrStateSet)(UIImage *,UIControlState);
/** 设置触摸区域 */
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;
/** 是否显示菊花指示器 */
@property (nonatomic, weak, readonly) UIButton *(^showIndicator)(BOOL);

/*
 调整按钮的文本和image的布局，前提是title和image同时存在才会调整。
 padding是调整布局时整个按钮和图文的间隔。
 */
-(void)setButtonImageTitleStyle:(ButtonImageTitleStyle)style padding:(CGFloat)padding;

- (void)setButtonTitle:(UIEdgeInsets (^)(CGRect titleRect, CGRect imageRect))titleBlock image:(UIEdgeInsets (^)(CGRect titleRect, CGRect imageRect))imageBlock;

@end
