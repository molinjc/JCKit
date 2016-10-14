//
//  JCPopupBaseView.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCPopupBaseView : UIView

@property (nonatomic, strong) UILabel *messageLabel;

/**
 初始化方法，将外部的View添加进来
 @param view 外部的View
 */
- (instancetype)initWithPopupView:(UIView *)view;

/**
 *  显示该页面
 */
- (void)show;

/**
 *  页面消失
 */
- (void)disappear;

/**
 延时消失
 */
- (void)delayedDisappear:(NSTimeInterval)delay;

/**
 底部显示文本信息，2s消失掉
 @param message 文本信息
 */
+ (void)showPopupView:(NSString *)message;
+ (void)showPopupView:(NSString *)message buttom:(CGFloat)buttom;

/**
 有确定的弹窗
 @param title   标题
 @param message 详情
 */
+ (void)popupWithTitle:(NSString *)title message:(NSString *)message;
+ (void)popupWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)())block;

+ (void)popupWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle;
+ (void)popupWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle handler:(void (^)())block;

/**
 弹窗
 *  @param title        标题
 *  @param message      详情
 *  @param actionTitle1 第一个(左边)按钮的标题
 *  @param actionTitle2 第二个(右边)按钮的标题
 */
+ (void)popupWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2;
+ (void)popupWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 handler:(void (^)(NSInteger selectIndex))block;

/**
 选择照片
 */
+ (void)photoSelectPopupView:(void (^)(UIImage *image))block;

@end
