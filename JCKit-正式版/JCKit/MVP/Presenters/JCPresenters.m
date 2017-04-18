//
//  JCPresenters.m
//
//  Created by molin.JC on 2017/3/23.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCPresenters.h"

@implementation JCPresenters

- (JCSignal *)signal {
    if (!_signal) {
        _signal = [JCSignal signal];
    }
    return _signal;
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", [self class]);
}

@end
