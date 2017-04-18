//
//  UITabBar+JCTabBar.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/4/6.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (JCTabBar)

/** TabBar的item个数, 默认4个, 要用到红点时需要注意这个属性 */
@property (nonatomic, assign) NSInteger tabBarItems;

/**
 红点角标
 @param index 第几个
 */
- (void)redBadgeIndex:(NSInteger)index;

- (void)hidenRedBadgeIndex:(NSInteger)index;

@end
