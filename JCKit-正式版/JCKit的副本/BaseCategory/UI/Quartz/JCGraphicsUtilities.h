//
//  JCGraphicsUtilities.h
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

/**
 创建多个点的路径
 @param count 个数
 @param point 点(CGPoint)
 @param ... 点(CGPoint)
 @return CGMutablePathRef
 */
CGMutablePathRef CGPathCreateWithPoints(int count, CGPoint point, ...);

/**
 创建一条波浪纹路径
 @param amplitude 振幅
 @param cycle 周期
 @param drift 位移
 @param size 波浪纹的高宽
 @return CGMutablePathRef 路径
 */
CGMutablePathRef JCWavePathRef(CGFloat amplitude, CGFloat cycle, CGFloat drift, CGSize size);

/**
 画一条波浪纹
 @param shapeLayer 画笔图层
 @param amplitude 振幅
 @param cycle 周期
 @param drift 位移
 @param size 波浪纹的高宽
 */
void JCWaveShapeLayer(CAShapeLayer *shapeLayer, CGFloat amplitude, CGFloat cycle, CGFloat drift, CGSize size);

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

//void JCDrawPolygon(CGPoint center, CGFloat radius, int number);

CGMutablePathRef CGPathCreateWithPolygon(CGPoint center, CGFloat radius, int number);

/**
 类似刮刮乐的效果
 @param layer 被刮的图层
 @param size  设置image大小
 @param clearRect 被刮的位置
 @return UIImage
 @Example:
 UIImage *image = JCImageScratch(imageView.layer, imageView.bounds.size, CGRectMake(x, y, w, h));
 */
UIImage * JCImageScratch(CALayer *layer, CGSize size, CGRect clearRect);

/**
 保留rect内的像素，之外不要，颜色为layer的背景颜色
 @param layer 被截的图层
 @param rect 要保留的像素范围
 @return UIImage
 */
UIImage *JCImagePictureClip(CALayer *layer, CGRect rect);
