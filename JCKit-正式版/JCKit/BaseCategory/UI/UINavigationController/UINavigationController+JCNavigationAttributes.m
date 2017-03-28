//
//  UINavigationController+JCNavigationAttributes.m
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UINavigationController+JCNavigationAttributes.h"

@implementation UINavigationController (JCNavigationAttributes)

/**
 *  设置navigationBar背景颜色
 */
- (UINavigationController *(^)(UIColor *color))navigationBarTintColor {
    return ^(UIColor *color) {
        [self.navigationBar setBarTintColor:color];
        return self;
    };
}

/**
 *  设置导航栏的字体
 */
- (UINavigationController *(^)(UIFont *font))navigationBarTitleFont {
    return ^(UIFont *font) {
        NSDictionary *attributesDic =  self.navigationBar.titleTextAttributes;
        NSMutableDictionary *attributesDicM = [NSMutableDictionary new];
        if (attributesDic.count > 0) {
            attributesDicM = [NSMutableDictionary dictionaryWithDictionary:attributesDic];
        }
        [attributesDicM setValue:font forKey:NSFontAttributeName];
        [self.navigationBar setTitleTextAttributes:attributesDicM];
        return self;
    };
}

/**
 *  设置导航栏的字体颜色
 */
- (UINavigationController *(^)(UIColor *color))navigationBarTitleColor {
    return ^(UIColor *color) {
        NSDictionary *attributesDic =  self.navigationBar.titleTextAttributes;
        NSMutableDictionary *attributesDicM = [NSMutableDictionary new];
        if (attributesDic.count > 0) {
            attributesDicM = [NSMutableDictionary dictionaryWithDictionary:attributesDic];
        }
        [attributesDicM setValue:color forKey:NSForegroundColorAttributeName];
        [self.navigationBar setTitleTextAttributes:attributesDicM];
        return self;
    };
}

/**
 *  设置导航栏的返回键颜色
 */
- (UINavigationController *(^)(UIColor *color))navigationTintColor {
    return ^(UIColor *color) {
        [self.navigationBar setTintColor:color];
        return self;
    };
}

/**
 *  设置navigationBar透明
 */
- (UINavigationController *(^)())navigationBarTransparentBackground {
    return ^() {
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        return self;
    };
}

/**
 *  隐藏navigationBar下的横线
 */
- (UINavigationController *(^)())navigationBarHiddenLine {
    return ^() {
        self.navigationBar.shadowImage = [UIImage new];
        return self;
    };
}

/**
 *  navigationBar的透明渐变
 */
- (UINavigationController *(^)(CGFloat alpha))navigationBarTransparentGradient {
    return ^(CGFloat alpha) {
        [self.navigationBar.subviews objectAtIndex:0].alpha = alpha;
        return self;
    };
}

/**
 *  navigationBar是否隐藏
 */
- (UINavigationController *(^)(BOOL hidden, BOOL animated))navigationBarHidden {
    return ^(BOOL hidden, BOOL animated) {
        [self setNavigationBarHidden:hidden animated:animated];
        return self;
    };
}

/**
 动画跳转到下一个viewController
 */
- (void)pushViewController:(UIViewController *)viewController transition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    [self pushViewController:viewController animated:NO];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

/**
 动画跳转到上一个viewController
 */
- (UIViewController *)popViewControllerTransition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    UIViewController *controller = [self popViewControllerAnimated:NO];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
    return controller;
}

/**
 回到上层
 */
- (NSArray<UIViewController *> *)popToViewControllerWithLevel:(NSInteger)level
                                                     animated:(BOOL)animated {
    NSInteger count = self.viewControllers.count;
    if (count > level) {
        NSInteger index = count - level - 1;
        UIViewController *viewController = self.viewControllers[index];
        return [self popToViewController:viewController animated:animated];
    }
    return [self popToRootViewControllerAnimated:animated];
}

/**
 回到指定类名的上层
 */
- (NSArray<UIViewController *> *)popToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated {
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            return [self popToViewController:viewController animated:animated];
        }
    }
    return self.viewControllers;
}

@end
