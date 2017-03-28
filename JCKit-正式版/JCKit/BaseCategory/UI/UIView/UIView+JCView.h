//
//  UIView+JCView.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JCView)
@property (nonatomic, weak, readonly) UIView * (^cornerRadius)(CGFloat cornerRadius);  // < 设置圆角 >
@property (nonatomic, weak, readonly) UIView * (^borderWidth)(CGFloat borderWidth);    // < 边界宽度 >
@property (nonatomic, weak, readonly) UIView * (^borderColor)(UIColor *borderColor);   // < 边界颜色 >
@property (nonatomic, readonly) CGFloat visibleAlpha;                                  // < 可见透明度 >

/**
 获取View所在的控制器，响应链上的第一个Controller
 */
- (UIViewController *)viewController;

/**
 清空所有子视图
 */
- (void)removeAllSubviews;

/**
 视图快照(截图)
 @return UIImage对象
 */
- (UIImage *)snapshotImage;

/**
 视图快照(截图)
 屏幕会闪下
 @param afterUpdates 截图后是否刷新屏幕
 @return UIImage对象
 */
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 生成快照PDF
 */
- (NSData *)snapshotPDF;

/**
 根据触摸点，获取子视图
 @param touches 触摸点集合
 @return 子视图
 */
- (id)getSubviewWithTouches:(NSSet<UITouch *> *)touches;

/**
 添加多个子控件
 */
- (void)addSubviews:(NSArray <UIView *> *)views;

/**
 添加多个子控件
 @param value 可以是View或数组
 */
- (void)addChild:(id)value;

/**
 设置阴隐
 @param color 阴影颜色
 @param offset 位置
 @param radius 圆角
 */
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 设置View的边框
 */
- (void)setViewBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
