//
//  JCCodedLockView.h
//  密码锁
//
//  Created by Molin on 15-6-27.
//  Copyright (c) 2015年 Molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCCodedLockView;

@protocol JCCodedLockViewDelegate <NSObject>

- (void)codedLockView:(JCCodedLockView *)codedLockView didFinishPath:(NSMutableString *)path;

@end

@interface JCCodedLockView : UIView

@property (nonatomic, strong) id<JCCodedLockViewDelegate> delegate;

@property (nonatomic, assign) CGFloat  btnW;

@property (nonatomic, assign) CGFloat  btnH;

- (id)initWithFrame:(CGRect)frame andWithButtonStateNormalImage:(UIImage *)image_1 orButtonStateSelectedImage:(UIImage *)image_2;


@end
