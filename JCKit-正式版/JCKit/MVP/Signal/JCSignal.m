//
//  JCSignal.m
//  ObserverPattern
//
//  Created by molin.JC on 2016/11/28.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "JCSignal.h"

#define kKey(obj,key) [NSString stringWithFormat:@"<%@-%@>",obj,key]

static const NSString *kObserve = @"observe";
static const NSString *kKeyPath = @"keyPath";
static const NSString *kSubscriptionNumber = @"subscriptionNumber";

static const NSHashTable *_signalTable = nil;

@implementation JCSignal
{
    NSMutableDictionary * _subscriptionNumbers;
    NSMutableDictionary * _keyPaths;
}

#pragma mark - 发送给远处的

- (void)sendDistanceSubscriptionNumber:(NSString *)subscriptionNumber withValue:(id)value {
    [self sendDistanceSubscriptionNumber:subscriptionNumber withValue1:value value2:nil];
}

- (void)sendDistanceSubscriptionNumber:(NSString *)subscriptionNumber withValue1:(id)value1 value2:(id)value2 {
    [self sendDistanceSubscriptionNumber:subscriptionNumber withValue1:value1 value2:value2 value3:nil];
}

- (void)sendDistanceSubscriptionNumber:(NSString *)subscriptionNumber withValue1:(id)value1 value2:(id)value2 value3:(id)value3 {
    for (JCSignal *signal in [_signalTable objectEnumerator].allObjects) {
        [signal sendSubscriptionNumber:subscriptionNumber withValue1:value1 value2:value2 value3:value3];
    }
}

#pragma mark - 功能实现

/**
 发送这个订阅号，subscriptionNumber:callback:的block就会启动
 @param subscriptionNumber 订阅号
 @param value 值
 */
- (void)sendSubscriptionNumber:(NSString *)subscriptionNumber withValue:(id)value {
    [self sendSubscriptionNumber:subscriptionNumber withValue1:value value2:nil];
}

- (void)sendSubscriptionNumber:(NSString *)subscriptionNumber withValue1:(id)value1 value2:(id)value2 {
    [self sendSubscriptionNumber:subscriptionNumber withValue1:value1 value2:value2 value3:nil];
}

- (void)sendSubscriptionNumber:(NSString *)subscriptionNumber withValue1:(id)value1 value2:(id)value2 value3:(id)value3 {
    NSParameterAssert(subscriptionNumber);
    
    if (![subscriptionNumber isKindOfClass:[NSString class]]) {
        void (^callback)() = [_subscriptionNumbers objectForKey:Subscription(subscriptionNumber)];
        if (callback) {
            callback(subscriptionNumber);
        }
    }
    
    if ([value1 isKindOfClass:[JCSignal class]]) {
        JCSignal *signal = value1;
        [signal sendSubscriptionNumber:subscriptionNumber withValue:value2];
        return;
    }
    
    callbackBlock block = [_subscriptionNumbers objectForKey:subscriptionNumber];
    if (block) {
        block(value1, value2, value3);
    }
}

/**
 订阅
 @param subscriptionNumber 订阅号
 @param block 回调
 */
- (void)subscriptionNumber:(NSString *)subscriptionNumber callback:(void (^)())block {
    NSParameterAssert(subscriptionNumber);
    if (![subscriptionNumber isKindOfClass:[NSString class]]) {
        subscriptionNumber = Subscription(subscriptionNumber);
    }
    if (block) {
        [_subscriptionNumbers setObject:block forKey:subscriptionNumber];
    }
}

/**
 删除订阅
 @param subscriptionNumber 订阅号
 */
- (void)removeSubscriptionNumber:(NSString *)subscriptionNumber {
    NSParameterAssert(subscriptionNumber);
    if (![subscriptionNumber isKindOfClass:[NSString class]]) {
        subscriptionNumber = [NSString stringWithFormat:@"%@", subscriptionNumber];
    }
    [_subscriptionNumbers removeObjectForKey:subscriptionNumber];
}

/**
 获取回调block
 @param subscriptionNumber 订阅号
 */
- (callbackBlock)subscriptionNumber:(NSString *)subscriptionNumber {
    NSParameterAssert(subscriptionNumber);
    if (![subscriptionNumber isKindOfClass:[NSString class]]) {
        subscriptionNumber = [NSString stringWithFormat:@"%@", subscriptionNumber];
    }
    callbackBlock block = [_subscriptionNumbers objectForKey:subscriptionNumber];
    return block;
}

#pragma mark - KVO

/**
 订阅KVO
 @param subscriptionNumber 订阅号
 @param observe 被观察者
 @param keyPath 被观察者的属性路径
 */
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
    [_keyPaths setObject:@{kObserve:observe,
                           kKeyPath:keyPath,
                           kSubscriptionNumber:subscriptionNumber}
                  forKey:kKey(observe, keyPath)];
}

/**
 删除KVO
 @param observe 被观察者
 @param keyPath 被观察者的属性路径
 */
- (void)removeObserve:(id)observe keyPath:(NSString *)keyPath {
    NSParameterAssert(observe);
    NSParameterAssert(keyPath);
    NSString *key = kKey(observe, keyPath);
    [_keyPaths removeObjectForKey:key];
    [observe removeObserver:self forKeyPath:key];
}

#pragma mark - 通知

/**
 订阅通知，订阅号就是通知名
 @param notification 订阅号，也是通知名
 @param block 回调
 */
- (void)subscribeNotification:(NSString *)notification callback:(void (^)(NSNotification *))block {
    NSParameterAssert(notification);
    if (block) {
        [_subscriptionNumbers setObject:block forKey:notification];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:notification object:nil];
    }
}

#pragma mark - 初始化

+ (JCSignal *)signal {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _subscriptionNumbers = [NSMutableDictionary new];
        if (!_signalTable) {
            _signalTable = [NSHashTable weakObjectsHashTable];
        }
        [_signalTable addObject:self];
    }
    return self;
}

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *dic, BOOL * _Nonnull stop) {
        id obj = dic[kObserve];
        NSString *keyPath = dic[kKeyPath];
        [obj removeObserver:self forKeyPath:keyPath];
    }];
    
    [_keyPaths removeAllObjects];
}

#pragma mark - 回调

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
    
    NSString *subscriptionNumber = [_keyPaths objectForKey:kKey(object, keyPath)][kSubscriptionNumber];
    void (^callback)() = [_subscriptionNumbers objectForKey:subscriptionNumber];
    if (callback) {
        callback(object,newVal,oldVal);
    }
}

@end
