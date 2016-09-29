//
//  NSObject+JCJSON.h
//  JCKit
//
//  Created by molin on 16/3/21.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

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


+ (NSDictionary *)dictionaryWithJSONName:(NSString *)name;

@end
