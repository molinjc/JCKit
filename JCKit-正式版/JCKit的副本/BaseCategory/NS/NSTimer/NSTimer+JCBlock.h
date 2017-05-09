//
//  NSTimer+JCBlock.h
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (JCBlock)

/**
 *  创建并返回一个新的NSTimer对象，它在当前运行默认模式中的循环。
 */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

/**
 *  创建并返回一个新的NSTimer对象和指定的块进行初始化
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

/**
 暂停
 */
- (void)pause;

/**
 继续
 */
- (void)continuation;

/**
 interval秒后继续
 @param interval 秒
 */
- (void)continuation:(NSTimeInterval)interval;

@end
