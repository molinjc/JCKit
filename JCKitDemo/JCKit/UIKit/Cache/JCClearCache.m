//
//  JCClearCache.m
//  56Customer
//
//  Created by 林建川 on 16/8/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCClearCache.h"

@implementation JCClearCache

#pragma mark - 获取沙盒Library/Caches的文件目录
+ (NSString *)getCachesDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  计算单个文件大小
 */
+ (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

/**
 *  计算目录大小
 */
+ (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            float fileSize = [JCClearCache fileSizeAtPath:absolutePath];
            folderSize = fileSize + folderSize;
        }
#if __has_include("SDImageCache.h")
#import "SDImageCache.h"
        //SDWebImage框架自身计算缓存的实现
        NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        folderSize = (float)imageCacheSize + folderSize;
#endif
        return folderSize;
    }
    return 0;
}

/**
 *  缓存大小
 */
+ (float)folderSize {
    return [JCClearCache folderSizeAtPath:[JCClearCache getCachesDirectory]];
}

/**
 *  清理缓存文件
 */
+ (void)clearCache {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *path = [JCClearCache getCachesDirectory];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
#if __has_include("SDImageCache.h")
    [[SDImageCache sharedImageCache] cleanDisk];
#endif
}

@end
