//
//  UIControl+JCControl.m
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIControl+JCControl.h"
#import <objc/runtime.h>

@interface _JCUIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;

- (instancetype)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation _JCUIControlBlockTarget

- (instancetype)initWithBlock:(void (^)(id))block events:(UIControlEvents)events {
    if (self = [super init]) {
        _block = [block copy];
        _events = events;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block) {
        _block(sender);
    }
}

@end

#pragma mark -

@implementation UIControl (JCControl)

static const char *kAcceptEventInterval = "kAcceptEventInterval";
static const char *kIgnoreEvent = "kIgnoreEvent";
static const char *kBlockKey = "kBlockKey";

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

#pragma mark -

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents  {
    if (!target || !action || !controlEvents) {
        return;
    }
    
    NSSet *targets = [self allTargets];
    for (id currentTarget in targets) {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *currentAction in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(currentAction) forControlEvents:controlEvents];
        }
    }
    
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    if (!controlEvents) {
        return;
    }
    
    _JCUIControlBlockTarget *target = [[_JCUIControlBlockTarget alloc] initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _jc_allUIControlBlockTargets];
    [targets addObject:target];
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) {
        return;
    }
    
    NSMutableArray *targets = [self _jc_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_JCUIControlBlockTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}

- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    [self removeAllBlocksForControlEvents:UIControlEventAllEvents];
    [self addBlockForControlEvents:controlEvents block:block];
}

- (void)removeAllTargets {
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self _jc_allUIControlBlockTargets] removeAllObjects];
}

- (NSMutableArray *)_jc_allUIControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &kBlockKey);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &kBlockKey, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
