//
//  NSNotificationCenter+JCNotificationCenter.m
//
//  Created by molin.JC on 2016/12/12.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSNotificationCenter+JCNotificationCenter.h"

@implementation NSNotificationCenter (JCNotificationCenter)

+ (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:anObject];
}

+ (void)postNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

+ (void)postNotificationName:(NSNotificationName)aName  object:(id)anObject {
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject];
}

+ (void)postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}

+ (void)removeObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

+ (void)removeObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
}

+ (id <NSObject>)addObserverForName:(NSNotificationName)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block  {
    return [[NSNotificationCenter defaultCenter] addObserverForName:name object:obj queue:queue usingBlock:block];
}

@end
