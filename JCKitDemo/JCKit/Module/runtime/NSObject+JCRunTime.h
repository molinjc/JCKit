//
//  NSObject+JCRunTime.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/2/14.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JCRunTime)

/**
 修改属性的值
 @param property 属性名
 @param value 属性值
 */
- (void)changeProperty:(NSString *)property value:(id)value;

/**
 交换方法
 @param systemMethod 系统方法
 @param customMetod 自定义方法
 */
- (void)exchangeMethod:(SEL)systemMethod custom:(SEL)customMetod;

/**
 类方法交换
 @param cla 类的Class
 @param systemMethod 系统类方法
 @param customMetod 自定义类方法
 */
+ (void)exchangeClass:(Class)cla system:(SEL)systemMethod custom:(SEL)customMetod;

- (void)setAssociatedNonatomicRetainKey:(const void *)key value:(id)value;

- (void)setAssociatedNonatomicCopyKey:(const void *)key value:(id) value;

- (void)setAssociatedNonatomicAssigeKey:(const void *)key value:(id) value;

- (id)getAssociatedKey:(const void *)key;

@end
