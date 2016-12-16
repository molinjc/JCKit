//
//  UIViewController+JCViewController.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/16.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JCViewController)

/**
 将UIViewController的类名作为NibName，使用initWithNibName方法，返回UIViewController对象
 */
+ (instancetype)instance;

/**
 判断当前ViewController是否在顶部显示
 */
- (BOOL)isViewInBackground;

@end
