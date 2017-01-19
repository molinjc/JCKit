//
//  JCProgressButton.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/9.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCProgressButton.h"

@implementation JCProgressButton
{
    UIButton     * _button;
    CAShapeLayer * _progressLayer;
    NSTimer      * _timer;
    CGFloat        _progress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initBase];
    }
    return self;
}

- (void)initBase {
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button setTitle:@"跳过" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    _button.frame = self.bounds;
    [self addSubview:_button];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor redColor].CGColor;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.lineCap = kCAFillRuleNonZero;
    _progressLayer.lineJoin = kCALineJoinRound;
    _progressLayer.lineWidth = 3;
    _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:(self.frame.size.width - 5) / 2  startAngle:(-M_PI/2) endAngle:(3*M_PI/2) clockwise:YES].CGPath;
    [self.layer addSublayer:_progressLayer];
}

- (void)state {
    _progress = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(progress:) userInfo:nil repeats:YES];
}

- (void)progress:(id)sender {
    _progress += 0.01;
    _progressLayer.strokeEnd = _progress;
    if (_progress >= 1) {
        [_timer invalidate];
        _timer = nil;
        [self.delegate completeWithProgressButton:self];
    }
}

- (void)buttonEvent:(id)sender {
    [self.delegate clickProgressButton:self];
}

@end
