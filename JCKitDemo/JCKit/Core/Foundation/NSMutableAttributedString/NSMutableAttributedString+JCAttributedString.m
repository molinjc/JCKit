//
//  NSMutableAttributedString+JCAttributedString.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/13.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSMutableAttributedString+JCAttributedString.h"
#import "NSString+JCString.h"

static NSString *kNSFont           = @"NSFont";
static NSString *kNSParagraphStyle = @"NSParagraphStyle";

@implementation NSMutableAttributedString (JCAttributedString)

/**
 字体
 */
- (void)addFont:(UIFont *)font range:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:font range:range];
}

/**
 文本颜色
 */
- (void)addTextColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

/**
 段落样式
 */
- (void)addParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

/**
 下划线
 @param number 样式，值为NSNumber类型
 */
- (void)addUnderlineStyle:(NSNumber *)number range:(NSRange)range {
    [self addAttribute:NSUnderlineStyleAttributeName value:number range:range];
}

/**
 下划线颜色
 */
- (void)addUnderlineColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSUnderlineColorAttributeName value:color range:range];
}

/**
 链接
 @param address 链接地址
 */
- (void)addLinkAddress:(NSString *)address range:(NSRange)range {
    [self addAttribute:NSLinkAttributeName value:address range:range];
}

/**
 文本的背景颜色
 */
- (void)addBackgroundColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
}

/**
 计算文本大小
 */
- (CGFloat)widthForAttribute {
    return [self sizeForAttributeWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
}

- (CGFloat)heightForAttribute {
    return [self heightForAttributeWithWidth:MAXFLOAT];
}

- (CGFloat)heightForAttributeWithWidth:(CGFloat)width {
    return [self sizeForAttributeWithSize:CGSizeMake(width, MAXFLOAT)].height;
}

- (CGSize)sizeForAttributeWithSize:(CGSize)size {
    return [self sizeForAttributeWithSize:size mode:NSLineBreakByWordWrapping];
}

- (CGSize)sizeForAttributeWithSize:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    __block CGFloat width = 0;
    __block CGFloat height = 0;
    [self enumerateAttributesInRange:NSMakeRange(0, self.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *text = [self.string substringWithRange:range];
        UIFont *font = attrs[kNSFont];
        NSParagraphStyle *paragraphStyle = attrs[kNSParagraphStyle];
        CGSize textSize = [text sizeForFont:font size:size mode:lineBreakMode];
        if (paragraphStyle) {
            height += paragraphStyle.paragraphSpacing + paragraphStyle.paragraphSpacingBefore * 1.5 + paragraphStyle.lineSpacing;
        }
        width += textSize.width;
        height += textSize.height;
    }];
    return CGSizeMake(width, height);
}

@end
