//
//  UIView+JCRect.h
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JCRect)

@property (nonatomic, assign) CGFloat x;             // frame.origin.x
@property (nonatomic, assign) CGFloat y;             // frame.origin.y
@property (nonatomic, assign) CGFloat width;         // frame.size.width
@property (nonatomic, assign) CGFloat height;        // frame.size.height
@property (nonatomic, assign) CGPoint origin;        // frame.origin
@property (nonatomic, assign) CGSize  size;          // frame.size
@property (nonatomic, assign) CGFloat centerX;       // center.x
@property (nonatomic, assign) CGFloat centerY;       // center.y
@property (nonatomic, assign) CGFloat right;         // frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat bottom;        // frame.origin.y + frame.size.height

@property (nonatomic, assign) CGFloat leftSpacing;   // 左间距
@property (nonatomic, assign) CGFloat rightSpacing;  // 右间距
@property (nonatomic, assign) CGFloat topSpacing;    // 上间距
@property (nonatomic, assign) CGFloat bottomSpacing; // 下间距

@end
