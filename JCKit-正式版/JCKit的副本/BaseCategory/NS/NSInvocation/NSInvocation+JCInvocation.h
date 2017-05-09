//
//  NSInvocation+JCInvocation.h
//
//  Created by molin.JC on 2016/12/23.
//  Copyright © 2016年 molin. All rights reserved.
//
//  调用invoke报错时，检查下是否没有设selector值

#import <Foundation/Foundation.h>

@interface NSInvocation (JCInvocation)

/**
 会先检查sig是否空的初始化方法，为空会抛出异常
 */
+ (instancetype)avoidCrashInvocationWithMethodSignature:(NSMethodSignature *)sig;

+ (instancetype)invocationWithBlock:(id)block;

+ (instancetype)invocationWithBlockAndArguments:(id)block, ...;

/**
 发送多个参数
 */
- (void)arguments:(id)argumentLocation, ...;

@end
