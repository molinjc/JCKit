//
//  NSObject+JCJSON.m
//  JCKit
//
//  Created by molin on 16/3/21.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSObject+JCJSON.h"
#import <objc/runtime.h>

@implementation NSObject (JCJSON)

+ (NSDictionary *)dictionaryWithJSONName:(NSString *)name {
    NSData *data = [self dataWithJSONName:name];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        dic = nil;
    }
    return dic;
}

+ (instancetype)modelWithJSONName:(NSString *)name {
    NSData *data = [self dataWithJSONName:name];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSAssert([dic isKindOfClass:[NSDictionary class]], @"📍行号:%d,📍类与方法:%s,📍不满足条件:解析出来的不是字典(Dictionary) ",__LINE__,__func__);
    Class className = [self class];
    NSObject *model = [className new];
    if (!model) {
        return nil;
    }
    [model setValuesForKeysWithDictionary:changeWrongfulValue(dic)];
    return model;
}

+ (instancetype)modelWithJSON:(id)json {
    if (!json || json == (id)kCFNull) {
        return nil;
    }
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    }else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            dic = nil;
        }
        
    }
    Class className = [self class];
    NSObject *model = [className new];
    [model setValuesForKeysWithDictionary:changeWrongfulValue(dic)]; // 系统的方法
//    [model changeValuesMethods:dic];
    return model;
}

+ (NSData *)dataWithJSONName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    return [NSData dataWithContentsOfFile:path];
}

/**
 将属性集合成Dictionary
 */
- (NSDictionary *)togetherIntoDictionary {
    NSMutableDictionary *dicM = [NSMutableDictionary new];
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
        if (value) {
            dicM[key] = value;
        }
    }
    free(propertys);
    return dicM;
}

/**
 用KVC赋值，遇到NSNull的给@""值
 *
 *  @param dictionary <#dictionary description#>
 */
- (void)changeValuesMethods:(NSDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL * _Nonnull stop) {
        if (value) {
            if ([value isKindOfClass:[NSNull class]]) {
                [self setValue:@"" forKey:key];
            }else {
                [self setValue:value forKey:key];
            }
        }
    }];
}


static inline NSDictionary * changeWrongfulValue(NSDictionary *dic) {
    if (!dic) return nil;
    
    static NSDictionary *legalDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        legalDic = @{@"TRUE" :   @(YES),
                     @"TRUE" :   @(YES),
                     @"True" :   @(YES),
                     @"true" :   @(YES),
                     @"FALSE" :  @(NO),
                     @"False" :  @(NO),
                     @"false" :  @(NO),
                     @"YES" :    @(YES),
                     @"Yes" :    @(YES),
                     @"yes" :    @(YES),
                     @"NO" :     @(NO),
                     @"No" :     @(NO),
                     @"no" :     @(NO),
                     @"NIL" :    (id)kCFNull,
                     @"Nil" :    (id)kCFNull,
                     @"nil" :    (id)kCFNull,
                     @"NULL" :   (id)kCFNull,
                     @"Null" :   (id)kCFNull,
                     @"null" :   (id)kCFNull,
                     @"(NULL)" : (id)kCFNull,
                     @"(Null)" : (id)kCFNull,
                     @"(null)" : (id)kCFNull,
                     @"<NULL>" : (id)kCFNull,
                     @"<Null>" : (id)kCFNull,
                     @"<null>" : (id)kCFNull
                     };
    });
    
    NSMutableDictionary *dicM = [NSMutableDictionary new];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id legalValue = legalDic[[NSString stringWithFormat:@"%@",obj]];
        if (legalValue) {
            dicM[key] = legalValue;
        }else {
            dicM[key] = obj;
        }
    }];
    return dicM;
}

@end

