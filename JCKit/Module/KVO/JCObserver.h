//
//  JCObserver.h
//  JCKit
//
//  Created by 林建川 on 16/8/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCObserver : NSObject

// 添加KVO的block回调
- (void)addFromKVOBlock:(void (^)(__weak id obj, id oldValue, id newValue))block;

// 添加用通知传值得KVO
- (void)addFromKVONotificationBlock:(NSString *)mark;

// 添加通知的回调
- (void)addFromNotificationBlock:(void(^)(NSNotification *notification))block;

// 通知的SEL
- (void)notificationCallback:(NSNotification *)notification;

@end
