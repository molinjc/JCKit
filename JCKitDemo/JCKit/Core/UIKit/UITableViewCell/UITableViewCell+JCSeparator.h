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
    JCSeparatorStyleLeftEmpty,    // 左边空出间距20
    JCSeparatorStyleRightEmpty,   // 右边空出间距20
    JCSeparatorStyleBothEmpty,    // 两边空出间距20
};

@interface UITableViewCell (JCSeparator)

// 分割线风格
@property (nonatomic, assign) JCSeparatorStyle cellSeparatorStyle;

@property (nonatomic, assign) CGFloat leftSpacing;

@property (nonatomic, assign) CGFloat rightSpacing;

@end
