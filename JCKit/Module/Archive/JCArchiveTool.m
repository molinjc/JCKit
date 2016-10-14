//
//  JCArchiveTool.m
//  JCRunTimeTest
//
//  Created by 林建川 on 16/7/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCArchiveTool.h"
#include <objc/runtime.h>

@interface JCArchiveTool ()
{
    NSMutableArray *_propertys;
}
@end

@implementation JCArchiveTool

- (instancetype)init {
    if (self = [super init]) {
        
        _propertys = [self allPropertys];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        for (NSDictionary *dic in _propertys) {
            
            NSString *key = dic[@"key"];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",key]];
            
            if (![fileManager fileExistsAtPath:path]) {
                
                Class class = NSClassFromString(dic[@"attribute"]);
                [self setValue:[[class alloc] init] forKey:key];
                
            }else {
                [self setValue:[NSKeyedUnarchiver unarchiveObjectWithFile:path] forKey:key];
            }
        }
    }
    return self;
}

/**
 *  保存
 */
- (void)saveModel:(id)model key:(NSString *)key {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",key]];
    
    [self setValue:model forKey:key];
    [NSKeyedArchiver archiveRootObject:model toFile:path];
}

/**
 *  保存所有的
 */
- (void)saveAllModel {
    if (!_propertys) {
        _propertys = [self allPropertys];
    }
    for (NSDictionary *dic in _propertys) {
        
        NSString *key = dic[@"key"];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",key]];
        
        [NSKeyedArchiver archiveRootObject:[self valueForKey:key] toFile:path];
    }
}

/**
 *  清除所有
 */
- (void)clearAllModel {
    if (!_propertys) {
        _propertys = [self allPropertys];
    }
    for (NSDictionary *dic in _propertys) {
        
        NSString *key = dic[@"key"];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",key]];
        
        JCEncodeModel *model = [self valueForKey:key];
        [model allClear];
        [self setValue:model forKey:key];
        [NSKeyedArchiver archiveRootObject:model toFile:path];;
    }
}

/**
 *  获取属性
 */
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
        
        unsigned int count_att;
        
        objc_property_attribute_t *attributes =  property_copyAttributeList(property,  &count_att);
        objc_property_attribute_t attribute_t = attributes[0];
        NSString *attribute = [self updataString:[NSString stringWithUTF8String:attribute_t.value]];
        
        attribute_t = attributes[count_att - 1];
        NSString *attributeKey = [NSString stringWithUTF8String:attribute_t.value];
        
        [propertyArray addObject:@{@"key":key,@"attribute":attribute,@"attributeKey":attributeKey}];
        
        free(attributes);
    }
    free(propertys);
    return propertyArray;
}

/**
 *  更新属性的类型字符串
 */
- (NSString *)updataString:(NSString *)string {
    if (!string.length) {
        return @"";
    }
    NSRange range = NSMakeRange(2, string.length-3);
    return [string substringWithRange:range];
}

@end
