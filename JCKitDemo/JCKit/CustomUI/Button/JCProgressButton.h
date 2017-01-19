//
//  JCProgressButton.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/9.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCProgressButton;

@protocol JCProgressButtonDelegate <NSObject>

/// 点击了按钮
- (void)clickProgressButton:(JCProgressButton *)button;

/// 进度完成
- (void)completeWithProgressButton:(JCProgressButton *)button;

@end

@interface JCProgressButton : UIView

@property (nonatomic, weak) id<JCProgressButtonDelegate> delegate;

- (void)state;

@end
