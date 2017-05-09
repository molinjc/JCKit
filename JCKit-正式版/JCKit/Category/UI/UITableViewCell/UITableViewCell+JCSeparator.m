//
//  UITableViewCell+JCSeparator.m
//  JXCellSeparator
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "UITableViewCell+JCSeparator.h"
#import <objc/runtime.h>

@implementation UITableViewCell (JCSeparator)
@dynamic selectionReaction;

- (JCSeparatorStyle)cellSeparatorStyle {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number integerValue] : 0;
}

- (void)setCellSeparatorStyle:(JCSeparatorStyle)cellSeparatorStyle {
    objc_setAssociatedObject(self, @selector(cellSeparatorStyle), @(cellSeparatorStyle), OBJC_ASSOCIATION_ASSIGN);
    // 设置分割线
    if ([[UIDevice currentDevice].systemVersion compare:@"8.0"] != NSOrderedAscending) {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
    self.separatorInset =  UIEdgeInsetsZero;
    switch (cellSeparatorStyle) {
        case JCSeparatorStyleNone: {
            self.separatorInset = UIEdgeInsetsMake(0, 0, 0, [UIScreen mainScreen].bounds.size.width);
            break;
        }
        case JCSeparatorStyleFull: {
            self.separatorInset = UIEdgeInsetsZero;
            break;
        }
        case JCSeparatorStyleLeftEmpty: {
            self.separatorInset = UIEdgeInsetsMake(0, self.leftSpacing, 0, 0);
            break;
        }
        case JCSeparatorStyleRightEmpty: {
            self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.rightSpacing);
            break;
        }
        case JCSeparatorStyleBothEmpty: {
            self.separatorInset = UIEdgeInsetsMake(0, self.leftSpacing, 0, self.rightSpacing);
            break;
        }
    }
}

- (CGFloat)leftSpacing {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number floatValue] : 20.0;
}

- (void)setLeftSpacing:(CGFloat)leftSpacing {
    objc_setAssociatedObject(self, @selector(leftSpacing), @(leftSpacing), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)rightSpacing {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number floatValue] : 20.0;
}

- (void)setRightSpacing:(CGFloat)rightSpacing {
    objc_setAssociatedObject(self, @selector(rightSpacing), @(rightSpacing), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setSelectionReaction:(BOOL)selectionReaction {
    if (!selectionReaction) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

@end
