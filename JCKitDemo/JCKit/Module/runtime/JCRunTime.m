//
//  JCRunTime.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCRunTime.h"


@implementation JCRunTime

void setAssociatedNonatomicRetainObject(id object, const void *key, id value) {
    objc_setAssociatedObject(object, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

void setAssociatedNonatomicCopyObject(id object, const void *key, id value) {
    objc_setAssociatedObject(object, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

void setAssociatedNonatomicAssigeObject(id object, const void *key, id value) {
    objc_setAssociatedObject(object, key, value, OBJC_ASSOCIATION_ASSIGN);
}

id getAssociatedObject(id object, const void *key) {
    return objc_getAssociatedObject(object, key);
}

void propertyList(Class cla, void (^block)(objc_property_t property)) {
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList(cla, &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = propertys[i];
        if (block) {
            block(property);
        }
    }
    free(propertys);
}

NSArray<NSString *> * copyPropertyNameList(Class cla) {
    NSMutableArray *propertyArray = [NSMutableArray new];
    
    propertyList(cla, ^(objc_property_t property) {
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        [propertyArray addObject:key];
    });
    
    return propertyArray.mutableCopy;
}

void methodList(Class cla, void (^block)(Method method)) {
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cla, &count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        if (block) {
            block(method);
        }
    }
    free(methodList);
}

NSArray<NSString *> *copyMethodList(Class cla) {
    NSMutableArray *methodArray = [NSMutableArray new];
    methodList(cla, ^(Method method) {
        SEL methodName = method_getName(method);
        [methodArray addObject:NSStringFromSelector(methodName)];
    });
    return methodArray;
}

/**
 类方法的交换
 @param cla 要交换的类
 @param old 原来的类方法
 @param new 新的类方法
 */
void exchangeClassMethod(Class cla, SEL old, SEL new) {
    Method sysMethod = class_getClassMethod(cla, old);
    Method cusMethod = class_getClassMethod(cla, new);
    method_exchangeImplementations(sysMethod, cusMethod);
}

/**
 对象方法的交换
 @param cla 要交换的类
 @param old 原来的方法
 @param new 新的方法
 */
void exchangeInstanceMethod(Class cla, SEL old, SEL new) {
    Method sysIMethod = class_getInstanceMethod(cla, old);
    Method cusIMethod = class_getInstanceMethod(cla, new);
    method_exchangeImplementations(sysIMethod, cusIMethod);
}

@end
