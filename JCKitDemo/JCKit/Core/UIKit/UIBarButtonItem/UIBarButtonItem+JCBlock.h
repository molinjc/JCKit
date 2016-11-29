//
//  UIBarButtonItem+JCBlock.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JCBlock)

/**
 UIBarButtonItem的事件回调
 */
@property (nonatomic, copy) void (^actionBlock)(id sender);

/**
 回调方式使用block
 下面简化初始方法
 */
- (instancetype)initWithImage:(UIImage *)image
                        style:(UIBarButtonItemStyle)style
                  actionBlock:(void (^)(id sender))actionBlock;

- (instancetype)initWithTitle:(NSString *)title
                        style:(UIBarButtonItemStyle)style
                  actionBlock:(void (^)(id sender))actionBlock;

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                                actionBlock:(void (^)(id sender))actionBlock;

- (instancetype)initWithImage:(UIImage *)image
          landscapeImagePhone:(UIImage *)landscapeImagePhone
                        style:(UIBarButtonItemStyle)style
                  actionBlock:(void (^)(id sender))actionBlock;

@end
