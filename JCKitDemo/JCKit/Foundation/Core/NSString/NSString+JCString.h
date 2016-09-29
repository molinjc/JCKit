//
//  NSString+JCString.h
//  JCKitDemo
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (JCString)

#pragma mark - MD2、MD4、MD5加密

/**
 都是返回小写的字符串
 */
// ****************** 32位加密 *******************

- (NSString *)md2_32;
- (NSString *)md4_32;
- (NSString *)md5_32;

// ****************** 16位加密 *******************

- (NSString *)md2_16;
- (NSString *)md4_16;
- (NSString *)md5_16;

#pragma mark - SHA加密

/**
 都是返回小写的字符串
 */
- (NSString *)sha1;
- (NSString *)sha224;
- (NSString *)sha256;
- (NSString *)sha384;
- (NSString *)sha512;

#pragma mark - NSData

/**
 *  UTF8StringEncoding编码转换成Data
 */
- (NSData *)dataUsingUTF8StringEncoding;

#pragma mark - NSDate

/**
 *  获取当前的日期，格式为：yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)dateString;

/**
 *  @param format 时间显示的格式
 */
+ (NSString *)dateStringWithFormat:(NSString *)format;

#pragma mark - UI Size

/**
 根据字体大小计算文本的Size
 */
- (CGFloat)widthForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size;
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

#pragma mark - 正则表达式

/**
 *  正则表达式
 *  @param format 正则表达式的样式
 *  @return YES or NO
 */
- (BOOL)evaluateWithFormat:(NSString *)format;

#pragma mark - 沙盒路径

+ (NSString *)pathDocument;
+ (NSString *)pathCaches;
+ (NSString *)pathLibrary;

#pragma mark - 

+ (NSString *)stringWithUUID;

@end
