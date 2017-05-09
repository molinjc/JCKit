//
//  JCFPSLabel.m
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCFPSLabel.h"

@implementation JCFPSLabel
{
    CADisplayLink * _link;
    NSUInteger      _count;
    NSTimeInterval  _lastTime;
}

+ (void)windowsAddFPSLabel {
    JCFPSLabel *label = [[JCFPSLabel alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 40, 55, 20)];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        frame.size = CGSizeMake(55, 20);
    }
    
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        self.font = [UIFont systemFontOfSize:14];
        
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    self.textColor = color;
    self.text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    
}

@end
