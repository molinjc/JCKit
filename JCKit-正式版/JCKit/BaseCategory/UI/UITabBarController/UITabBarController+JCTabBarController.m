//
//  UITabBarController+JCTabBarController.m
//  JCViewLayout
//
//  Created by molin.JC on 2017/4/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UITabBarController+JCTabBarController.h"

@implementation UITabBarController (JCTabBarController)

/** 替换TabBar */
- (void)replacedTabBar:(UITabBar *)tabBar {
    [self setValue:tabBar forKey:@"tabBar"];
}

/** 设置TabBar所有的Item的文字的默认颜色和选中颜色 */
- (void)setTabBarItemAttributeNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor {
    [self setTabBarItemAttributeFont:nil normalColor:normalColor selectedColor:selectedColor];
}

/** 设置TabBar所有的Item的文字的字体, 默认颜色和选中颜色 */
- (void)setTabBarItemAttributeFont:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor  {
    UITabBarItem *item = [UITabBarItem appearance];
    NSMutableDictionary *normalAtrrs = [item titleTextAttributesForState:UIControlStateNormal].mutableCopy;
    NSMutableDictionary *selectedAtrrs = [item titleTextAttributesForState:UIControlStateSelected].mutableCopy;
    
    if (font) {
        normalAtrrs[NSFontAttributeName] = font;
        selectedAtrrs[NSFontAttributeName] = font;
    }
    
    if (normalColor) {
        normalAtrrs[NSForegroundColorAttributeName] = normalColor;
    }
    
    if (selectedColor) {
        selectedAtrrs[NSForegroundColorAttributeName] = selectedColor;
    }
    
    [item setTitleTextAttributes:normalAtrrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAtrrs forState:UIControlStateSelected];
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    childController.tabBarItem =  [[UITabBarItem alloc]initWithTitle:title image:image selectedImage:selectedImage];
    [self addChildViewController:childController];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

- (void)handleDelegate:(BOOL)handle {
    if (handle) {
        self.delegate = self;
    }else {
        self.delegate = nil;
    }
}

#pragma mark - UITabBarControllerDelegate

/** 每次单击item的时候，如果需要切换则返回yes，否则no */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

@end
