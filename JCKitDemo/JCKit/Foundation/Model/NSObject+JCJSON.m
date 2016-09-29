//
//  NSObject+JCJSON.m
//  JCKit
//
//  Created by molin on 16/3/21.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSObject+JCJSON.h"

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
    [model setValuesForKeysWithDictionary:dic];
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
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            dic = nil;
        }
    }
    Class className = [self class];
    NSObject *model = [className new];
    [model setValuesForKeysWithDictionary:dic]; // 系统的方法
    return model;
}

+ (NSData *)dataWithJSONName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    return [NSData dataWithContentsOfFile:path];
}

@end
