//
//  NSDictionary+JCBlock.h
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

- (NSInteger)integerForKey:(id)key;

- (int)intForKey:(id)key;

- (float)floatForKey:(id)key;

- (double)doubleForKey:(id)key;

- (BOOL)boolForKey:(id)key;

- (char)charForKey:(id)key;

- (CGFloat)CGFloatForKey:(id)key;

- (CGSize)CGSizeForKey:(id)key;

- (CGPoint)CGPointForKey:(id)key;

- (CGRect)CGRectForKey:(id)key;

- (NSString *)stringForKey:(id)key;

- (NSNumber *)numberForKey:(id)key;

- (NSArray *)arrayForKey:(id)key;

- (NSMutableArray *)mutableArrayForKey:(id)key;

- (NSDictionary *)dictionaryForKey:(id)key;

- (NSMutableDictionary *)mutableDictionaryForKey:(id)key;

/**
 两个字典合并
 */
- (NSDictionary *)merging:(NSDictionary *)dic;

@end

@interface NSMutableDictionary (JCBlock)


@end
