//
//  CALayer+JCLayer.h
//  
//  Created by molin.JC on 2016/11/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (JCLayer)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign, getter=frameSize, setter=setFrameSize:) CGSize size;

- (void)removeAllSublayers;

/** 设置Layer的边框 */
- (void)setLayerBorderWidth:(CGFloat)width color:(CGColorRef)color;

@end
