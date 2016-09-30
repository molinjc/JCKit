//
//  NSNumber+JCNumber.m
//  JCKitDemo
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

@end
