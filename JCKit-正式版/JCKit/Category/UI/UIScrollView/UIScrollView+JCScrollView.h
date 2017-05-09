//
//  UIScrollView+JCScrollView.h
//
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (JCScrollView)

@property (nonatomic, assign, readonly) CGFloat contentHeight;

/**
 滚到顶点
 */
- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToTop;

/**
 滚到底边
 */
- (void)scrollToBottemAnimated:(BOOL)animated;
- (void)scrollToBottem;

/**
 滚到左边
 */
- (void)scrollToLeftAnimated:(BOOL)animated;
- (void)scrollToLeft;

/**
 滚到右边
 */
- (void)scrollToRightAnimated:(BOOL)animated;
- (void)scrollToRight;

@end
