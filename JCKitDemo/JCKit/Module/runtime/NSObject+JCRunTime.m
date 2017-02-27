//
//  NSObject+JCRunTime.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/2/14.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "NSObject+JCRunTime.h"
#import <objc/runtime.h>
@implementation NSObject (JCRunTime)

/**
 修改属性的值
 @param property 属性名
 @param value 属性值
 */
- (void)changeProperty:(NSString *)property value:(id)value {
    if (!property.length || property == nil) {
        return;
    }
    NSString *name = property;
    if (![property hasPrefix:@"_"]) {
        name = [NSString stringWithFormat:@"_%@", property];
    }
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        Ivar var = ivar[i];
        const char *varName = ivar_getName(var);
        NSString *proname = [NSString stringWithUTF8String:varName];
        
        if ([proname isEqualToString:name]) {   //这里别忘了给属性加下划线
            object_setIvar(self, var, value);
            break;
        }
    }
}

/**
 交换方法
 @param systemMethod 系统方法
 @param customMetod 自定义方法
 */
- (void)exchangeInstanceMethod:(SEL)systemMethod custom:(SEL)customMetod {
    Method sysMethod = class_getInstanceMethod([self class], systemMethod);
    Method cusMethod = class_getInstanceMethod([self class], customMetod);
    method_exchangeImplementations(sysMethod, cusMethod);
}

/**
 类方法交换
 @param cla 类的Class
 @param systemMethod 系统类方法
 @param customMetod 自定义类方法
 */
+ (void)exchangeClass:(Class)cla system:(SEL)systemMethod custom:(SEL)customMetod  {
    Method sysMethod = class_getClassMethod(cla, systemMethod);
    Method cusMethod = class_getClassMethod(cla, customMetod);
    method_exchangeImplementations(sysMethod, cusMethod);
}

/**
 添加方法
 @param selName 方法名
 @param imp 方法实现的C函数
 @param types 方法的类型（如：v@:）
 */
- (void)addMethod:(NSString *)selName IMP:(IMP)imp types:(const char *)types {
    class_addMethod([self class], NSSelectorFromString(selName), imp, types);
}

- (void)setAssociatedNonatomicRetainKey:(const void *)key value:(id)value {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssociatedNonatomicCopyKey:(const void *)key value:(id) value {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setAssociatedNonatomicAssigeKey:(const void *)key value:(id) value {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)getAssociatedKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

- (NSArray *)allProperty {
    unsigned int count;
    NSMutableArray *mArray = [NSMutableArray new];
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = propertys[i];
        [mArray addObject:(__bridge id _Nonnull)(property)];
    }
    free(propertys);
    return mArray.copy;
}

@end
