//
//  UIView+JCView.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIView+JCView.h"

@implementation UIView (JCView)

- (UIView *(^)(CGFloat))cornerRadius {
    return ^(CGFloat cornerRadius) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
        return self;
    };
}

- (UIView *(^)(CGFloat))borderWidth {
    return ^(CGFloat borderWidth) {
        self.layer.borderWidth = borderWidth;
        return self;
    };
}

- (UIView *(^)(UIColor *))borderColor {
    return ^(UIColor *borderColor) {
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
}

/**
 获取View所在的控制器，响应链上的第一个Controller
 */
- (UIViewController *)viewController {
    UIResponder *nextResponder = self;
    do {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    } while (nextResponder != nil);
    return nil;
}

/**
 清空所有子视图
 */
- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

/**
 视图快照(截图)
 @return UIImage对象
 */
- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

/**
 视图快照(截图)
 屏幕会闪下
 @param afterUpdates 截图后是否刷新屏幕
 @return UIImage对象
 */
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

/**
 生成快照PDF
 */
- (NSData *)snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    
    if (!context) {
        return nil;
    }
    
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

/**
 根据触摸点，获取子视图
 @param touches 触摸点集合
 @return 子视图
 */
- (id)getSubviewWithTouches:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for (UIView *_subview in self.subviews) {
        if (CGRectContainsPoint(_subview.frame, point)) {
            return _subview;
        }
    }
    return nil;
}

/**
 添加多个子控件
 */
- (void)addSubviews:(NSArray <UIView *> *)views {
    [views enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:subview];
    }];
}

@end
