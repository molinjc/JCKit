//
//  UIGestureRecognizer+JCBlock.h
//
//  Created by molin.JC on 2016/11/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JCGesture) {
    JCGesturePan,         /* 拖动手势 */
    JCGesturePinch,       /* 捏合手势 */
    JCGestureRotation,    /* 旋转手势 */
    JCGestureTap,         /* 点按手势 */
    JCGestureLongPress,   /* 长按手势 */
    JCGestureSwipe,       /* 轻扫手势 */
};

@interface UIGestureRecognizer (JCBlock)

/**
 根据枚举创建相应的手势
 @param gesture 手势枚举
 @return 手势对象
 */
+ (id)gestureRecognizer:(JCGesture)gesture;

+ (id)gestureRecognizerWithActionBlock:(void (^)(id sender))block;

- (id)initWithActionBlock:(void (^)(id))block;

/**
 添加一个事件的block
 @param block 手势发生调用的block
 */
- (void)addActionBlock:(void (^)(id))block;

/**
 删除所有的block
 */
- (void)removeAllActionBlocks;

@end
