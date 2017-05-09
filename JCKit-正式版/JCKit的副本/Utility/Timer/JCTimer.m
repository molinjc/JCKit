//
//  JCTimer.m
//
//  Created by molin.JC on 2017/3/28.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCTimer.h"

@implementation JCTimer
{
    /** 目标类 */
    __weak id _target;
    /** 目标类要调用的方法 */
    SEL _selector;
    /** 是否重复 */
    BOOL _repeats;
    /** GCD定时器的来源 */
    dispatch_source_t _source;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"JCTimer init error" reason:@"Use the designated initializer to init." userInfo:nil];
    return [self initWithStart:0 interval:0 target:nil selector:NULL repeats:NO];
}

- (instancetype)initWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    if (self = [super init]) {
        _target = target;
        _selector = selector;
        _repeats = repeats;
        
        __weak typeof(self) _self = self;
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_source, dispatch_time(DISPATCH_TIME_NOW, (start * NSEC_PER_SEC)), (interval * NSEC_PER_SEC), 0);
        dispatch_source_set_event_handler(_source, ^{
            [_self _handler];
        });
        dispatch_resume(_source);
    }
    return self;
}

- (instancetype)initWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [self initWithStart:interval interval:interval target:target selector:selector repeats:repeats];
}

+ (instancetype)timerWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [[JCTimer alloc] initWithStart:interval interval:interval target:target selector:selector repeats:repeats];
}

- (void)_handler {
    if (_target && _selector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
    }
    if (!_repeats) {
        [self invalidate];
    }
}

- (void)invalidate {
    dispatch_source_cancel(_source);
    _source = NULL;
    _target = nil;
    _selector = NULL;
}

- (void)suspend {
    dispatch_suspend(_source);
}

- (void)resume {
    dispatch_resume(_source);
}

@end
