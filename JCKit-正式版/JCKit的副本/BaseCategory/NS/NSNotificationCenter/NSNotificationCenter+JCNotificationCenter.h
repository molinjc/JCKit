//
//  NSNotificationCenter+JCNotificationCenter.h
//
//  Created by molin.JC on 2016/12/12.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (JCNotificationCenter)

+ (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject;

+ (void)postNotification:(NSNotification *)notification;

+ (void)postNotificationName:(NSNotificationName)aName  object:(id)anObject;

+ (void)postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

+ (void)removeObserver:(id)observer;

+ (void)removeObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject;

+ (id <NSObject>)addObserverForName:(NSNotificationName)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;

@end
