//
//  NSObject+JCBind.m
//  JCKit
//
//  Created by 林建川 on 16/8/13.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NSObject+JCBind.h"
#import "NSObject+JCObserverKVO.h"
#import <objc/runtime.h>

static void *const JCUnilateralBind = @"JCUnilateralBind";
static void *const JCBidirectionalBind = @"JCBidirectionalBind";

@implementation NSObject (JCBind)

#pragma mark - 单向绑定

/**
 *  自身的属性与其他对象的属性单向绑定，其他对象的属性变化，自身属性就变化；子身属性变化，其他对象的属性不变
 *
 *  @param property 自身的属性名
 *  @param obj      要与绑定的对象
 *  @param keyPath  与绑定的对象的属性名/属性路径
 */
- (void)selfProperty:(NSString *)property unilateralBindObject:(id)obj keyPath:(NSString *)keyPath {
    NSMutableDictionary *allTargetDic = objc_getAssociatedObject(self, JCUnilateralBind);
    if (!allTargetDic) {
        allTargetDic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, JCUnilateralBind, allTargetDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSDictionary *bindDic = allTargetDic[property];
    if (!bindDic || bindDic[@"obj"] != obj) {
        bindDic = @{@"obj":obj,@"keyPath":keyPath};
        allTargetDic[property] = bindDic;
        __weak typeof(self) weekSelf = self;
        [obj addKeyPath:keyPath change:^(id obj, id oldValue, id newValue) {
            id oldObj = bindDic[@"obj"];
            if (newValue && obj == oldObj) {
                [weekSelf setValue:newValue forKey:property];
            }
        }];
    }
}

/**
 *  清除所有单向绑定
 */
- (void)removeAllUnilateralBind {
    NSMutableDictionary *allTargetDic = objc_getAssociatedObject(self, JCUnilateralBind);
    if (!allTargetDic.count) {
        return;
    }
    [allTargetDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *dic, BOOL * _Nonnull stop) {
        id obj = dic[@"obj"];
        [obj removeObserverForKeyPath:dic[@"keyPath"]];
    }];
    [allTargetDic removeAllObjects];
}

/**
 *  清除指定的单向绑定
 *
 *  @param property 自身的属性名
 */
- (void)removeUnilateralBindForProperty:(NSString *)property {
    if (!property) {
        return;
    }
    NSMutableDictionary *allTargetDic = objc_getAssociatedObject(self, JCUnilateralBind);
    if (!allTargetDic) {
        return;
    }
    [self removeDictionary:allTargetDic fromProperty:property];
}

#pragma mark - 双向绑定

/**
 *  自身的属性与其他对象的属性双向绑定，其他对象的属性变化，自身属性就变化；子身属性变化，其他对象的属性也变化
 *
 *  @param property 自身的属性名
 *  @param obj      要与绑定的对象
 *  @param keyPath  与绑定的对象的属性名/属性路径
 */
- (void)selfProperty:(NSString *)property bidirectionalBindObject:(id)otherObj keyPath:(NSString *)keyPath {
    NSMutableDictionary *allTargetDic = objc_getAssociatedObject(self, JCBidirectionalBind);
    if (!allTargetDic) {
        allTargetDic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, JCBidirectionalBind, allTargetDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableDictionary *bindDic = allTargetDic[property];
    if (!bindDic || ![bindDic[keyPath] isEqualToString:keyPath]) {
        bindDic = [NSMutableDictionary new];
        bindDic[@"obj"] = otherObj;
        bindDic[@"keyPath"] = keyPath;
        allTargetDic[property] = bindDic;
        __weak typeof(self) weekSelf = self;
        [otherObj addKeyPath:keyPath change:^(id obj, id oldValue, id newValue) {
            id oldObj = bindDic[@"obj"];
            if (newValue && obj == oldObj) {
                NSString *mark = bindDic[@"change"];
                if ([mark isEqualToString:@"B-A"]) {
                    [bindDic removeObjectForKey:@"change"];
                }else {
                    bindDic[@"change"] = @"A-B";
                   [weekSelf setValue:newValue forKey:property];
                }
            }
        }];
        [self addKeyPath:property change:^(id obj, id oldValue, id newValue) {
            if (newValue && obj == self) {
                NSString *mark = bindDic[@"change"];
                if ([mark isEqualToString:@"A-B"]) {
                    [bindDic removeObjectForKey:@"change"];
                }else {
                    bindDic[@"change"] = @"B-A";
                    [otherObj setValue:newValue forKey:keyPath];
                }
            }
        }];
    }
}

/**
 *  清除所有双向绑定
 */
- (void)removeAllBidirectionalBind {
    NSMutableDictionary *allTargetDic = objc_getAssociatedObject(self, JCBidirectionalBind);
    if (!allTargetDic.count) {
        return;
    }
    [allTargetDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *dic, BOOL * _Nonnull stop) {
        id obj = dic[@"obj"];
        [obj removeObserverForKeyPath:dic[@"keyPath"]];
        [self removeObserverForKeyPath:key];
    }];
    [allTargetDic removeAllObjects];
}

/**
 *  清除指定的双向绑定
 *
 *  @param property 自身的属性名
 */
- (void)removeBidirectionalBindForProperty:(NSString *)property {
    if (!property) {
        return;
    }
    NSMutableDictionary *allTargetDic = objc_getAssociatedObject(self, JCBidirectionalBind);
    if (!allTargetDic) {
        return;
    }
    [self removeDictionary:allTargetDic fromProperty:property];
    [self removeObserverForKeyPath:property];
}

/**
 *  删除字典里的property键的值
 */
- (void)removeDictionary:(NSMutableDictionary *)allTargetDic fromProperty:(NSString *)property {
    NSDictionary *dic = allTargetDic[property];
    id obj = dic[@"obj"];
    [obj removeObserverForKeyPath:dic[@"keyPath"]];
    [allTargetDic removeObjectForKey:property];
}

@end
