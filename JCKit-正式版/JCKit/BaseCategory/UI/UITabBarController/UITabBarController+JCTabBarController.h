//
//  UITabBarController+JCTabBarController.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/4/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (JCTabBarController) <UITabBarControllerDelegate>

/** 替换TabBar */
- (void)replacedTabBar:(UITabBar *)tabBar;

/** 设置TabBar所有的Item的文字的默认颜色和选中颜色 */
- (void)setTabBarItemAttributeNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;

/** 设置TabBar所有的Item的文字的字体, 默认颜色和选中颜色 */
- (void)setTabBarItemAttributeFont:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;

/** 添加子控件 */
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

/** 是否处理代理的回调, YES: 处理回调, NO: 将delegate置nil, 在viewWillDisappear:或viewDidDisappear:置NO */
- (void)handleDelegate:(BOOL)handle;

/** TabBarController.navigationController的push */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
