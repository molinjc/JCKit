//
//  UINavigationController+JCNavigationAttributes.m
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UINavigationController+JCNavigationAttributes.h"
#import <objc/runtime.h>

@interface UINavigationController ()<UIGestureRecognizerDelegate>
@end

@implementation UINavigationController (JCNavigationAttributes)

/** 设置navigationBar背景颜色 */
- (UINavigationController *(^)(UIColor *color))navigationBarTintColor {
    return ^(UIColor *color) {
        [self.navigationBar setBarTintColor:color];
        return self;
    };
}

/** 设置导航栏的字体 */
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

/** 设置导航栏的字体颜色 */
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

/** 设置导航栏的返回键颜色 */
- (UINavigationController *(^)(UIColor *color))navigationTintColor {
    return ^(UIColor *color) {
        [self.navigationBar setTintColor:color];
        return self;
    };
}

/** 设置navigationBar透明 */
- (UINavigationController *(^)())navigationBarTransparentBackground {
    return ^() {
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        return self;
    };
}

/**  隐藏navigationBar下的横线 */
- (UINavigationController *(^)())navigationBarHiddenLine {
    return ^() {
        self.navigationBar.shadowImage = [UIImage new];
        return self;
    };
}

/** navigationBar的透明渐变 */
- (UINavigationController *(^)(CGFloat alpha))navigationBarTransparentGradient {
    return ^(CGFloat alpha) {
        [self.navigationBar.subviews objectAtIndex:0].alpha = alpha;
        return self;
    };
}

/** navigationBar是否隐藏 */
- (UINavigationController *(^)(BOOL hidden, BOOL animated))navigationBarHidden {
    return ^(BOOL hidden, BOOL animated) {
        [self setNavigationBarHidden:hidden animated:animated];
        return self;
    };
}

/** 动画跳转到下一个viewController */
- (void)pushViewController:(UIViewController *)viewController transition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    [self pushViewController:viewController animated:NO];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

/** 动画跳转到上一个viewController */
- (UIViewController *)popViewControllerTransition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    UIViewController *controller = [self popViewControllerAnimated:NO];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
    return controller;
}

/** 回到上层 */
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

/** 回到指定类名的上层 */
- (NSArray<UIViewController *> *)popToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated {
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            return [self popToViewController:viewController animated:animated];
        }
    }
    return self.viewControllers;
}

static void *const KNavigationController_Gesture_Array = @"KNavigationController_Gesture_Array";
static void *const KNavigationController_Gesture_Full = @"KNavigationController_Gesture_Full";

- (void)interactivePop:(void (^)(UIGestureRecognizer *))block {
    NSMutableArray *blocks = objc_getAssociatedObject(self, KNavigationController_Gesture_Array);
    if (!blocks) {
        [self.interactivePopGestureRecognizer addTarget:self action:@selector(_interactivePop:)];
        blocks = [NSMutableArray new];
        objc_setAssociatedObject(self, KNavigationController_Gesture_Array, blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [blocks addObject:block];
}

- (void)fullScreenInteractivePop:(BOOL)interactive {
    
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    UIPanGestureRecognizer *fullScreenGestureRecognizer = objc_getAssociatedObject(self, KNavigationController_Gesture_Full);
    
    // interactive=YES是, 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:!interactive];
    
    if (!interactive) {
        [targetView removeGestureRecognizer:fullScreenGestureRecognizer];
        objc_setAssociatedObject(self, KNavigationController_Gesture_Full, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    
    //  创建pan手势 作用范围是全屏
    if (!fullScreenGestureRecognizer) {
        id target = self.interactivePopGestureRecognizer.delegate;
        SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
        fullScreenGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
        objc_setAssociatedObject(self, KNavigationController_Gesture_Full, fullScreenGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        fullScreenGestureRecognizer.delegate = self;
        [targetView addGestureRecognizer:fullScreenGestureRecognizer];
    }
}

/** 实际的右滑返回手势的监听方法, 从这里调用数组里的block */
- (void)_interactivePop:(UIGestureRecognizer *)sender {
    NSMutableArray *blocks = objc_getAssociatedObject(self, KNavigationController_Gesture_Array);
    [blocks enumerateObjectsUsingBlock:^(void (^block)(UIGestureRecognizer *), NSUInteger idx, BOOL * _Nonnull stop) {
        block(sender);
    }];
}

#pragma mark - UIGestureRecognizerDelegate

//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 根据具体控制器对象决定是否开启全屏右滑返回
    if (self.viewControllers.count > 1) {
        return YES;
    }
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
}

@end
