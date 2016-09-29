//
//  NSObject+JCBind.h
//  JCKit
//
//  Created by 林建川 on 16/8/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <Foundation/Foundation.h>

// 单向绑定
#define BIND(obj1, property, obj2, key) [obj1 selfProperty:@#property unilateralBindObject:obj2 keyPath:@#key];
// 双向绑定
#define BINDBOTH(obj1, property, obj2, key) [obj1 selfProperty:@#property bidirectionalBindObject:obj2 keyPath:@#key]

@interface NSObject (JCBind)

#pragma mark - 单向绑定

/**
 *  自身的属性与其他对象的属性单向绑定，其他对象的属性变化，自身属性就变化；子身属性变化，其他对象的属性不变
 *
 *  @param property 自身的属性名
 *  @param obj      要与绑定的对象
 *  @param keyPath  与绑定的对象的属性名/属性路径
 */
- (void)selfProperty:(NSString *)property unilateralBindObject:(id)obj keyPath:(NSString *)keyPath;

/**
 *  清除所有单向绑定
 */
- (void)removeAllUnilateralBind;

/**
 *  清除指定的单向绑定
 *
 *  @param property 自身的属性名
 */
- (void)removeUnilateralBindForProperty:(NSString *)property;

#pragma mark - 双向绑定

/**
 *  自身的属性与其他对象的属性双向绑定，其他对象的属性变化，自身属性就变化；子身属性变化，其他对象的属性也变化
 *
 *  @param property 自身的属性名
 *  @param obj      要与绑定的对象
 *  @param keyPath  与绑定的对象的属性名/属性路径
 */
- (void)selfProperty:(NSString *)property bidirectionalBindObject:(id)obj keyPath:(NSString *)keyPath;

/**
 *  清除所有双向绑定
 */
- (void)removeAllBidirectionalBind;

/**
 *  清除指定的双向绑定
 *
 *  @param property 自身的属性名
 */
- (void)removeBidirectionalBindForProperty:(NSString *)property;

@end
