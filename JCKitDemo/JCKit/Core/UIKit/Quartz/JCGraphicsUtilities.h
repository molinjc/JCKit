//
//  JCGraphicsUtilities.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 创建一个可变的路径
 @param rect 坐标
 @param radius 半径
 @return CGMutablePathRef
 */
CGMutablePathRef CGPathCreateWithRectAndRadius(CGRect rect, CGFloat radius);

CGMutablePathRef CGPathCreateWithPoints(int count, CGPoint point, ...);

/**
 画矩形
 @param rect 坐标
 @param color 颜色
 */
void JCDrawRectangle(CGRect rect, UIColor *color);

/**
 画有颜色的虚线
 @param p1 起点
 @param p2 终点
 @param color 颜色
 */
void JCDrawColorDottedLine(CGPoint p1, CGPoint p2, UIColor *color);
void JCDrawDottedLine(CGPoint p1, CGPoint p2);

/**
 画直线
 @param p1 起点
 @param p2 终点
 @param width 线宽
 @param color 颜色
 @param cap 线结点的样式
 */
void JCDrawLineCap(CGPoint p1, CGPoint p2, CGFloat width, UIColor *color, CGLineCap cap);
void JCDrawLine(CGPoint p1, CGPoint p2, CGFloat width, UIColor *color);
