//
//  UITextView+JCTextView.h
//
//  Created by molin.JC on 2016/12/21.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (JCTextView)

/**
 选中所有文字
 */
- (void)selectAllText;

/**
 当前选中的字符串范围
 */
- (NSRange)currentSelectedRange;

/**
 选中指定范围的文字
 */
- (void)setSelectedRange:(NSRange)range;

@end
