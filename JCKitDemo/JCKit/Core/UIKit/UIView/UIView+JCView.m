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

- (CGFloat)visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
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

/**
 添加多个子控件
 @param value 可以是View或数组
 */
- (void)addChild:(id)value {
    UIView *parent = self;
    if ([parent isKindOfClass:UIVisualEffectView.class]) {
        parent = ((UIVisualEffectView *)parent).contentView;
    }
    if ([parent isKindOfClass:UITableViewCell.class]) {
        parent = ((UITableViewCell *)parent).contentView;
    }
    if ([parent isKindOfClass:UICollectionViewCell.class]) {
        parent = ((UICollectionViewCell *)parent).contentView;
    }
    
    if ([value isKindOfClass:UIView.class]) {
        [parent addSubview:value];
    }else if ([value isKindOfClass:NSArray.class]) {
        for (id view in value) {
            [parent addSubview:view];
        }
    }else {
        @throw @"Invalid child";
    }
}

/**
 设置阴隐
 */
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
