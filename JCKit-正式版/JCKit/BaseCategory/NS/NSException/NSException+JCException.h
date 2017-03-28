//
//  NSException+JCException.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (JCException)

/**
 堆栈数据
 */
- (NSArray *)callStackSymbols;

/**
 获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 */
- (NSString *)mainCallStackSymbolMessage;

@end
