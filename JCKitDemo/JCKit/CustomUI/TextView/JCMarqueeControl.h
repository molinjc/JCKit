//
//  JCMarqueeControl.h
//  JC360
//
//  Created by molin on 16/4/18.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCMarqueeControl : UIView

@property (nonatomic, copy, nullable)          NSString        *text;// 文本

@property (null_resettable, nonatomic, strong) UIFont          *font;    // 字体

@property (null_resettable, nonatomic, strong) UIColor         *textColor;// 文本颜色

@property (nullable, nonatomic, strong)        UIColor         *shadowColor;

@property (nullable, nonatomic, copy)          NSAttributedString *attributedText NS_AVAILABLE_IOS(6_0            );

@property (nonatomic, assign)                 BOOL isMarquee;  // default is NO

@property (nonatomic, assign)                 NSInteger marqueeSpeed;

@end
