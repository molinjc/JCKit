//
//  UIViewController+JCDealloc.m
//  JCViewLayout
//
//  Created by molin.JC on 2017/3/24.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UIViewController+JCDealloc.h"
#import <objc/runtime.h>

static const NSHashTable *_deallocTable = nil;

@implementation UIViewController (JCDealloc)
@dynamic logDealloc;

/** 现存的对象 */
- (NSArray *)allExistingViewController {
    return _deallocTable.objectEnumerator.allObjects;
}

- (void)dealloc {
    BOOL log = [objc_getAssociatedObject(self, @selector(setLogDealloc:)) boolValue];
    if (log) {
        NSLog(@"%@ 释放",[NSString stringWithFormat:@"<%@ %p>", [self class], self]);
    }
}

- (void)dealloc_ViewDidLoad {
    if (!_deallocTable) {
        _deallocTable = [NSHashTable weakObjectsHashTable];
    }
    
    [_deallocTable addObject:self];
    
    [self dealloc_ViewDidLoad];
}

- (void)setLogDealloc:(BOOL)logDealloc {
    objc_setAssociatedObject(self, _cmd, @(logDealloc), OBJC_ASSOCIATION_ASSIGN);
}

+ (void)load {
    Method sysIMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
    Method cusIMethod = class_getInstanceMethod(self, @selector(dealloc_ViewDidLoad));
    method_exchangeImplementations(sysIMethod, cusIMethod);
}

@end

static const NSHashTable *_deallocViewTable = nil;

@implementation UIView (JCDealloc)
@dynamic logDealloc;

- (NSArray *)allExistingView {
    return _deallocViewTable.objectEnumerator.allObjects;
}

+ (void)removeView:(UIView *)view {
    [view removeFromSuperview];
    view = nil;
}

- (void)dealloc {
    BOOL log = [objc_getAssociatedObject(self, @selector(setLogDealloc:)) boolValue];
    if (log) {
        NSLog(@"%@ 释放",[NSString stringWithFormat:@"<%@ %p>", [self class], self]);
    }
}

+ (void)load {
    Method sysIMethod = class_getInstanceMethod(self, @selector(init));
    Method cusIMethod = class_getInstanceMethod(self, @selector(dealloc_init));
    method_exchangeImplementations(sysIMethod, cusIMethod);
}

- (instancetype)dealloc_init {
    if (!_deallocViewTable) {
        _deallocViewTable = [NSHashTable weakObjectsHashTable];
    }
    return [self dealloc_init];
}

- (void)setLogDealloc:(BOOL)logDealloc {
    objc_setAssociatedObject(self, _cmd, @(logDealloc), OBJC_ASSOCIATION_ASSIGN);
}


@end
