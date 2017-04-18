//
//  JCTimer.h
//
//  Created by molin.JC on 2017/3/28.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCTimer : NSObject

- (instancetype)initWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats;

- (instancetype)initWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats;

+ (instancetype)timerWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats;

/** 停止 */
- (void)invalidate;

/** 暂停 */
- (void)suspend;

/** 重新开始 */
- (void)resume;

@end
