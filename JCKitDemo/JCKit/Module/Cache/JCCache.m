//
//  JCCache.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/30.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface _JCMemoryCache : NSCache

@end

@implementation _JCMemoryCache

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]
                                 addObserver:self
                                    selector:@selector(removeAllObjects)
                                        name:UIApplicationDidReceiveMemoryWarningNotification
                                      object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
                             removeObserver:self
                                       name:UIApplicationDidReceiveMemoryWarningNotification
                                     object:nil];
}

@end




@interface JCCache ()

@property (nonatomic, strong) _JCMemoryCache *memoryCache;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, copy)   NSString *diskCachePath;

@end

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1周

@implementation JCCache

#pragma mark - 初始化

+ (JCCache *)sharedCache {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    return [self initWithNamespace:@"Default"];
}

- (instancetype)initWithNamespace:(NSString *)namespace {
    if (self = [super init]) {
        _name = namespace;
        NSString *fullNamespace =  [NSString stringWithFormat:@"com.JCKit.JCCache.%@",namespace];
        _memoryCache = [[_JCMemoryCache alloc] init];
        _memoryCache.name = fullNamespace;
        _fileManager = [[NSFileManager alloc] init];
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        _diskCachePath = [self makeDiskCachePath:fullNamespace];
    }
    return self;
}

#pragma mark - 保存

/**
 保存到缓存
 @param object 对象
 @param data 对象转Data数据
 @param key key
 */
- (void)saveObject:(id)object data:(NSData *)data key:(NSString *)key {
    [self saveToMemoryCache:object key:key];
    [self saveToDiskCache:data key:key];
}

/**
 将数据保存到内存
 */
- (void)saveToMemoryCache:(id)object key:(NSString *)key {
    if (!object) {
        return;
    }
    [self.memoryCache setObject:object forKey:key];
}

/**
 将数据保存到沙盒
 */
- (void)saveToDiskCache:(NSData *)data key:(NSString *)key {
    if (!data) {
        return;
    }
    dispatch_async(dispatch_queue_create("com.JCKit.JCCache", DISPATCH_QUEUE_SERIAL), ^{
        if (![self.fileManager fileExistsAtPath:self.diskCachePath]) {
            [self.fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        NSString *cachePath = [self cachePathForKey:key];
        [self.fileManager createFileAtPath:cachePath contents:data attributes:nil];
    });
}

#pragma mark - 获取

/**
 从缓存中获取数据
 */
- (NSData *)dataFromCacheForKey:(NSString *)key {
    id data = [self objectFromMemoryCacheForKey:key];
    if (data) {
        return data;
    }
    data = [self diskDataBySearchingAllPathsForKey:key];
    if (data) {
        [self.memoryCache setObject:data forKey:key];
        return data;
    }
    return nil;
}

/**
 根据key获取内存缓存的对象
 */
- (id)objectFromMemoryCacheForKey:(NSString *)key {
    return [self.memoryCache objectForKey:key];
}

/**
 从磁盘获取数据
 */
- (NSData *)diskDataBySearchingAllPathsForKey:(NSString *)key {
    NSString *defaultPath = [self cachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data) {
        return data;
    }
    return nil;
}

#pragma mark - remove

- (void)removeFromCacheForKey:(NSString *)key {
    if (!key) {
        return;
    }
    
    [self.memoryCache removeObjectForKey:key];
    [self removeDiskDataFromCacheForKey:key];
}

- (void)removeDiskDataFromCacheForKey:(NSString *)key {
    dispatch_async(dispatch_queue_create("com.JCKit.JCCache", DISPATCH_QUEUE_SERIAL), ^{
        NSString *path = [self cachePathForKey:key];
        [self.fileManager removeItemAtPath:path error:nil];
    });
}

#pragma mark - Size

/**
 磁盘缓存大小
 */
- (NSUInteger)diskCacheSize {
    __block NSUInteger size = 0;
    dispatch_sync(dispatch_queue_create("com.JCKit.JCCache", DISPATCH_QUEUE_SERIAL), ^{
        NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtPath:self.diskCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

#pragma mark - 路径相关操作

/**
 获取磁盘路径
 @param path 后部分的路径名
 @return 完整路径
 */
- (NSString *)makeDiskCachePath:(NSString*)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:path];
}

/**
 缓存路径
 */
- (NSString *)cachePathForKey:(NSString *)key {
    NSString *filename = [self cachedFileNameForKey:key];
    return [self.diskCachePath stringByAppendingPathComponent:filename];
}

/**
 根据key转换成缓存文件名
 */
- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

#pragma mark - Set/Get

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost {
    self.memoryCache.totalCostLimit = maxMemoryCost;
}

- (NSUInteger)maxMemoryCost {
    return self.memoryCache.totalCostLimit;
}

- (void)setMaxMemoryCountLimit:(NSUInteger)maxMemoryCountLimit {
    self.memoryCache.countLimit = maxMemoryCountLimit;
}

- (NSUInteger)maxMemoryCountLimit {
    return self.memoryCache.countLimit;
}

@end

#if __has_include("UIImage+JCImage.h")
#import "UIImage+JCImage.h"
#endif

@implementation JCCache (UIImage)

NSUInteger JCCacheCostForImage(UIImage *image) {
    return image.size.height * image.size.width * image.scale * image.scale;
}

- (void)saveImage:(UIImage *)image key:(NSString *)key {
    if (!image || !key) {
        return;
    }
    [self.memoryCache setObject:image forKey:key cost:JCCacheCostForImage(image)];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    [self saveToDiskCache:data key:key];
}

- (UIImage *)imageFromCacheForKey:(NSString *)key {
    UIImage *image = [self objectFromMemoryCacheForKey:key];
    if (image) {
        return image;
    }
    NSData *data = [self diskDataBySearchingAllPathsForKey:key];
    if (data) {
        image = [UIImage imageWithData:data];
        [self.memoryCache setObject:image forKey:key];
        return image;
    }
    return nil;
}

#if __has_include("UIImage+JCImage.h")

- (UIImage *)imageGIFFromCacheForKey:(NSString *)key {
    UIImage *image = [self objectFromMemoryCacheForKey:key];
    if (image) {
        return image;
    }
    NSData *data = [self diskDataBySearchingAllPathsForKey:key];
    if (data) {
        image = [UIImage animatedGIFWithData:data];
        [self.memoryCache setObject:image forKey:key];
        return image;
    }
    return nil;
}

#endif

@end

@implementation JCCache (NSString)

- (void)saveString:(NSString *)string key:(NSString *)key {
    if (!string || !key) {
        return;
    }
    
    [self.memoryCache setObject:string forKey:key];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self saveToDiskCache:data key:key];
}

- (NSString *)stringFromCacheForKey:(NSString *)key {
    NSString *string = [self objectFromMemoryCacheForKey:key];
    if (string) {
        return string;
    }
    
    NSData *data = [self diskDataBySearchingAllPathsForKey:key];
    if (data) {
        string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.memoryCache setObject:string forKey:key];
    }
    return nil;
}

@end
