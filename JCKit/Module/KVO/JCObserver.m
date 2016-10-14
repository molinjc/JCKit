//
//  JCObserver.m
//  JCKit
//
//  Created by 林建川 on 16/8/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCObserver.h"
#import <objc/runtime.h>

@implementation JCObserver
{
    NSMutableSet *_KVOBlockSet;
    NSMutableSet *_KVONotificationBlockSet;
    NSMutableSet *_notificationBlockSet;
}


- (instancetype)init {
    if (self = [super init]) {
        _KVOBlockSet = [NSMutableSet new];
        _KVONotificationBlockSet = [NSMutableSet new];
        _notificationBlockSet = [NSMutableSet new];
    }
    return self;
}

- (void)addFromKVOBlock:(void (^)(__weak id, id, id))block {
    [_KVOBlockSet addObject:[block copy]];
    NSLog(@"_KVOBlockSet:%@",_KVOBlockSet);
}

- (void)addFromKVONotificationBlock:(NSString *)mark {
    [_KVONotificationBlockSet addObject:mark];
}

- (void)addFromNotificationBlock:(void (^)(NSNotification *))block {
    [_notificationBlockSet addObject:[block copy]];
}

/**
 *  KVO 回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    BOOL prior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    //只接受值改变时的消息
    if (prior) {
        return;
    }
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (changeKind != NSKeyValueChangeSetting) {
        return;
    }
    
    // KVO
    if (_KVOBlockSet.count) {
        if (oldVal == [NSNull null]) {
            oldVal = nil;
        }
        if (newVal == [NSNull null]) {
            newVal = nil;
        }
        [_KVOBlockSet enumerateObjectsUsingBlock:^(void (^block)(__weak id obj, id oldVal, id newVal), BOOL * _Nonnull stop) {
            block(object, oldVal, newVal);
        }];
    }
    
    // 通知
    if (_KVONotificationBlockSet.count) {
        NSMutableDictionary *valueDicM = [NSMutableDictionary new];
        if (oldVal != [NSNull null]) {
            valueDicM[@"oblValue"] = oldVal;
        }
        if (newVal != [NSNull null]) {
            valueDicM[@"newValue"] = newVal;
        }
        valueDicM[@"obj"] = object;
        [_KVONotificationBlockSet enumerateObjectsUsingBlock:^(NSString *mark, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] postNotificationName:mark object:nil userInfo:valueDicM];
        }];
    }
}

/**
 *  通知的回调
 */
- (void)notificationCallback:(NSNotification *)notification {
    if (_notificationBlockSet.count) {
        [_notificationBlockSet enumerateObjectsUsingBlock:^(void (^block)(NSNotification *notification), BOOL * _Nonnull stop) {
            block(notification);
        }];
    }
}


@end
