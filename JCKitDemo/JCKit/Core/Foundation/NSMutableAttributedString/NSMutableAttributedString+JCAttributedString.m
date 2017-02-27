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

@implementation NSAttributedString (JCAttributedString)

/**
 加载HTML的代码
 */
+ (NSAttributedString *)attributedStringWithHTML:(NSString *)html {
    return [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                 documentAttributes:nil
                                              error:nil];
}

@end

@implementation NSMutableAttributedString (JCAttributedString)

static inline NSRange StringRange(NSMutableAttributedString *attributedString) {
    return NSMakeRange(0, attributedString.string.length);
}

/**
 字体
 */
- (void)addFont:(UIFont *)font range:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (void)addFont:(UIFont *)font {
    [self addFont:font range:StringRange(self)];
}

/**
 文本颜色
 */
- (void)addTextColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)addTextColor:(UIColor *)color {
    [self addTextColor:color range:StringRange(self)];
}

/**
 段落样式
 */
- (void)addParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

- (void)addParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    [self addParagraphStyle:paragraphStyle range:StringRange(self)];
}

/**
 下划线
 @param number 样式，值为NSNumber类型
 */
- (void)addUnderlineStyle:(NSNumber *)number range:(NSRange)range {
    [self addAttribute:NSUnderlineStyleAttributeName value:number range:range];
}

- (void)addUnderlineStyle:(NSNumber *)number {
    [self addUnderlineStyle:number range:StringRange(self)];
}

/**
 下划线颜色
 */
- (void)addUnderlineColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSUnderlineColorAttributeName value:color range:range];
}

- (void)addUnderlineColor:(UIColor *)color {
    [self addUnderlineColor:color range:StringRange(self)];
}

/**
 链接
 @param address 链接地址
 */
- (void)addLinkAddress:(NSString *)address range:(NSRange)range {
    [self addAttribute:NSLinkAttributeName value:address range:range];
}

- (void)addLinkAddress:(NSString *)address {
    [self addLinkAddress:address range:StringRange(self)];
}

/**
 文本的背景颜色
 */
- (void)addBackgroundColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
}

- (void)addBackgroundColor:(UIColor *)color {
    [self addBackgroundColor:color range:StringRange(self)];
}

/**
 字体阴影
 @param shadow 阴影
 */
- (void)addShadow:(NSShadow *)shadow range:(NSRange)range {
    [self addAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)addShadow:(NSShadow *)shadow {
    [self addShadow:shadow range:StringRange(self)];
}

/**
 文件副本
 @param textAttachment 文件副本
 */
- (void)addTextAttachment:(NSTextAttachment *)textAttachment {
    NSAttributedString *subAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [self appendAttributedString:subAttributedString];
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
