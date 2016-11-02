//
//  NSFileManager+JCFileManager.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/10/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (JCFileManager)

/**
 根据文件路径获取文件的属性
 @param filePath 文件路径
 @return 文件属性
 */
+ (NSDictionary *)fileAttributesOfPath:(NSString *)filePath;

/**
 根据文件的路径获取文件的大小
 @return 文件大小
 */
+ (float)fileSizeOfPath:(NSString *)filePath;

/**
 删除指定目录
 @param folderPath 要删除的目录
 @return YES：删除成功  NO：删除失败
 */
+ (BOOL)deleteOfPath:(NSString *)path;

/**
 创建指定路径
 @param path 要创建的路径
 @return YES：创建成功   NO：创建失败
 */
+ (BOOL)createFolderOfPath:(NSString *)path;

/**
 创建指定文件路径和内容
 @param path 文件路径
 @param data 文件内容
 @return  YES：创建成功   NO：创建失败
 */
+ (BOOL)createFileOfPath:(NSString *)path data:(NSData *)data;

/**
 移动文件，从path移动到aimsPath
 @param path     原文件路径
 @param aimsPath 目的路径
 @return YES：移动成功   NO：移动失败
 */
+ (BOOL)movePath:(NSString *)path toAimsPath:(NSString *)aimsPath;

/**
 复制文件到指定路径
 @param path     要复制的文件路径
 @param aimsPath 目的路径
 @return YES：复制成功   NO：复制失败
 */
+ (BOOL)copyPath:(NSString *)path toAimsPath:(NSString *)aimsPath;

/**
 重命名文件
 @param path 要重命名的文件路径
 @param name 重命名
 @return YES：重命名成功   NO：重命名失败
 */
+ (BOOL)renamePath:(NSString *)path name:(NSString *)name;

@end
