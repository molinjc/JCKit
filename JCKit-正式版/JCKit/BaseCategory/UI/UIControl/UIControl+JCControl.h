//
//  UIControl+JCControl.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (JCControl)

/// 是否忽略点击事件,不响应点击事件
@property (nonatomic, weak, readonly) UIControl *(^buttonIgnoreEvent)(BOOL ignoreEvent);

/// 添加点击事件的间隔时间
@property (nonatomic, weak, readonly) UIControl *(^buttonAcceptEventInterval)(NSTimeInterval acceptEventInterval);

@end
