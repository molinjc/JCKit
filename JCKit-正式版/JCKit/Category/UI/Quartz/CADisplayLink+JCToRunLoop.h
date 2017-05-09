//
//  CADisplayLink+JCToRunLoop.h
//  
//  Created by molin.JC on 2016/12/15.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CADisplayLink (JCToRunLoop)

+ (CADisplayLink *)displayLinkToRunLoopWithTarget:(id)target selector:(SEL)sel;

- (void)stopDisplayLink;

@end
