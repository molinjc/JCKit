//
//  NSObject+JCCopy.m
//  JCMVPDemo
//
//  Created by molin.JC on 2017/4/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UIView+JCCopy.h"
#import <objc/runtime.h>

@implementation NSObject (JCCopy)

- (instancetype)copyObject {
    return [self copyObjectWithKeys:self.allPropertys];
}

- (instancetype)copyObjectWithKeys:(NSArray <NSString *> *)keys {
    id obj = [[self class] new];
    
    for (NSString *key in keys) {
        @try {
            id value = [self valueForKey:key];
            if (value) {
                [obj setValue:value forKey:key];
            }
        } @catch (NSException *exception) {
            
        }
    }
    return obj;
}

/** 获取属性 */
- (NSArray *)allPropertys {
    unsigned int count;
    NSMutableArray *propertyArray = [NSMutableArray new];
    
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    
    for (int i=0; i<count; i++) {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        [propertyArray addObject:key];
    }
    free(propertys);
    return propertyArray.mutableCopy;
}

@end

/**
 实现分类
 @param class 类名(不要带前缀)
 @param ... 要复制的属性名
 */
#define _CopyObject_M(class, ...) _CopyObject_M_Prefix(UI, class, __VA_ARGS__)

#define _CopyObject_M_Prefix(prefix, class, ...)   \
@implementation prefix ## class (JCCopy)           \
- (instancetype)copy ## class {                    \
return [self copyObjectWithKeys:@[__VA_ARGS__]];   \
}                                                  \
@end


_CopyObject_M(View, @"backgroundColor", @"alpha")
_CopyObject_M(ImageView, @"backgroundColor", @"alpha", @"image")
_CopyObject_M(Label, @"backgroundColor", @"alpha", @"textColor", @"font", @"textAlignment", @"numberOfLines", @"attributedText", @"highlightedTextColor")
