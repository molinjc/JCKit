//
//  CADisplayLink+JCToRunLoop.m
//  
//  Created by molin.JC on 2016/12/15.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "CADisplayLink+JCToRunLoop.h"

@implementation CADisplayLink (JCToRunLoop)

+ (CADisplayLink *)displayLinkToRunLoopWithTarget:(id)target selector:(SEL)sel {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:target selector:sel];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return displayLink;
}

- (void)stopDisplayLink {
    [self invalidate];
}

@end
