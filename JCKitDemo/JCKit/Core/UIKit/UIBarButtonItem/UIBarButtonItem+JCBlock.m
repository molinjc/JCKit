//
//  UIBarButtonItem+JCBlock.m
//  JCKitDemo
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



@end
