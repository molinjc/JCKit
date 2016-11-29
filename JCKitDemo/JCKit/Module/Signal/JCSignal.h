//
//  JCSignal.h
//  ObserverPattern
//
//  Created by molin.JC on 2016/11/28.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCSignal : NSObject

/**
 初始化
 */
+ (JCSignal *)signal;

/**
 订阅
 @param subscriptionNumber 订阅好
 @param block 回调
 */
- (void)subscriptionNumber:(NSString *)subscriptionNumber callback:(void (^)())block;

/**
 发送这个订阅号，subscriptionNumber:callback:的block就会启动
 @param subscriptionNumber 订阅号
 @param value 值
 */
- (void)sendSubscriptionNumber:(NSString *)subscriptionNumber withValue:(id)value;

/**
 订阅KVO
 @param subscriptionNumber 订阅号
 @param observe 被观察者
 @param keyPath 被观察者的属性路径
 */
- (void)subscriptionNumber:(NSString *)subscriptionNumber observe:(id)observe keyPath:(NSString *)keyPath;

/**
 订阅通知，订阅号就是通知名
 @param notification 订阅号，也是通知名
 @param block 回调
 */
- (void)subscribeNotification:(NSString *)notification callback:(void (^)(NSNotification *))block;

@end
