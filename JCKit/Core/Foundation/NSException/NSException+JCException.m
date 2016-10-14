//
//  NSException+JCException.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSException+JCException.h"

@implementation NSException (JCException)

/**
 堆栈数据
 */
- (NSArray *)callStackSymbols {
    return [NSThread callStackSymbols];
}

/**
 获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 */
- (NSString *)mainCallStackSymbolMessage {
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    NSString *callStackSymbolString = [self callStackSymbols][2];
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    [regularExp enumerateMatchesInString:callStackSymbolString options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbolString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result) {
            mainCallStackSymbolMsg = [callStackSymbolString substringWithRange:result.range];
            *stop = YES;
        }
    }];
    return mainCallStackSymbolMsg;
}

@end
