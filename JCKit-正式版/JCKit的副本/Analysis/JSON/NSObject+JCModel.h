//
//  NSObject+JCModel.h
//  JCMVPDemo
//
//  Created by molin.JC on 2017/4/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JCModel)

/**
 使用setValuesForKeysWithDictionary设置属性值
 @param json dic, data, string
 */
+ (instancetype)setValuesForKeysWithJSON:(id)json;

/** 根据JSON数据创建Model */
+ (instancetype)modelWithJSON:(id)json;

/** 将JSON数据解析成字典 */
+ (NSDictionary *)dictionaryWithJSON:(id)json;

/** 将字典的数据赋值给model的各个属性 */
- (void)modelSetWithDictionary:(NSDictionary *)dictionary;

@end

@protocol JCModel <NSObject>
@optional
/** model的字段关联 
  Example:
    json: {
         "n":"Harry Pottery",
         "p": 256,
         "ext" : {
            "desc" : "A book written by J.K.Rowing."
            }
         }
         
    model:
         interface JCBook
         @property NSString *name;
         @property NSInteger page;
         @property NSString *desc;
         @end
         
         implementation JCBook
         + (NSDictionary *)modelFieldRelation {
             return @{@"name" : @"n",
                      @"page" : @"p",
                      @"desc" : @"ext"};
         }
 @end
 */
+ (NSDictionary *)modelFieldRelation;

/** model的数组属性关联, 元素只有一种类型
 Example:
 + (NSDictionary *)modelArrayRelation {
      return @{@"users": [JCUser class], @"users1": [JCUser1 class]};
 }
 */
+ (NSDictionary *)modelArrayRelation;

/** model的数组属性关联, 元素有多种类型
 Example:
 + (Class)modelArrayMultiRelationForDictionary:(NSDictionary *)dic {
         if (dictionary[@"radius"] != nil) {
               return [JCCircle class];
         } else if (dictionary[@"width"] != nil) {
               return [JCRectangle class];
         } else if (dictionary[@"y2"] != nil) {
               return [JCLine class];
         } else {
               return nil;
         }
 }
 */
+ (Class)modelArrayMultiRelationForDictionary:(NSDictionary *)dic;

/** model的字典属性关联, 跟key获取对应的class
 Example:
 + (Class)modelDictionaryRelationForKey:(NSString *)key {
     if ([key isEqualToString:@"user"]) {
        return [JCUser class];
     }
     return nil;
 }
 */
+ (Class)modelDictionaryRelationForKey:(NSString *)key;

@end

@interface NSArray (JCModel)

+ (NSArray *)arrayWithModelClass:(Class)cls JSON:(id)json;

+ (NSArray *)arrayWithModelClass:(Class)cls array:(NSArray *)array;

@end

@interface NSDictionary (JCModel)

+ (NSDictionary *)dictionaryWithModelClass:(Class)cls JSON:(id)json;

+ (NSDictionary *)dictionaryWithModelClass:(Class)cls dictionary:(NSDictionary *)dic;

@end
