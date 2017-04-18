//
//  UITabBar+JCTabBar.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/4/6.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UITabBar+JCTabBar.h"
#import <objc/runtime.h>

#define _RedTag(i) i+100
#define _RedSize     10
#define _RedRadius  _RedSize * 0.5

@implementation UITabBar (JCTabBar)
@dynamic tabBarItems;

/**
 红点角标
 @param index 第几个
 */
- (void)redBadgeIndex:(NSInteger)index {
    UIView *_red = [self viewWithTag:_RedTag(index)];
    
    if (!_red) {
        _red = [[UIView alloc] init];
        _red.tag = _RedTag(index);
        _red.backgroundColor = [UIColor redColor];
        _red.layer.cornerRadius = _RedRadius;
        [self addSubview:_red];
        
        CGFloat percentX = (index + 0.5) * self.tabBarItems;
        CGFloat x = ceilf(percentX * self.frame.size.width);
        CGFloat y = ceilf(0.1 * self.frame.size.height);
        _red.frame = CGRectMake(x, y, _RedSize, _RedSize);
    }
    _red.hidden = NO;
}

- (void)hidenRedBadgeIndex:(NSInteger)index {
    UIView *_red = [self viewWithTag:_RedTag(index)];
    if (_red) {
        [_red removeFromSuperview];
    }
}

- (NSInteger)tabBarItems {
    NSInteger items = [objc_getAssociatedObject(self, _cmd) integerValue];
    if (items == 0) {
        items = 4;
        objc_setAssociatedObject(self, _cmd, @(items), OBJC_ASSOCIATION_ASSIGN);
    }
    return items;
}

@end
