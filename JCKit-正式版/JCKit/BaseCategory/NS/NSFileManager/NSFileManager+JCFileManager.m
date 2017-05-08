//
//  NSFileManager+JCFileManager.m
//
//  Created by molin.JC on 2016/10/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSFileManager+JCFileManager.h"

@implementation NSFileManager (JCFileManager)

+ (NSString *)homeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)documentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)libraryDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)preferencesDirectory {
    return [[self libraryDirectory] stringByAppendingPathComponent:@"Preferences"];
}

+ (NSString *)cachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)temporaryDirectory {
    return NSTemporaryDirectory();
}

- (BOOL)directoryExistsAtPath:(NSString *)path {
    if (!path) {
        return NO;
    }
    
    BOOL isDirectory = NO;
    BOOL exist = [self fileExistsAtPath:path isDirectory:&isDirectory];
    return isDirectory && exist;
}

+ (BOOL)directoryExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] directoryExistsAtPath:path];
}

+ (BOOL)isFileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/**
 根据文件路径获取文件的属性
 @param filePath 文件路径
 @return 文件属性
 */
+ (NSDictionary *)fileAttributesOfPath:(NSString *)filePath {
    return [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
}

/**
 根据文件的路径获取文件的大小
 @return 文件大小
 */
+ (float)fileSizeOfPath:(NSString *)filePath {
    return [[NSFileManager fileAttributesOfPath:filePath][NSFileSize] floatValue];
}

/**
 删除指定路径
 @param path 要删除的路径
 @return YES：删除成功  NO：删除失败
 */
+ (BOOL)deleteOfPath:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:path error:nil]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

/**
 创建指定路径
 @param path 要创建的路径
 @return YES：创建成功   NO：创建失败
 */
+ (BOOL)createFolderOfPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

/**
 创建指定文件路径和内容
 @param path 文件路径
 @param data 文件内容
 @return  YES：创建成功   NO：创建失败
 */
+ (BOOL)createFileOfPath:(NSString *)path data:(NSData *)data {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

/**
 移动文件，从path移动到aimsPath
 @param path     原文件路径
 @param aimsPath 目的路径
 @return YES：移动成功   NO：移动失败
 */
+ (BOOL)movePath:(NSString *)path toAimsPath:(NSString *)aimsPath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] moveItemAtPath:path toPath:aimsPath error:nil];
    }
    return NO;
}

/**
 复制文件到指定路径
 @param path     要复制的文件路径
 @param aimsPath 目的路径
 @return YES：复制成功   NO：复制失败
 */
+ (BOOL)copyPath:(NSString *)path toAimsPath:(NSString *)aimsPath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] copyItemAtPath:path toPath:aimsPath error:nil];
    }
    return NO;
}

/**
 重命名文件
 @param path 要重命名的文件路径
 @param name 重命名
 @return YES：重命名成功   NO：重命名失败
 */
+ (BOOL)renamePath:(NSString *)path name:(NSString *)name {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *aimsPath = [NSString stringWithFormat:@"%@/%@",[path stringByDeletingLastPathComponent],name];
        return [[NSFileManager defaultManager] moveItemAtPath:path toPath:aimsPath error:nil];
    }
    return NO;
}

@end
