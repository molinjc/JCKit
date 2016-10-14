//
//  UIApplication+JCApplication.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIApplication+JCApplication.h"
#import "UIDevice+JCDevice.h"

@implementation UIApplication (JCApplication)

- (NSString *)appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

/**
 手动更改状态栏的颜色
 */
- (void)setStatusBarBackgtoundColor:(UIColor *)color {
    UIView *statusBar = [[self valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if (statusBar && [statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


@end
