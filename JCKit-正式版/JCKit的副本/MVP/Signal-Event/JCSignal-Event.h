//
//  UIControl+JCSignal.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/4/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSignal.h"

@interface UIControl (JCSignal)

/** 添加一个信号(等于Target), 默认UIControlEventTouchUpInside */
- (void)addSignal:(JCSignal *)signal callback:(callbackBlock)block;

/** 添加一个信号(等于Target)事件 */
- (void)addSignal:(JCSignal *)signal controlEvents:(UIControlEvents)controlEvents callback:(callbackBlock)block;

@end

@interface UIBarButtonItem (JCSignal)

/** 添加一个信号(等于Target) */
- (void)addSignal:(JCSignal *)signal callback:(callbackBlock)block;

@end

@interface UIGestureRecognizer (JCSignal)

/** 添加一个信号(等于Target) */
- (void)addSignal:(JCSignal *)signal callback:(callbackBlock)block;

@end
