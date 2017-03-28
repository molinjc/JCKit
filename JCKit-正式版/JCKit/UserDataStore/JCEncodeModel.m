//
//  JCEncodeModel.m
//  JCRunTimeTest
//
//  Created by 林建川 on 16/7/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCEncodeModel.h"
#include <objc/runtime.h>

@interface JCEncodeModel ()
{
    NSMutableArray *_propertys;
}


@end

@implementation JCEncodeModel

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _propertys = [self allPropertys];
        
        for (NSDictionary *dic in _propertys) {
            NSString *key = dic[@"key"];
            if ([dic[@"attribute"] isEqualToString:@"q"] ) {    // NSInteger
                [self setValue:@([[decoder decodeObjectForKey:key] integerValue]) forKey:key];
            }else if ([dic[@"attribute"] isEqualToString:@"i"]) {  // int
                [self setValue:@([[decoder decodeObjectForKey:key] intValue]) forKey:key];
            }else if ([dic[@"attribute"] isEqualToString:@"f"]) {  // float
                [self setValue:@([[decoder decodeObjectForKey:key] floatValue]) forKey:key];
            }else if ([dic[@"attribute"] isEqualToString:@"d"]) {  // double
                [self setValue:@([[decoder decodeObjectForKey:key] doubleValue]) forKey:key];
            }else if ([dic[@"attribute"] isEqualToString:@"B"]) {  // BOOL
                [self setValue:@([[decoder decodeObjectForKey:key] boolValue]) forKey:key];
            }else {    // Obj
                [self setValue:[decoder decodeObjectForKey:key] forKey:key];
            }
        }
    }
    return self;
}

/** 归档，为存入前做准备 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (!_propertys) {
        _propertys = [self allPropertys];
    }
    for (NSDictionary *dic in _propertys) {
        NSString *key = dic[@"key"];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

/** 所有属性都清除 */
- (void)allClear {
    if (!_propertys) {
        _propertys = [self allPropertys];
    }
    for (NSDictionary *dic in _propertys) {
        NSString *key = dic[@"key"];
        if ([dic[@"attribute"] isEqualToString:@"q"] || [dic[@"attribute"] isEqualToString:@"i"] || [dic[@"attribute"] isEqualToString:@"f"] || [dic[@"attribute"] isEqualToString:@"d"]) {
            [self setValue:@(0) forKey:key];
        }else if ([dic[@"attribute"] isEqualToString:@"@\"NSString\""]) {    // Obj
            [self setValue:@"" forKey:key];
        }else {
            [self setNilValueForKey:key];
        }
    }
}

/** 获取属性 */
- (NSMutableArray *)allPropertys {
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

@end
