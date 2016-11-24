//
//  UIView+JCView.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JCView)

/**
 获取View所在的控制器，响应链上的第一个Controller
 */
- (UIViewController *)viewController;

/**
 清空所有子视图
 */
- (void)removeAllSubviews;

/**
 视图快照(截图)
 @return UIImage对象
 */
- (UIImage *)snapshotImage;

@end
