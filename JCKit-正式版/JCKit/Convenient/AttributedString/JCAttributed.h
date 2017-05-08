//
//  JCAttributed.h
//
//  Created by molin.JC on 2017/4/26.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCAttributed : NSObject
/** 根据字符串创建 */
- (instancetype)initWithString:(NSString *)string;
/** 根据JCAttributed创建 */
- (instancetype)initWithAttributed:(JCAttributed *)attributed;
/** 生成富文本设置的字典 */
- (NSDictionary *)attributedDictionary;

/** 富文本 */
@property (readonly) NSAttributedString *attributedString;
/** 所要修饰的字符串 */
@property (readonly, copy) NSString *string;
/** 字符串长度 */
@property (readonly) NSUInteger length;
/** 字体 */
@property (nonatomic) UIFont *font;
/** 字体颜色 */
@property (nonatomic) UIColor *textColor;
/** 段落样式 */
@property (nonatomic) NSParagraphStyle *paragraphStyle;
/** 下划线 */
@property (nonatomic) NSNumber *underlineStyle;
/** 下划线颜色 */
@property (nonatomic) UIColor *underlineColor;
/** 链接 */
@property (nonatomic) NSString *linkAddress;
/** 文本背景颜色 */
@property (nonatomic) UIColor *backgroundColor;
/** 字体阴影 */
@property (nonatomic) NSShadow *shadow;
/** 文件副本 */
- (void)setTextAttachment:(NSTextAttachment *)textAttachment;

/** 在最后追加Attributed */
- (void)appendAttributed:(JCAttributed *)attributed;
/** 在某位置上插入Attributed */
- (void)insertAttributed:(JCAttributed *)attributed atIndex:(NSUInteger)loc;
/** 替换某范围字符的富文本特性 */
- (void)replaceCharactersInRange:(NSRange)range withAttributed:(JCAttributed *)attributed;
/** 替换某范围的字符 */
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str;


@end
