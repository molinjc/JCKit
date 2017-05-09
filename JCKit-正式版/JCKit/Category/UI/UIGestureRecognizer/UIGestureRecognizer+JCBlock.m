//
//  UIGestureRecognizer+JCBlock.m
//
//  Created by molin.JC on 2016/11/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIGestureRecognizer+JCBlock.h"
#import <objc/runtime.h>

@interface _JCGestureRecognizerActionTarget : NSObject

@property (nonatomic, copy) void (^actionBlock)(id);
- (instancetype)initWithBlock:(void (^)(id))block;
- (void)invoke:(id)sender;

@end

@implementation _JCGestureRecognizerActionTarget

- (instancetype)initWithBlock:(void (^)(id))block {
    if (self = [super init]) {
        _actionBlock = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_actionBlock) {
        _actionBlock(sender);
    }
}

@end

@implementation UIGestureRecognizer (JCBlock)

+ (id)gestureRecognizer:(JCGesture)gesture {
    switch (gesture) {
        case JCGesturePan:
            return [[UIPanGestureRecognizer alloc] init];
        case JCGesturePinch:
            return [[UIPinchGestureRecognizer alloc] init];
        case JCGestureRotation:
            return [[UIRotationGestureRecognizer alloc] init];
        case JCGestureTap:
            return [[UITapGestureRecognizer alloc] init];
        case JCGestureLongPress:
            return [[UILongPressGestureRecognizer alloc] init];
        case JCGestureSwipe:
            return [[UISwipeGestureRecognizer alloc] init];
        default:
            return nil;
    }
}

+ (instancetype)gestureRecognizerWithActionBlock:(void (^)(id))block {
    return [[UIGestureRecognizer alloc] initWithActionBlock:block];
}

- (instancetype)initWithActionBlock:(void (^)(id))block {
    if (self = [self init]) {
        [self addActionBlock:block];
    }
    return self;
}

- (void)addActionBlock:(void (^)(id))block {
    _JCGestureRecognizerActionTarget *target = [[_JCGestureRecognizerActionTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    [self._allActionTargets addObject:target];
}

- (void)removeAllActionBlocks {
    NSMutableArray *_targets = [self _allActionTargets];
    [_targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:@selector(invoke:)];
    }];
    [_targets removeAllObjects];
}

- (NSMutableArray *)_allActionTargets {
    NSMutableArray *_targets = objc_getAssociatedObject(self, _cmd);
    if (!_targets) {
        _targets = [NSMutableArray new];
        objc_setAssociatedObject(self, _cmd, _targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _targets;
}

@end
