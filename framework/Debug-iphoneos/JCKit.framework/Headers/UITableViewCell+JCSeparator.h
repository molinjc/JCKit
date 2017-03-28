//
//  UITableViewCell+JCSeparator.h
//  JXCellSeparator
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JCSeparatorStyle) {
    JCSeparatorStyleNone = 0,     // 无分割线
    JCSeparatorStyleFull,         // 满行
    JCSeparatorStyleLeftEmpty,    // 左边空出间距, 默认20
    JCSeparatorStyleRightEmpty,   // 右边空出间距, 默认20
    JCSeparatorStyleBothEmpty,    // 两边空出间距, 默认20
};

@interface UITableViewCell (JCSeparator)

// 分割线风格
@property (nonatomic, assign) JCSeparatorStyle cellSeparatorStyle;

@property (nonatomic, assign) CGFloat leftSpacing;

@property (nonatomic, assign) CGFloat rightSpacing;

/**
 被选中是否反应, 对应selectionStyle，NO相当于UITableViewCellSelectionStyleNone
 */
@property (nonatomic, readwrite) BOOL selectionReaction;

@end
