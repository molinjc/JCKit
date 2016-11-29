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

@end
