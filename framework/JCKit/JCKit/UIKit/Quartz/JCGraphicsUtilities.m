//
//  JCGraphicsUtilities.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCGraphicsUtilities.h"

/**
 创建一个可变的路径
 */
CGMutablePathRef CGPathCreateWithRectAndRadius(CGRect rect, CGFloat radius) {
    CGPoint x1, x2, x3, x4;  // 四个顶点
    CGPoint y1, y2, y3, y4, y5, y6, y7, y8;  // 有圆角的8个顶点， 从左上角顶点开始，顺时针方向
    
    x1 = rect.origin;
    x2 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    x3 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    x4 = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    
    y1 = CGPointMake(rect.origin.x + radius, rect.origin.y);
    y2 = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y);
    y3 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + radius);
    y4 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.width - radius);
    y5 = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.width);
    y6 = CGPointMake(rect.origin.x + radius, rect.origin.y + rect.size.width);
    y7 = CGPointMake(rect.origin.x, rect.origin.y + rect.size.width - radius);
    y8 = CGPointMake(rect.origin.x, rect.origin.y + radius);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    if (radius <= 0) {
        CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, x1.x, x1.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x2.x, x2.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x3.x, x3.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x4.x, x4.y);
    }else {
        CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, y1.x, y1.y);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y2.x, y2.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity, x2.x, x2.y, y3.x, y3.y, radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y4.x, y4.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity, x3.x, x3.y, y5.x, y5.y, radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y6.x, y6.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity, x4.x, x4.y, y7.x, y7.y, radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y8.x, y8.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity, x1.x, x1.y, y1.x, y1.y, radius);
    }
    
    CGPathCloseSubpath(pathRef);
    return pathRef;
}

/**
 创建多个点的路径
 */
CGMutablePathRef CGPathCreateWithPoints(int count, CGPoint point, ...) {
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, point.x, point.y);
    va_list points;
    va_start(points, point);
    CGPoint temporary;
    for (int i=0; i<count-1; i++) {
        temporary = va_arg(points, CGPoint);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, temporary.x, temporary.y);
    }
    va_end(points);
    CGPathCloseSubpath(pathRef);
    return pathRef;
}

/**
 画矩形
 */
void JCDrawRectangle(CGRect rect, UIColor *color) {
    CGContextRef _contextRef = UIGraphicsGetCurrentContext();
    CGMutablePathRef _pathRef = CGPathCreateWithRectAndRadius(rect, 0);
    CGContextAddPath(_contextRef, _pathRef);
    CGContextSetFillColorWithColor(_contextRef, color.CGColor);
    CGContextDrawPath(_contextRef, kCGPathFill);
    CGPathRelease(_pathRef);
}

/**
 画虚线
 */
void JCDrawDottedLine(CGPoint p1, CGPoint p2) {
    JCDrawColorDottedLine(p1, p2, [UIColor grayColor]);
}

/**
 画有颜色的虚线
 */
void JCDrawColorDottedLine(CGPoint p1, CGPoint p2, UIColor *color) {
    CGContextRef _contextRef = UIGraphicsGetCurrentContext();
    CGContextBeginPath(_contextRef);
    CGContextSetLineWidth(_contextRef, 1);
    CGContextSetStrokeColorWithColor(_contextRef, color.CGColor);
    CGFloat lengths[] = {1,8};
    CGContextSetLineDash(_contextRef, 0, lengths, 1);
    CGContextMoveToPoint(_contextRef, p1.x, p1.y);
    CGContextAddLineToPoint(_contextRef, p2.x, p2.y);
}

/**
 画直线
 */
void JCDrawLineCap(CGPoint p1, CGPoint p2, CGFloat width, UIColor *color, CGLineCap cap) {
    CGContextRef _contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(_contextRef, cap);
    CGContextSetLineWidth(_contextRef, width);
    [color setStroke];
    [color setFill];
    CGContextMoveToPoint(_contextRef, p1.x, p1.y);
    CGContextAddLineToPoint(_contextRef, p2.x, p2.y);
    CGContextStrokePath(_contextRef);
}

