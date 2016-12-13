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
- (void)addFont:(UIFont *)font;

/**
 文本颜色
 */
- (void)addTextColor:(UIColor *)color range:(NSRange)range;
- (void)addTextColor:(UIColor *)color;

/**
 段落样式
 */
- (void)addParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range;
- (void)addParagraphStyle:(NSParagraphStyle *)paragraphStyle;

/**
 下划线颜色
 */
- (void)addUnderlineColor:(UIColor *)color range:(NSRange)range;
- (void)addUnderlineStyle:(NSNumber *)number;

/**
 下划线
 @param number 样式，值为NSNumber类型
 */
- (void)addUnderlineStyle:(NSNumber *)number range:(NSRange)range;
- (void)addUnderlineColor:(UIColor *)color;

/**
 链接
 @param address 链接地址
 */
- (void)addLinkAddress:(NSString *)address range:(NSRange)range;
- (void)addLinkAddress:(NSString *)address;

/**
 文本的背景颜色
 */
- (void)addBackgroundColor:(UIColor *)color range:(NSRange)range;
- (void)addBackgroundColor:(UIColor *)color;

/**
 字体阴影
 @param shadow 阴影
 */
- (void)addShadow:(NSShadow *)shadow range:(NSRange)range;
- (void)addShadow:(NSShadow *)shadow;

/**
 文件副本
 @param textAttachment 文件副本
 */
- (void)addTextAttachment:(NSTextAttachment *)textAttachment;

/**
 计算文本大小
 */
- (CGFloat)widthForAttribute;
- (CGFloat)heightForAttribute;
- (CGFloat)heightForAttributeWithWidth:(CGFloat)width;
- (CGSize)sizeForAttributeWithSize:(CGSize)size;
- (CGSize)sizeForAttributeWithSize:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

@end
