//
//  JCSignal.h
//  ObserverPattern
//
//  Created by molin.JC on 2016/11/28.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//
// 1. block里不能使用下划线属性，要用self.属性 --> _property (不行, 无法释放); self.property(可以释放)
// 2. block最好要有弱引用
// 3. block在viewController里不要多层嵌套，在viewController写个方法，block里面调用这个方法去执行block

#import <Foundation/Foundation.h>

#define weakify(obj) autoreleasepool {} __weak typeof(obj) weak##obj = obj;
#define strongify(obj) autoreleasepool {} __strong typeof(weak##obj) obj = weak##obj;
#define Subscription(v) [NSString stringWithFormat:@"%@",v]

typedef void (^callbackBlock)();

@interface JCSignal : NSObject

/** 初始化 */
+ (JCSignal *)signal;

/**
 订阅
 @param subscriptionNumber 订阅号
 @param block 回调
 */
- (void)subscriptionNumber:(id)subscriptionNumber callback:(callbackBlock)block;

/**
 删除订阅
 @param subscriptionNumber 订阅号
 */
- (void)removeSubscriptionNumber:(id)subscriptionNumber;

/**
 获取回调block
 @param subscriptionNumber 订阅号
 */
- (callbackBlock)subscriptionNumber:(NSString *)subscriptionNumber;

/**
 发送这个订阅号，subscriptionNumber:callback:的block就会启动
 @param subscriptionNumber 订阅号
 @param value 值
 */
- (void)sendSubscriptionNumber:(NSString *)subscriptionNumber withValue:(id)value;
- (void)sendSubscriptionNumber:(NSString *)subscriptionNumber withValue1:(id)value1 value2:(id)value2;
- (void)sendSubscriptionNumber:(NSString *)subscriptionNumber withValue1:(id)value1 value2:(id)value2 value3:(id)value3;


- (void)sendDistanceSubscriptionNumber:(NSString *)subscriptionNumber withValue:(id)value;
- (void)sendDistanceSubscriptionNumber:(NSString *)subscriptionNumber withValue1:(id)value1 value2:(id)value2;
- (void)sendDistanceSubscriptionNumber:(NSString *)subscriptionNumber withValue1:(id)value1 value2:(id)value2 value3:(id)value3;

#pragma mark - KVO

/**
 订阅KVO
 @param subscriptionNumber 订阅号
 @param observe 被观察者
 @param keyPath 被观察者的属性路径
 */
- (void)subscriptionNumber:(NSString *)subscriptionNumber observe:(id)observe keyPath:(NSString *)keyPath;

/**
 删除KVO
 @param observe 被观察者
 @param keyPath 被观察者的属性路径
 */
- (void)removeObserve:(id)observe keyPath:(NSString *)keyPath;

#pragma mark - 通知

/**
 订阅通知，订阅号就是通知名
 @param notification 订阅号，也是通知名
 @param block 回调
 */
- (void)subscribeNotification:(NSString *)notification callback:(void (^)(NSNotification *))block;

@end
