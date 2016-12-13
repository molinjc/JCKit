//
//  NSMutableAttributedString+JCAttributedString.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/13.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (JCAttributedString)

/**
 字体
 */
- (void)addFont:(UIFont *)font range:(NSRange)range;

/**
 文本颜色
 */
- (void)addTextColor:(UIColor *)color range:(NSRange)range;

/**
 段落样式
 */
- (void)addParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range;

/**
 下划线颜色
 */
- (void)addUnderlineColor:(UIColor *)color range:(NSRange)range;

/**
 下划线
 @param number 样式，值为NSNumber类型
 */
- (void)addUnderlineStyle:(NSNumber *)number range:(NSRange)range;

/**
 链接
 @param address 链接地址
 */
- (void)addLinkAddress:(NSString *)address range:(NSRange)range;

/**
 文本的背景颜色
 */
- (void)addBackgroundColor:(UIColor *)color range:(NSRange)range;

/**
 计算文本大小
 */
- (CGFloat)widthForAttribute;
- (CGFloat)heightForAttribute;
- (CGFloat)heightForAttributeWithWidth:(CGFloat)width;
- (CGSize)sizeForAttributeWithSize:(CGSize)size;
- (CGSize)sizeForAttributeWithSize:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

@end
