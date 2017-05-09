//
//  NSNumber+JCNumber.h
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (JCNumber)

/**
 根据字符串转换NSNumber
 */
+ (NSNumber *)numberWithString:(NSString *)string;

#pragma mark - 格式化

/**
 设置NSString转换的格式
 @param style  格式
 @param string string要按照格式来
 */
+ (NSNumber *)numberFormatter:(NSNumberFormatterStyle)style string:(NSString *)string;

/**
 输出格式：123,456；每隔三个就有,
 */
+ (NSNumber *)numberFormatterWithDecimal:(NSString *)string;

/**
 百分比： 12,345,600%
 */
+ (NSNumber *)numberFormatterWithPercent:(NSString *)string;

/**
 一万一千一百一十一这样的格式转换成number
 */
+ (NSNumber *)numberFormatterWithSpellOut:(NSString *)string;

@end
