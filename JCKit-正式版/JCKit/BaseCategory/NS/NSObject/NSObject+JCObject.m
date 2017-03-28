//
//  NSObject+JCObject.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSObject+JCObject.h"
#import <objc/runtime.h>

JCAttributeType JCGetObjectAttributeType(const char *attribute) {
    char *type = (char *)attribute;
    if (!type) {
        return JCAttributeTypeUnknown;
    }
    size_t len = strlen(type);
    if (len == 0) {
        return JCAttributeTypeUnknown;
    }
    JCAttributeType qualifier = 0;
    switch (*type) {
        case 'i':
            qualifier = JCAttributeTypeInt;
            break;
        case 'B':
            qualifier = JCAttributeTypeBOOL;
            break;
        case 'f':
            qualifier = JCAttributeTypeFloat;
            break;
        case 'd':
            qualifier = JCAttributeTypeDouble;
            break;
        case 'q':
            qualifier = JCAttributeTypeInteger;
            break;
        case '@':
            qualifier = JCAttributeTypeObject;
            break;
        case 'c':
            qualifier = JCAttributeTypeChat;
            break;
        default:
            break;
    }
    return qualifier;
}

@implementation NSObject (JCObject)

- (id)jc_performSelector:(SEL)sel {
    if ([self respondsToSelector:sel]) {
        // ???
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:sel];
#pragma clang diagnostic pop
    }
    
    NSAssert(nil, @"📍类与方法:%s,😱😱没有实现该方法☝️☝️ ",__func__);
    return nil;
}

- (NSArray *)allPropertys {
    unsigned int count;
    NSMutableArray *propertyArray = [NSMutableArray new];
    // 获取指向该类所有属性的指针
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    
    for (int i=0; i<count; i++) {
        
        // 获得该类的一个属性的指针
        objc_property_t property = propertys[i];
        
        // 获取属性的名称
        const char *name = property_getName(property);
        
        // 将C的字符串转为OC的
        NSString *key = [NSString stringWithUTF8String:name];
        
        objc_property_attribute_t *attributes =  property_copyAttributeList(property,  nil);
        objc_property_attribute_t attribute_t = attributes[0];
        NSString *attribute = [NSString stringWithUTF8String:attribute_t.value];
        
        [propertyArray addObject:@{@"key":key,@"attribute":attribute}];
        
        free(attributes);
    }
    free(propertys);
    return propertyArray;
}

/**
 获取该类下的所有子类
 */
- (NSArray *)allSubClasses {
    Class classObj = [self class];
    NSMutableArray *subClasses = [NSMutableArray new];
    unsigned int numOfClasses;
    Class *classes = objc_copyClassList(&numOfClasses);
    for (int i = 0; i < numOfClasses; i++) {
        Class superClass = classes[i];
        do {
            superClass = class_getSuperclass(superClass);
        } while (superClass && superClass != classObj);
        if (superClass) {
            [subClasses addObject:classes[i]];
        }
    }
    free(classes);
    return subClasses;
}

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

@end
