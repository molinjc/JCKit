//
//  UIControl+JCSignal.m
//  JCViewLayout
//
//  Created by molin.JC on 2017/4/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCSignal-Event.h"

@implementation UIControl (JCSignal)

- (void)addSignal:(JCSignal *)signal callback:(callbackBlock)block {
    [self addSignal:signal controlEvents:UIControlEventTouchUpInside callback:block];
}

- (void)addSignal:(JCSignal *)signal controlEvents:(UIControlEvents)controlEvents callback:(callbackBlock)block {
    [signal subscriptionNumber:self callback:block];
    [self addTarget:signal action:@selector(sendSubscriptionNumber:withValue:) forControlEvents:controlEvents];
}

@end


@implementation UIBarButtonItem (JCSignal)

- (void)addSignal:(JCSignal *)signal callback:(callbackBlock)block {
    [signal subscriptionNumber:self callback:block];
    self.target = signal;
    self.action = @selector(sendSubscriptionNumber:withValue:);
}

@end

@implementation UIGestureRecognizer (JCSignal)

- (void)addSignal:(JCSignal *)signal callback:(callbackBlock)block {
    [signal subscriptionNumber:self callback:block];
    [self addTarget:signal action:@selector(sendSubscriptionNumber:withValue:)];
}

@end
