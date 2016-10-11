//
//  UIControl+JCControl.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIControl+JCControl.h"
#import <objc/runtime.h>

@implementation UIControl (JCControl)

static const char *kAcceptEventInterval = "kAcceptEventInterval";
static const char *kIgnoreEvent = "kIgnoreEvent";

+ (void)load {
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method selfMethod = class_getInstanceMethod(self, @selector(buttonDelaysendAction:to:forEvent:));
    method_exchangeImplementations(systemMethod, selfMethod);
}

/**
 设置是否忽略点击事件
 */
- (void)setButtonIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, kIgnoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 替换系统的sendAction:to:forEvent:方法
 */
- (void)buttonDelaysendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    BOOL ignoreEvent = [objc_getAssociatedObject(self, kIgnoreEvent) boolValue];
    if (ignoreEvent) {
        return;
    }
    NSTimeInterval acceptEventInterval  = [objc_getAssociatedObject(self, kAcceptEventInterval) doubleValue];
    if (acceptEventInterval > 0) {
        [self performSelector:@selector(setButtonIgnoreEvent:) withObject:@(NO) afterDelay:acceptEventInterval];
    }
    [self buttonDelaysendAction:action to:target forEvent:event];
}

- (UIControl *(^)(BOOL))buttonIgnoreEvent {
    return ^(BOOL ignoreEvent) {
        objc_setAssociatedObject(self, kIgnoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return self;
    };
}

- (UIControl *(^)(NSTimeInterval))buttonAcceptEventInterval {
    return ^(NSTimeInterval acceptEventInterval){
        objc_setAssociatedObject(self, kAcceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return self;
    };
}


@end
