//
//  UIApplication+JCApplication.h
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP(obj) ((obj *)[UIApplication appDelegate])

@interface UIApplication (JCApplication)

@property (nonatomic, readonly) NSString *appBundleName;   // < Bundle Name >
@property (nonatomic, readonly) NSString *appBundleID;     // < Bundle ID >
@property (nonatomic, readonly) NSString *appVersion;      // < app版本 >
@property (nonatomic, readonly) NSString *appBuildVersion; // < Bundle版本 >
@property (nonatomic, readonly) BOOL isPirated;            // < 判断程序是否为从AppStore安装,否则是盗版 >
@property (nonatomic, readonly) BOOL isBeingDebugged;      // < 是否为调试模式 >

/**
 手动更改状态栏的颜色
 */
- (void)setStatusBarBackgroundColor:(UIColor *)color;

/**
 拨打电话
 */
+ (void)call:(NSString *)phone;

/**
 隐藏键盘
 */
+ (void)hideKeyboard;

/**
 返回AppDelegate对象
 */
+ (id)appDelegate;

@end
