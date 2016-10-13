//
//  JCMarqueeControl.m
//  JC360
//
//  Created by molin on 16/4/18.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCMarqueeControl.h"

@interface JCMarqueeControl ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation JCMarqueeControl

#pragma mark - 初始化

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.label];
        self.marqueeSpeed = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
        self.marqueeSpeed = 1;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CFTimeInterval pausedTime = [self.label.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.label.layer.speed = 0.0;
    self.label.layer.timeOffset = pausedTime;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CFTimeInterval pausedTime = self.label.layer.timeOffset;
    self.label.layer.speed = 1.0;
    self.label.layer.timeOffset = 0.0;
    self.label.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.label.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.label.layer.beginTime = timeSincePause;
}

#pragma mark - 方法

- (void)marquee {
    
    CGRect rect = self.label.frame;
    rect.origin.x = self.frame.size.width;
    self.label.frame = rect;
    CGPoint fromPoint = CGPointMake(self.frame.size.width + self.label.frame.size.width/2, self.frame.size.height/2);
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    [movePath addLineToPoint:CGPointMake(-self.label.frame.size.width/2, self.frame.size.height/2)];
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;
    
    moveAnim.duration = self.label.frame.size.width * self.marqueeSpeed * 0.01;
    [moveAnim setDelegate:self];
    
    [self.label.layer addAnimation:moveAnim forKey:@"marquee"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self marquee];
    }
}

- (void)stopMarquee {
    [self.label.layer removeAnimationForKey:@"marquee"];
    self.label.frame = CGRectMake(0, 0, self.label.frame.size.width, self.frame.size.height);
}

- (void)setLabelWidthWithText {
    CGSize msgSize = [self.label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.label.font,NSFontAttributeName, nil]];
    self.label.frame = CGRectMake(0, 0, msgSize.width, self.frame.size.height);
}

- (void)setLabelWidthWithAttributedText {
    CGSize msgSize = [self.label.attributedText.string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.label.font,NSFontAttributeName, nil]];
    self.label.frame = CGRectMake(0, 0, msgSize.width, self.frame.size.height);
}

#pragma mark - set/get

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.label.frame = CGRectMake(0, 0, self.label.frame.size.width, self.frame.size.height);
}

- (void)setIsMarquee:(BOOL)isMarquee {
    _isMarquee = isMarquee;
    if (isMarquee) {
        [self marquee];
    }else {
        [self stopMarquee];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
    [self setLabelWidthWithText];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.label.font = font;
    [self setLabelWidthWithText];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.label.textColor = textColor;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.label.shadowColor = shadowColor;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    self.label.attributedText = attributedText;
    [self setLabelWidthWithAttributedText];
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

@end
