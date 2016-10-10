//
//  NSDictionary+JCBlock.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JCBlock)

/**
 遍历每个元素
 */
- (void)each:(void (^)(id key, id obj))block;

/**
 反序遍历每个元素
 */
- (void)reverseEach:(void (^)(id key, id obj))block;

/**
 选择条件满足前的元素
 */
- (NSDictionary *)select:(BOOL (^)(id key, id obj))block;

@end

@interface NSMutableDictionary (JCBlock)

@end
