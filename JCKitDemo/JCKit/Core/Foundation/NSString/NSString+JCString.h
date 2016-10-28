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

#pragma mark - 修剪字符串

/**
 去掉头尾的空格
 */
- (NSString *)stringByTrimSpace;

#pragma mark - 正则表达式

/**
 *  正则表达式
 *  @param format 正则表达式的样式
 *  @return YES or NO
 */
- (BOOL)evaluateWithFormat:(NSString *)format;

/**
 邮箱的正则表达式
 */
- (NSString *)regexpEmailFormat;

/**
 IP地址的正则表达式
 */
- (NSString *)regexpIpFormat;

/**
 HTTP链接 (例如 http://www.baidu.com )
 */
- (NSString *)regexpHTTPFormat;

#pragma mark - 沙盒路径

+ (NSString *)pathDocument;
+ (NSString *)pathCaches;
+ (NSString *)pathLibrary;

#pragma mark - UUID

+ (NSString *)stringWithUUID;

#pragma mark - ASCII码比较

/**
 根据每个字符的ASCII码总和相减来比较大小
 >0:self大; =0:相等(一样); <0:string大
 */
- (int)compareASCII:(NSString *)string;

/**
 字符串每个字符的ASCII码总和
 */
- (int)stringASCIISum;

#pragma mark - 字符串内容判断

/**
 是否包含某字符串
 @param contain 被包含的字符串
 @return NO：没包含 YES：包含
 */
- (BOOL)containOfString:(NSString *)contain;

/**
 判断是否是为整数
 */
- (BOOL)isPureInteger;

/**
 判断是否为浮点数，可做小数判断
 */
- (BOOL)isPureFloat;

/**
 判断字符串内是否含有中文
 */
- (BOOL)isChinese;

#pragma mark -  separate

/**
 从start处开始截取到end处结束，不包含start和end的字符串
 */
- (NSString *)separateStart:(NSString *)start end:(NSString *)end;

/**
 多次从start处开始截取到end处结束，不包含start和end的字符串
 @return 返回的是个数组
 */
- (NSArray *)multiSeparateStart:(NSString *)start end:(NSString *)end;

#pragma mark - reverse

/**
 反转字符串
 */
- (NSString *)reverseString;

#pragma mark - 拼音

/**
 汉字转换成拼音
 */
- (NSString *)trans;

/**
 阿拉伯数字转中文格式
 */
- (NSString *)translation;

#pragma mark - 格式化

/**
 设置NSNumber输出的格式
 @param style  格式
 @param number NSNumber数据
 */
+ (NSString *)stringFormatter:(NSNumberFormatterStyle)style number:(NSNumber *)number;

/**
 输出格式：123,456；每隔三个就有,
 */
+ (NSString *)stringFormatterWithDecimal:(NSNumber *)number;

/**
 number转换百分比： 12,345,600%
 */
+ (NSString *)stringFormatterWithPercent:(NSNumber *)number;

@end
