//
//  UINavigationController+JCNavigationAttributes.h
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (JCNavigationAttributes)

/**
 *  设置navigationBar背景颜色
 */
@property (nonatomic, weak, readonly) UINavigationController *(^navigationBarTintColor)(UIColor *color);

/**
 *  设置导航栏的字体
 */
@property (nonatomic, weak, readonly) UINavigationController *(^navigationBarTitleFont)(UIFont *font);

/**
 *  设置导航栏的字体颜色
 */
@property (nonatomic, weak, readonly) UINavigationController *(^navigationBarTitleColor)(UIColor *color);

/**
 *  设置导航栏的返回键颜色
 */
@property (nonatomic, weak, readonly) UINavigationController *(^navigationTintColor)(UIColor *color);

/**
 *  设置navigationBar透明
 */
@property (nonatomic, weak, readonly) UINavigationController *(^navigationBarTransparentBackground)();

/**
 *  隐藏navigationBar下的横线
 */
@property (nonatomic, weak, readonly) UINavigationController *(^navigationBarHiddenLine)();

/**
 *  navigationBar的透明渐变
 */
@property (nonatomic, weak, readonly) UINavigationController *(^navigationBarTransparentGradient)(CGFloat alpha);

/**
 *  navigationBar是否隐藏
 */
@property (nonatomic, weak, readonly) UINavigationController *(^navigationBarHidden)(BOOL hidden, BOOL animated);

/**
 动画跳转到下一个viewController
 */
- (void)pushViewController:(UIViewController *)viewController transition:(UIViewAnimationTransition)transition;

/** 跳转时隐藏底部的标签栏 */
- (void)hidesBottomBarWhenPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/** 动画跳转时隐藏底部的标签栏 */
- (void)hidesBottomBarWhenPushViewController:(UIViewController *)viewController transition:(UIViewAnimationTransition)transition;

/**
 动画跳转到上一个viewController
 */
- (UIViewController *)popViewControllerTransition:(UIViewAnimationTransition)transition;

/**
 回到上层
 @param level 第几层
 @param animated 动画
 @return 数组（UIViewController）
 */
- (NSArray<UIViewController *> *)popToViewControllerWithLevel:(NSInteger)level
                                                     animated:(BOOL)animated;

/**
 回到指定类名的上层
 @param className 类名
 @param animated 动画
 @return 数组（UIViewController）
 */
- (NSArray<UIViewController *> *)popToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated;

@end
