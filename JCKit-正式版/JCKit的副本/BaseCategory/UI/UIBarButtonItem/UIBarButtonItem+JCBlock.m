//
//  UIBarButtonItem+JCBlock.m
//
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIBarButtonItem+JCBlock.h"
#import <objc/runtime.h>

static void *const kTarget = @"Target";

@interface _JCUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)barButtonItem_invoke:(id)sender;

@end

@implementation _JCUIBarButtonItemBlockTarget

- (id)initWithBlock:(void (^)(id))block {
    if (self = [super init]) {
        _block = [block copy];
    }
    return self;
}

- (void)barButtonItem_invoke:(id)sender {
    if (self.block) {
        self.block(sender);
    }
}

@end

@implementation UIBarButtonItem (JCBlock)
@dynamic imageTop, imageLeft;

#pragma mark - Set/Get

- (void)setActionBlock:(void (^)(id))actionBlock {
    _JCUIBarButtonItemBlockTarget *target = [[_JCUIBarButtonItemBlockTarget alloc] initWithBlock:actionBlock];
    objc_setAssociatedObject(self, kTarget, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(barButtonItem_invoke:)];
}

- (void (^)(id))actionBlock {
    _JCUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, kTarget);
    return target.block;
}

#pragma mark - 简化初始方法

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id sender))actionBlock {
    _JCUIBarButtonItemBlockTarget *target = [[_JCUIBarButtonItemBlockTarget alloc] initWithBlock:actionBlock];
    objc_setAssociatedObject(self, kTarget, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [self initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                         style:style
                        target:target
                        action:@selector(barButtonItem_invoke:)];
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id sender))actionBlock {
    _JCUIBarButtonItemBlockTarget *target = [[_JCUIBarButtonItemBlockTarget alloc] initWithBlock:actionBlock];
    objc_setAssociatedObject(self, kTarget, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [self initWithTitle:title
                         style:style
                        target:target
                        action:@selector(barButtonItem_invoke:)];
}

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem actionBlock:(void (^)(id sender))actionBlock {
    _JCUIBarButtonItemBlockTarget *target = [[_JCUIBarButtonItemBlockTarget alloc] initWithBlock:actionBlock];
    objc_setAssociatedObject(self, kTarget, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [self initWithBarButtonSystemItem:systemItem
                                      target:target
                                      action:@selector(barButtonItem_invoke:)];
}

- (instancetype)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id sender))actionBlock {
    _JCUIBarButtonItemBlockTarget *target = [[_JCUIBarButtonItemBlockTarget alloc] initWithBlock:actionBlock];
    objc_setAssociatedObject(self, kTarget, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [self initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
           landscapeImagePhone:landscapeImagePhone
                         style:style
                        target:target
                        action:@selector(barButtonItem_invoke:)];
}

- (void)setImageTop:(CGFloat)imageTop {
    UIEdgeInsets originalImageInsets = self.imageInsets;
    self.imageInsets = UIEdgeInsetsMake(imageTop, originalImageInsets.left, -imageTop, originalImageInsets.right);
}

- (void)setImageLeft:(CGFloat)imageLeft {
    UIEdgeInsets originalImageInsets = self.imageInsets;
    self.imageInsets = UIEdgeInsetsMake(originalImageInsets.top, imageLeft, originalImageInsets.bottom, -imageLeft);
}

@end

@implementation UIBarButtonItem (JCBadge)
@dynamic badgeColor;
@dynamic badgeTextColor;

- (UILabel *)badgeLabel {
    UILabel *_badgeLabel = objc_getAssociatedObject(self, _cmd);
    
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        objc_setAssociatedObject(self, _cmd, _badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self badgeLabelInit:_badgeLabel];
        [self.customView addSubview:_badgeLabel];
    }
    return _badgeLabel;
}

- (void)badgeLabelInit:(UILabel *)_badgeLabel {
    CGFloat defaultX = 0;
    UIView *superview = nil;
    if (self.customView) {
        superview = self.customView;
        superview.clipsToBounds = NO;
        defaultX = superview.frame.size.width - 10;
    }else if ([self respondsToSelector:@selector(view)] && [self valueForKey:@"view"]) {
        superview = [self valueForKey:@"view"];
        defaultX = superview.frame.size.width - 10;
    }
    _badgeLabel.frame = CGRectMake(defaultX, -4, 20, 20);
    _badgeLabel.font = [UIFont systemFontOfSize:12.0f];
    _badgeLabel.backgroundColor = [UIColor redColor];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.layer.cornerRadius = _badgeLabel.frame.size.height / 2;
    _badgeLabel.layer.masksToBounds = YES;
    [superview addSubview:_badgeLabel];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    UILabel *_badgeLabel = self.badgeLabel;
    _badgeLabel.text = badgeValue;
}

- (NSString *)badgeValue {
    return  self.badgeLabel.text;
}

- (void)setBadgeColor:(UIColor *)badgeColor {
    UILabel *_badgeLabel = self.badgeLabel;
    _badgeLabel.backgroundColor = [badgeColor copy];
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    UILabel *_badgeLabel = self.badgeLabel;
    _badgeLabel.textColor = [badgeTextColor copy];
}

- (void)setBadgeTextAttributes:(NSDictionary<NSString *,id> *)textAttributes {
    UILabel *_badgeLabel = self.badgeLabel;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_badgeLabel.text attributes:textAttributes];
    _badgeLabel.attributedText = attributedString;
}

@end
