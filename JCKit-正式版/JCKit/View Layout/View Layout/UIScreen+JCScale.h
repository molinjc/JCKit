//
//  UIScreen+JCScale.h
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

/*
    对于不同屏幕的适配，我的想法是这样的：美工一般以某个屏幕尺寸做设计，只给我们一套效果图，按这套图
    做，做出来只在这屏幕上显示与效果图差不多一样。但iPhone现在有多中屏幕尺寸，我想就按比例来适配不同
    的屏幕。以我们效果图的宽与实际运行的屏幕宽比较，计算出scale，left、right、width、height等等
    就剩以scale来布局
 */


#define __scale [UIScreen mainScreen]._scale_

#import <UIKit/UIKit.h>

@interface UIScreen (JCScale)

#pragma mark - 函数

/**
 指定UI设计原型图所用的设备尺寸。请在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法的开始处调用这个方法，比如当UI设计人员用iPhone6作为界面的原型尺寸则将size设置为375,667。
 @param size UI设计原型图所用的设备尺寸
 */
void JCSetUITemplateSize(CGSize size);

CGSize JCSize(CGFloat width, CGFloat height);

/**
 屏幕的大小
 */
CGSize JCScreenSize();

#pragma mark -

@property (nonatomic, assign, readonly) CGFloat _scale_;

/**
 获取当前屏幕的bounds
 */
- (CGRect)currentBounds;

/**
 根据屏幕的旋转方向设置bounds
 @param orientation 界面的当前旋转方向
 */
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;

@end
