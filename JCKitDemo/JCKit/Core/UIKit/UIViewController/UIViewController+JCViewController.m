//
//  UIViewController+JCViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/16.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIViewController+JCViewController.h"

@implementation UIViewController (JCViewController)

/** Storyboard方式创建ViewController */
+ (instancetype)storyboardWithName:(NSString *)name storyboardID:(NSString *)sid {
    if (sid) {
        return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:sid];
    }else if (name) {
        return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateInitialViewController];
    }
    return nil;
}

+ (instancetype)storyboardWithName:(NSString *)name {
    return [self storyboardWithName:name storyboardID:nil];
}

- (instancetype)viewControllerWithStoryboardID:(NSString *)sid {
    return [self.storyboard instantiateViewControllerWithIdentifier:sid];
}

/**
 将UIViewController的类名作为NibName，使用initWithNibName方法，返回UIViewController对象
 */
+ (instancetype)instance; {
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

/**
 判断当前ViewController是否在顶部显示
 */
- (BOOL)isViewInBackground {
    return [self isViewLoaded] && self.view.window == nil;
}

- (void)addSubviewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
}

@end
