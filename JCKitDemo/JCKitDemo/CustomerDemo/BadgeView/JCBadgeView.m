//
//  JCBadgeView.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/26.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCBadgeView.h"
#import "UIView+JCRect.h"

@interface JCBadgeView () <UIGestureRecognizerDelegate>

@end

@implementation JCBadgeView
{
    UIPanGestureRecognizer *_badgePanGesture;  // 标记拖拽手势
    UILabel *_badgeLabel;                      // 标记标签
    CGFloat _radius;                           // 标记标签的半径
    BOOL    _enableDragBadgeLabel;             // 是否可以拖拽标签
    CGPoint _startCenterPoint;                 // 开始中心点
    CGPoint _originPoint;                      // 原坐标点
    CGPoint _position;                         // 实际位子
    CGFloat _validAttachDistance;              // 有效吸附距离
    CGFloat _maxCircleDistance;                // 最大圆心距离
    CGFloat _breakRadius;                      // 断开半径
    BOOL    _isBreak;                          // 是否已经断开
    BOOL    _isEndDrag;                        // 是否结束拖拽
}

- (instancetype)initWithSuper:(UIView *)superView position:(CGPoint)position radius:(CGFloat)radius {
    if (self = [super init]) {
        _badgePanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleBadgeLabelPanGesture:)];
        _badgePanGesture.delegate = self;
        [superView addGestureRecognizer:_badgePanGesture];
        
        self.backgroundColor = [UIColor blueColor];
        self.userInteractionEnabled = YES;
        
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_badgeLabel];
        _badgeLabel.frame = CGRectMake(0, 0, 20, 20);
        _badgeLabel.center = self.center;
        
        [superView addSubview:self];
    }
    return self;
}


- (void)handleBadgeLabelPanGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"handleBadgeLabelPanGesture");
    CGPoint point = [sender locationInView:sender.view];
    self.origin = point;
    
    switch (sender.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
//            _ce = [sender locationInView:sender.view];
            [self setNeedsDisplay];
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");

    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL  result = YES;
//    if([gestureRecognizer isEqual:_badgePanGesture]){
//        result = CGRectContainsPoint(_badgeLabel.frame, [gestureRecognizer locationInView:gestureRecognizer.view]);
//    }
    return result;
}

@end
