//
//  JCCache.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/30.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCCache : NSObject

/**
 最大的内存成本
 */
@property (nonatomic, assign) NSUInteger maxMemoryCost;

/**
 缓存最大的个数
 */
@property (nonatomic, assign) NSUInteger maxMemoryCountLimit;

/**
 最大时间长度
 */
@property (nonatomic, assign) NSInteger maxCacheAge;

/**
 缓存最大的大小
 */
@property (nonatomic, assign) NSUInteger maxCacheSize;

+ (JCCache *)sharedCache;

#pragma mark - 保存

/**
 保存到缓存
 @param object 对象
 @param data 对象转Data数据
 @param key key
 */
- (void)saveObject:(id)object data:(NSData *)data key:(NSString *)key;

/**
 将数据保存到内存
 */
- (void)saveToMemoryCache:(id)object key:(NSString *)key;

/**
 将数据保存到沙盒
 */
- (void)saveToDiskCache:(NSData *)data key:(NSString *)key;

#pragma mark - 获取

/**
 从缓存中获取数据
 */
- (NSData *)dataFromCacheForKey:(NSString *)key;

/**
 根据key获取内存缓存的对象
 */
- (id)objectFromMemoryCacheForKey:(NSString *)key;

/**
 从磁盘获取数据
 */
- (NSData *)diskDataBySearchingAllPathsForKey:(NSString *)key;

@end

@interface JCCache (UIImage)

- (void)saveImage:(UIImage *)image key:(NSString *)key;

- (UIImage *)imageFromCacheForKey:(NSString *)key;

#if __has_include("UIImage+JCImage.h")
- (UIImage *)imageGIFFromCacheForKey:(NSString *)key;
#endif

@end

@interface JCCache (NSString)

- (void)saveString:(NSString *)string key:(NSString *)key;

- (NSString *)stringFromCacheForKey:(NSString *)key;

@end
