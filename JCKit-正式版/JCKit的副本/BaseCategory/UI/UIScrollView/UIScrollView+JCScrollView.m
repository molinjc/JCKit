//
//  UIScrollView+JCScrollView.m
//
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIScrollView+JCScrollView.h"

@implementation UIScrollView (JCScrollView)

- (CGFloat)contentHeight {
    return self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;;
}

/**
 滚到顶点
 */
- (void)scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToTop {
    [self scrollToTopAnimated:YES];
}

/**
 滚到底边
 */
- (void)scrollToBottemAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:YES];
}

- (void)scrollToBottem {
    [self scrollToBottemAnimated:YES];
}

/**
 滚到左边
 */
- (void)scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToLeft {
    [self scrollToLeftAnimated:YES];
}

/**
 滚到右边
 */
- (void)scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToRight {
    [self scrollToRightAnimated:YES];
}

@end
