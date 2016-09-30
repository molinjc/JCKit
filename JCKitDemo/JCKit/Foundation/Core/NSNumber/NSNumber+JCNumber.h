//
//  NSNumber+JCNumber.h
//  JCKitDemo
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

@end
