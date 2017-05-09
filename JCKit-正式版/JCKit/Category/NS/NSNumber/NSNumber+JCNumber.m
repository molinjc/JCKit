//
//  NSNumber+JCNumber.m
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSNumber+JCNumber.h"
#import "NSString+JCString.h"

@implementation NSNumber (JCNumber)

/**
 根据字符串转换NSNumber
 */
+ (NSNumber *)numberWithString:(NSString *)string {
    NSString *str = [string stringByTrimSpace].lowercaseString;
    if (!str || !str.length) {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true"   : @(YES),
                @"yes"    : @(YES),
                @"false"  : @(NO),
                @"no"     : @(NO),
                @"nil"    : [NSNull null],
                @"null"   : [NSNull null],
                @"<null>" : [NSNull null],
                };
    });
    id num = dic[str];
    if (num) {
        if (num == [NSNull null]) {
            return nil;
        }
        return num;
    }
    return nil;
}

#pragma mark - 格式化

/**
 输出格式：123,456；每隔三个就有,
 */
+ (NSNumber *)numberFormatterWithDecimal:(NSString *)string {
    return [NSNumber numberFormatter:NSNumberFormatterDecimalStyle string:string];
}

/**
 百分比： 12,345,600%
 */
+ (NSNumber *)numberFormatterWithPercent:(NSString *)string {
    return [NSNumber numberFormatter:NSNumberFormatterPercentStyle string:string];
}

/**
 一万一千一百一十一这样的格式转换成number
 */
+ (NSNumber *)numberFormatterWithSpellOut:(NSString *)string {
    return [NSNumber numberFormatter:NSNumberFormatterSpellOutStyle string:string];
}

/**
 设置NSString转换的格式
 @param style  格式
 @param string string要按照格式来
 */
+ (NSNumber *)numberFormatter:(NSNumberFormatterStyle)style string:(NSString *)string {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle  = style;
    return [formatter numberFromString:string];
}

@end
