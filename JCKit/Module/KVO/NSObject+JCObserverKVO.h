//
//  NSObject+JCObserver.h
//  JCKit
//
//  Created by 林建川 on 16/8/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author JC, 08/24/16 17:43
 *
 *  KVO
 */
@interface NSObject (JCObserverKVO)

/**
 *  添加监听(KVO)，无需手动移除，其会在被监听对象销毁的时候自动移除
 *
 *  @param keyPath 要监听的路径
 *  @param change  结果变化的回调
 */
- (void)addKeyPath:(NSString *)keyPath change:(void (^)(id obj, id oldValue, id newValue))change;

/**
 *  提前移除KVO下指定的KeyPath
 */
- (void)removeObserverForKeyPath:(NSString *)keyPath;

/**
 *  清除所有KVO监听
 */
- (void)removeAllObserver;

@end

/**
 *  @author JC, 08/24/16 17:44
 *
 *  通知
 */
@interface NSObject (JCObserverNotification)

/**
 *  发送通知
 *
 *  @param name     通知名
 *  @param userInfo 要传递的数据
 */
- (void)postNotificationForName:(NSString *)name userInfo:(NSDictionary *)userInfo;

/**
 *  添加接收通知
 *
 *  @param name     通知名
 *  @param callback 回调处理
 */
- (void)addNotificationForName:(NSString *)name callback:(void (^)(NSNotification *notification))callback;

/**
 *  清除所有通知
 */
- (void)removeAllNotification;

/**
 *  清除指定的通知
 *
 *  @param name 通知名
 */
- (void)removeNotificationForName:(NSString *)name;

@end

/**
 *  @author JC, 08/24/16 17:44
 *
 *  KVO or 通知
 */
@interface NSObject (JCObserverKVONotification)

/**
 *  添加监听属性路径，用通知来回调，无需手动移除，其会在被监听对象销毁的时候自动移除
 *
 *  @param keyPath 属性
 *  @param mark    通知名
 */
- (void)addKeyPath:(NSString *)keyPath elsewhereObserveForMark:(NSString *)mark;

/**
 *  接收通知消息
 *
 *  @param mark   通知名
 *  @param change 回调
 */
- (void)addObserveFromMark:(NSString *)mark change:(void (^)(id obj, id oldValue, id newValue))change;

/**
 *  提前移除回调方法为通知的KVO下指定的KeyPath
 */
- (void)removeElsewhereObserverForKeyPath:(NSString *)keyPath;

/**
 *  清除回调方式通知的所有KVO监听
 */
- (void)removeAllElsewhereObserver;

@end