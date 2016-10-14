//
//  UIApplication+JCApplication.h
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (JCApplication)

@property (nonatomic, readonly) NSString *appBundleName;
@property (nonatomic, readonly) NSString *appBundleID;
@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *appBuildVersion;

/**
 手动更改状态栏的颜色
 */
- (void)setStatusBarBackgtoundColor:(UIColor *)color;

@end
