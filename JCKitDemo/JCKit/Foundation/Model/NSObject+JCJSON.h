//
//  NSObject+JCJSON.h
//  JCKit
//
//  Created by molin on 16/3/21.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,JCAttributeType) {
    JCAttributeTypeUnknown     = 0,    // unknown
    JCAttributeTypeVoid        = 1,    // void
    JCAttributeTypeBOOL        = 2,    // BOOL
    JCAttributeTypeInt         = 3,    // int
    JCAttributeTypeInteger     = 4,    // NSInteger
    JCAttributeTypeFloat       = 5,    // float
    JCAttributeTypeDouble      = 6,    // double
    JCAttributeTypeChat        = 7,    // chat
    JCAttributeTypeObject      = 8,    // 对象
};

JCAttributeType JCGetObjectAttributeType(const char *attribute);


@interface NSObject (JCJSON)

/**
 *  创建模型
 *
 *  @param name JSON文件名
 *
 *  @return 模型对象
 */
+ (instancetype)modelWithJSONName:(NSString *)name;

/**
 *  创建模型
 *
 *  @param json JSON
 *
 *  @return 模型对象
 */
+ (instancetype)modelWithJSON:(id)json;

/**
 *  获取JSON的数据
 *
 *  @param name JSON文件名
 *
 *  @return NSData
 */
+ (NSData *)dataWithJSONName:(NSString *)name;

/**
 将属性集合成Dictionary
 */
- (NSDictionary *)togetherIntoDictionary;

+ (NSDictionary *)dictionaryWithJSONName:(NSString *)name;

@end
