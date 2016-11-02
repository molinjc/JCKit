//
//  UITextField+JCTextField.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UITextField+JCTextField.h"
#import <objc/runtime.h>

#define kPredicate @"Predicate"

@interface _JCTextPredicateTarget : NSObject

@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, copy) void (^predicateBlock)(BOOL);
@property (nonatomic, copy) NSString *notificationName;

- (instancetype)initWithPredicate:(NSString *)predicate;
- (void)setPredicateFormat:(NSString *)predicate;
- (void)addPredicateBlock:(void (^)(BOOL))block;
- (void)invoke:(UITextField *)sender;

@end
@implementation _JCTextPredicateTarget

- (instancetype)initWithPredicate:(NSString *)predicate {
    if (self = [super init]) {
        _predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicate];
    }
    return self;
}

- (void)setPredicateFormat:(NSString *)predicate {
    _predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicate];
}

- (void)addPredicateBlock:(void (^)(BOOL))block {
    _predicateBlock = [block copy];
}

- (void)addNotificationName:(NSString *)notificationName {
    _notificationName = notificationName;
}

- (void)invoke:(UITextField *)sender {
    if (_predicateBlock) {
        _predicateBlock([_predicate evaluateWithObject:sender.text]);
    }else if (_notificationName.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:nil userInfo:@{@"kPredicate":@([_predicate evaluateWithObject:sender.text])}];
    }
}

@end


@implementation UITextField (JCTextField)

/**
 设置Placeholder占位符的颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [self setValue:placeholderColor forKey:@"_placeholderLabel.textColor"];
}

- (void)addPredicate:(NSString *)predicate action:(void (^)(BOOL))block {
    _JCTextPredicateTarget *_target = [self _actionTargets][kPredicate];
    if (!_target) {
        _target = [[_JCTextPredicateTarget alloc] init];
        NSMutableDictionary *targets = [self _actionTargets];
        targets[kPredicate] = _target;
    }
    
    [_target setPredicateFormat:predicate];
    [_target addPredicateBlock:block];
    [self addTarget:_target action:@selector(invoke:) forControlEvents:UIControlEventEditingChanged];
}

- (void)addPredicate:(NSString *)predicate notificationName:(NSString *)notificationName {
    _JCTextPredicateTarget *_target = [self _actionTargets][kPredicate];
    if (!_target) {
        _target = [[_JCTextPredicateTarget alloc] init];
        NSMutableDictionary *targets = [self _actionTargets];
        targets[kPredicate] = _target;
    }
    [_target setPredicateFormat:predicate];
    [_target addPredicateBlock:nil];
    [_target addNotificationName:notificationName];
    [self addTarget:_target action:@selector(invoke:) forControlEvents:UIControlEventEditingChanged];
}

- (void)removePredicateTarget {
    NSMutableDictionary *targets = [self _actionTargets];
    [targets enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:@selector(invoke:) forControlEvents:UIControlEventEditingChanged];
    }];
}

- (NSMutableDictionary *)_actionTargets {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, _cmd);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
