//
//  JCSignal.m
//  ObserverPattern
//
//  Created by molin.JC on 2016/11/28.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "JCSignal.h"

#define kKey(obj,key) [NSString stringWithFormat:@"<%@-%@>",obj,key]

static  NSMutableDictionary  *_senderDictionary = nil;

@implementation JCSignal
{
    NSMutableDictionary * _subscriptionNumbers;
    NSMutableDictionary * _keyPaths;
}

+ (JCSignal *)signal {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _subscriptionNumbers = [NSMutableDictionary new];
    }
    return self;
}


- (void)sendSubscriptionNumber:(NSString *)subscriptionNumber withValue:(id)value {
    NSParameterAssert(subscriptionNumber);
    
    if ([value isKindOfClass:[JCSignal class]]) {
        JCSignal *signal = value;
        [signal sendSubscriptionNumber:subscriptionNumber withValue:nil];
        return;
    }
    
    void (^callback)() = [_subscriptionNumbers objectForKey:subscriptionNumber];
    if (callback) {
        callback(value);
    }
}

- (void)subscriptionNumber:(NSString *)subscriptionNumber callback:(void (^)())block {
    NSParameterAssert(subscriptionNumber);
    if (block) {
        [_subscriptionNumbers setObject:block forKey:subscriptionNumber];
    }
}

- (void)removeSubscriptionNumber:(NSString *)subscriptionNumber {
    NSParameterAssert(subscriptionNumber);
    [_subscriptionNumbers removeObjectForKey:subscriptionNumber];
}

- (void)subscriptionNumber:(NSString *)subscriptionNumber observe:(id)observe keyPath:(NSString *)keyPath {
    NSParameterAssert(subscriptionNumber);
    NSParameterAssert(observe);
    NSParameterAssert(keyPath);
    
    [observe addObserver:self forKeyPath:keyPath
                 options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                 context:nil];
    
    if (!_keyPaths) {
        _keyPaths = [NSMutableDictionary new];
    }
    [_keyPaths setObject:@{@"observe":observe,
                           @"keyPath":keyPath,
                           @"subscriptionNumber":subscriptionNumber}
                  forKey:kKey(observe, keyPath)];
}

- (void)removeObserve:(id)observe keyPath:(NSString *)keyPath {
    NSParameterAssert(observe);
    NSParameterAssert(keyPath);
    NSString *key = kKey(observe, keyPath);
    [_keyPaths removeObjectForKey:key];
    [observe removeObserver:self forKeyPath:key];
}

- (void)subscribeNotification:(NSString *)notification callback:(void (^)(NSNotification *))block {
    NSParameterAssert(notification);
    if (block) {
        [_subscriptionNumbers setObject:block forKey:notification];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:notification object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *dic, BOOL * _Nonnull stop) {
        id obj = dic[@"observe"];
        NSString *keyPath = dic[@"keyPath"];
        [obj removeObserver:self forKeyPath:keyPath];
    }];
    
    [_keyPaths removeAllObjects];
}

/**
 通知回调
 */
- (void)notification:(NSNotification *)notification {
    void (^callback)(NSNotification *) = [_subscriptionNumbers objectForKey:notification.name];
    if (callback) {
        callback(notification);
    }
}

/**
 KVO回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
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
    
    NSString *subscriptionNumber = [_keyPaths objectForKey:kKey(object, keyPath)][@"subscriptionNumber"];
    void (^callback)() = [_subscriptionNumbers objectForKey:subscriptionNumber];
    if (callback) {
        callback(object,newVal,oldVal);
    }
}

@end
