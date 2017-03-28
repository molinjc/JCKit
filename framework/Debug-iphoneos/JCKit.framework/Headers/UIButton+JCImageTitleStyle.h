//
//  UIButton+JCImageTitleStyle.h
//  JCTextOrImageButton
//
//  Created by 林建川 on 16/8/21.
//  Copyright © 2016年 molin. All rights reserved.
//

///=======================================================================
//  系统默认的图文结合的按钮布局是：图片在左边而文字在右边，而且整体水平和垂直居中
///=======================================================================

#import <UIKit/UIKit.h>

/*
 针对同时设置了Image和Title的场景时UIButton中的图片和文字的关系
 */
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

@interface UIButton (JCImageTitleStyle)

/*
 调整按钮的文本和image的布局，前提是title和image同时存在才会调整。
 padding是调整布局时整个按钮和图文的间隔。
 
 */
-(void)setButtonImageTitleStyle:(ButtonImageTitleStyle)style padding:(CGFloat)padding;

- (void)setButtonTitle:(UIEdgeInsets (^)(CGRect titleRect, CGRect imageRect))titleBlock image:(UIEdgeInsets (^)(CGRect titleRect, CGRect imageRect))imageBlock;

@end
