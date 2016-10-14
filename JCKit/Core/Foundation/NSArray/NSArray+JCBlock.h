//
//  NSArray+JCBlock.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JCBlock)

/**
 遍历每个元素
 */
- (void)each:(void (^)(id obj))block;

/**
 遍历每个元素，block有下标
 */
- (void)eachIndex:(void (^)(id obj, NSInteger index))block;

/**
 反序遍历每个元素
 */
- (void)reverseEach:(void (^)(id obj))block;

/**
 反序遍历每个元素，block有下标
 */
- (void)reverseEachIndex:(void (^)(id obj, NSInteger index))block;

/**
 选择YES时前几个的元素
 */
- (NSArray *)select:(BOOL (^)(id obj, NSInteger index))block;

@end

@interface NSMutableArray (JCBlock)

@end
