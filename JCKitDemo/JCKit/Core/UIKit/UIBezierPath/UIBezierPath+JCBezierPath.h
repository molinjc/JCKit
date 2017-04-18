//
//  UIBezierPath+JCBezierPath.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/4/15.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (JCBezierPath)

/** 类属性，创建UIBezierPath实例 */
@property (nonatomic, weak, readonly, class) UIBezierPath *newPath;

/** 绘制矩形 */
@property (nonatomic, weak, readonly, class) UIBezierPath * (^newPathRect)(CGRect rect);

/** 绘制圆形或者椭圆形(取决于传入的rect) */
@property (nonatomic, weak, readonly, class) UIBezierPath * (^newPathOvalIn)(CGRect rect);

/** 创建带有圆角的矩形, 当矩形变成正圆的时候, Radius就不再起作用 */
@property (nonatomic, weak, readonly, class) UIBezierPath * (^newPathRounded)(CGRect rect, CGFloat cornerRadius);

/** 设定特定的角为圆角的矩形, rect: 矩形的Frame, corners: 指定的圆角, cornerRadii: 圆角的大小 */
@property (nonatomic, weak, readonly, class) UIBezierPath * (^newPathRoundingCorners)(CGRect rect, UIRectCorner corners, CGSize cornerRadii);

/** 绘制圆弧 */
@property (nonatomic, weak, readonly, class) UIBezierPath * (^newPathArc)(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise);

/** 通过已有路径创建路径 */
@property (nonatomic, weak, readonly, class) UIBezierPath * (^newPathCGPath)(CGPathRef CGPath);

/** 线宽 */
@property (nonatomic, weak, readonly) UIBezierPath * (^pathLineWidth)(CGFloat lineWidth);

/** 线条拐角类型, 默认kCGLineCapButt(无端点), 其他对应圆形端点、方形端点 */
@property (nonatomic, weak, readonly) UIBezierPath * (^pathLineCapStyle)(CGLineCap lineCapStyle);

/** 线条终点处理, 默认kCGLineJoinMiter(尖角), 其他对应圆角、缺角 */
@property (nonatomic, weak, readonly) UIBezierPath * (^pathLineJoinStyle)(CGLineJoin lineJoinStyle);

/** 最大斜接长度(只有在使用kCGLineJoinMiter是才有效), 边角的角度越小，斜接长度就会越大 */
@property (nonatomic, weak, readonly) UIBezierPath * (^pathMiterLimit)(CGFloat miterLimit);

/** 弯曲路径的渲染精度，默认为0.6，越小精度越高，相应的更加消耗性能 */
@property (nonatomic, weak, readonly) UIBezierPath * (^pathFlatness)(CGFloat flatness);

/** 单双数圈规则是否用于绘制路径, 默认是NO。 */
@property (nonatomic, weak, readonly) UIBezierPath * (^pathUsesEvenOddFillRule)(BOOL usesEvenOddFillRule);

/** 绘制虚线, pattern: 指针类型线性数据 count: pattern中数据个数 phase: 起始位置 */
@property (nonatomic, weak, readonly) UIBezierPath * (^setLineDash)(CGFloat *pattern, NSInteger count,CGFloat phase);

/** 获取绘制虚线的数据 */
@property (nonatomic, weak, readonly) UIBezierPath * (^getLineDash)(CGFloat *pattern, NSInteger *count, CGFloat *phase);

/** 起点 */
@property (nonatomic, weak, readonly) UIBezierPath * (^moveTo)(CGPoint point);

/** 添加点, 连接成线 */
@property (nonatomic, weak, readonly) UIBezierPath * (^addLineTo)(CGPoint point);

/** 绘制二次贝塞尔, endPoint: 结束点；controlPoint: 控制点，就是对应的峰值位置 */
@property (nonatomic, weak, readonly) UIBezierPath * (^addQuadCurveTo)(CGPoint endPoint, CGPoint controlPoint);

/** 绘制三次贝塞尔曲线 */
@property (nonatomic, weak, readonly) UIBezierPath * (^addCurveTo)(CGPoint endPoint, CGPoint controlPoint1, CGPoint controlPoint2);

/** 绘制圆弧曲线, centerPoint: 圆弧的中心，radius: 半径，startAngle: 开始角度(角度表示), endAngle:结束角度(角度表示), clockwise: 是否顺时针方向(YES为顺时针) */
@property (nonatomic, weak, readonly) UIBezierPath * (^addArcWith)(CGPoint centerPoint, CGFloat radius,CGFloat startAngle, CGFloat endAngle, BOOL clockwise);

/** 闭合起始点, 连成线 */
@property (nonatomic, weak, readonly) UIBezierPath *pathClose;

/** 移除当前path的所有点 */
@property (nonatomic, weak, readonly) UIBezierPath *pathRemoveAllPoints;

/** 拼接path */
@property (nonatomic, weak, readonly) UIBezierPath * (^pathAppendPath)(UIBezierPath *bezierPath);

/** 扭转路径, 即起点变成终点, 终点变成起点 */
@property (nonatomic, weak, readonly) UIBezierPath *reverse;

/** 路径进行仿射变换 */
@property (nonatomic, weak, readonly) UIBezierPath * (^applyTransform)(CGAffineTransform transform);

/** 修改当前图形上下文的绘图区域可见, 随后的绘图操作导致呈现内容只有发生在指定路径的填充区域 */
@property (nonatomic, weak, readonly) UIBezierPath *pathAddClip;

/** 描边 */
@property (nonatomic, weak, readonly) UIBezierPath * (^stroke)(UIColor *color);

/** 填充 */
@property (nonatomic, weak, readonly) UIBezierPath * (^fill)(UIColor *color);

/** 设置描边的混合模式, blendMode: 混合模式, 默认为kCGBlendModeNormal; alpha: 透明度 */
@property (nonatomic, weak, readonly) UIBezierPath * (^strokeWith)(CGBlendMode blendMode, CGFloat alpha);

/** 设置填充的混合模式 */
@property (nonatomic, weak, readonly) UIBezierPath * (^fillWith)(CGBlendMode blendMode, CGFloat alpha);
@end