/**
 画直线
 */
void JCDrawLine(CGPoint p1, CGPoint p2, CGFloat width, UIColor *color) {
    JCDrawLineCap(p1, p2, width, color, kCGLineCapRound);
}

///**
// 画多边形
// @param center <#center description#>
// @param radius <#radius description#>
// @param number <#number description#>
// */
//void JCDrawPolygon(CGPoint center, CGFloat radius, int number) {
//    CGContextRef _contextRef = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(_contextRef, center.x + radius, center.y);
//    for (int i = 1; i <= number; i++) {
//         CGPoint point = CGPointMake(center.x + radius * cos(2 * M_PI * i / number),
//                                     center.x + radius * sin(2 * M_PI * i / number));
//        CGContextAddLineToPoint(_contextRef, point.x, point.y);
//    }
//}

CGMutablePathRef CGPathCreateWithPolygon(CGPoint center, CGFloat radius, int number) {
    CGMutablePathRef wavePath = CGPathCreateMutable();
    for (int i = 1; i<= number; i++) {
        CGPoint point = CGPointMake(center.x + radius * sin(2 * M_PI * i / number),
                                    center.y + radius * cos(2 * M_PI * i / number));
        if (i == 1) {
            CGPathMoveToPoint(wavePath, NULL, point.x, point.y);
        }else {
            CGPathAddLineToPoint(wavePath, NULL, point.x, point.y);
        }
    }
    CGPathCloseSubpath(wavePath);
    return wavePath;
}

/**
 类似刮刮乐的效果
 */
UIImage * JCImageScratch(CALayer *layer, CGSize size, CGRect clearRect) {
    //设置一张与imageView同大小的上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //获取到此上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //将上下文添加到layer层
    [layer renderInContext:ref];
    //清除上下文中需要清理的rect
    CGContextClearRect(ref, clearRect);
    //获取清理后的上下文，以Image形式
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 保留rect内的像素，之外不要，颜色为layer的背景颜色
 */
UIImage *JCImagePictureClip(CALayer *layer, CGRect rect) {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];   // 设置裁剪区域
    [path addClip];
    CGContextRef ref = UIGraphicsGetCurrentContext();   // 获取当前上下文
    [layer renderInContext:ref];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   // 关闭上下文
    return image;
}

/**
 画一条波浪纹
 */
void JCWaveShapeLayer(CAShapeLayer *shapeLayer, CGFloat amplitude, CGFloat cycle, CGFloat drift, CGSize size) {
    CGMutablePathRef wavePath = JCWavePathRef(amplitude, cycle, drift, size);
    shapeLayer.path = wavePath;
    //使用layer 而没用CurrentContext
    CGPathRelease(wavePath);
}

/**
 创建一条波浪纹路径
 @param amplitude 振幅
 @param cycle 周期
 @param drift 位移
 @param size 波浪纹的高宽
 @return CGMutablePathRef 路径
 */
CGMutablePathRef JCWavePathRef(CGFloat amplitude, CGFloat cycle, CGFloat drift, CGSize size) {
    CGMutablePathRef wavePath = CGPathCreateMutable();
    CGFloat y = size.height;
    //将点移动到 x=0,y=size.height的位置
    CGPathMoveToPoint(wavePath, NULL, 0, y);
    
    for (int i = 0; i <= size.width; i++) {
        //正弦函数波浪公式
        y = amplitude * sin(cycle * i + drift) + size.height;
        //将点连成线
        CGPathAddLineToPoint(wavePath, NULL, i, y);
    }
    
    CGPathAddLineToPoint(wavePath, NULL, size.width, 0);
    CGPathAddLineToPoint(wavePath, NULL, 0, 0);
    CGPathCloseSubpath(wavePath);
    return wavePath;
}
