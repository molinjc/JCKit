//
//  JCPerson.m
//  JCRunTimeTest
//
//  Created by molin on 16/4/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCPerson.h"
#include <objc/runtime.h>
#import "NSObject+JCJSON.h"

@implementation JCPerson

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        unsigned int count;
        // 获取指向该类所有属性的指针
        objc_property_t *propertys = class_copyPropertyList([self class], &count);
        
        for (int i=0; i<count; i++) {
            
            // 获得该类的一个属性的指针
            objc_property_t property = propertys[i];
            
            // 获取属性的名称
            const char *name = property_getName(property);
            
            // 将C的字符串转为OC的
            NSString *key = [NSString stringWithUTF8String:name];
            
            // 获取属性
//            const char * attributes = property_getAttributes(property);
            
//            NSString *attributesKey = [NSString stringWithUTF8String:attributes];
            
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
        }
        free(propertys);

    }
    return self;
}

- (void)clearAccount {
    unsigned int count;
    // 获取指向该类所有属性的指针
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    
    for (int i=0; i<count; i++) {
        
        // 获得该类的一个属性的指针
        objc_property_t property = propertys[i];
        
        // 获取属性的名称
        const char *name = property_getName(property);
        
        // 将C的字符串转为OC的
        NSString *key = [NSString stringWithUTF8String:name];
        
        // 获取属性
//        const char * attributes = property_getAttributes(property);
        
//        NSString *attributesKey = [NSString stringWithUTF8String:attributes];
        
        [self setValue:@"" forKey:key];
    }
    free(propertys);
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count;
    // 获取指向该类所有属性的指针
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    
    for (int i=0; i<count; i++) {
        
        // 获得该类的一个属性的指针
        objc_property_t property = propertys[i];
        
        // 获取属性的名称
        const char *name = property_getName(property);
        
        // 将C的字符串转为OC的
        NSString *key = [NSString stringWithUTF8String:name];
        
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
        
//        [aCoder encodeObject:property forKey:key];
    }
    free(propertys);
}

- (void)eat {
    NSLog(@"吃饭");
}

- (void)sleep {
    NSLog(@"睡觉");
}

- (void)work {
    NSLog(@"工作");
}

- (NSDictionary *)modelPropertyGenericClass {
    return @{@"ppp":[JCPerson class]};
}
//
//- (void)setPpp:(JCPerson *)ppp {
//    if ([ppp isKindOfClass:[NSDictionary class]]) {
//        _ppp = [JCPerson modelWithJSON:ppp];
//    }
//}

@end
