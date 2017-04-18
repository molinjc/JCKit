//
//  JCProgressHUD.h
//
//  Created by molin.JC on 2017/3/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 提示、警告的基类，具体样式还要进一步设置 */
@interface JCProgressHUD : UIView

/**
 显示底部提示view
 @param message 提示语
 */
+ (void)showBottomRemind:(NSString *)message;

/**
 显示自定义的提示view，位置自己设置
 @param remindView 自定义的提示view
 */
+ (void)showCustomRemindView:(UIView *)remindView;

#pragma mark - ActivityIndicator

/** UIActivityIndicatorView(菊花控件), 开始转动 */
+ (void)startActivityIndicator;

/** 停止转动UIActivityIndicatorView(菊花控件) */
+ (void)stopActivityIndicator;

#pragma mark - 

/**
 显示自定义的view，添加到满屏的背景view里
 @param remindView 自定义view
 */
+ (void)showFullCustomRemindView:(UIView *)remindView;

#pragma mark - AlertController

/**
 选择系统照片或拍照
 @param block 选择完后的回调
 */
+ (void)showImagePicker:(void (^)(UIImage *image))block;

/**
 UIAlertController警告框，只有一个按钮，默认样式UIAlertControllerStyleAlert
 @param actionTitle 按钮的标题
 @param title 标题
 @param message 提示消息
 @param handler 点击按钮的回调
 */
+ (void)alertControllerWithActionTitle:(NSString *)actionTitle
                                 title:(NSString *)title
                               message:(NSString *)message
                               handler:(void (^)())handler;

/**
 UIAlertController的取消与确定的警告框，默认样式UIAlertControllerStyleAlert
 @remark 是取消与确定的弹框，取消无回调，确定才有回调
 @param title 标题
 @param message 提示消息
 @param handler 点击确定的回调
 */
+ (void)alertControllerCancelWithTitle:(NSString *)title
                               message:(NSString *)message
                               handler:(void (^)())handler;

/**
 UIAlertController警告框，默认样式UIAlertControllerStyleAlert
 @param actions UIAlertAction的集合
 @param title 标题
 @param message 提示消息
 */
+ (void)alertControllerWithActions:(NSArray <UIAlertAction *> *)actions
                             title:(NSString *)title
                           message:(NSString *)message;

/**
 UIAlertController警告框
 @param viewController 弹出动作的执行者
 @param actions UIAlertAction的集合
 @param title 标题
 @param message 提示消息
 @param style UIAlertController的样式
 */
+ (void)alertControllerWithController:(UIViewController *)viewController
                              actions:(NSArray <UIAlertAction *> *)actions
                                title:(NSString *)title
                              message:(NSString *)message
                                style:(UIAlertControllerStyle)style;

@end
