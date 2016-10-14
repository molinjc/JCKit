//
//  JCClearCache.h
//  56Customer
//
//  Created by 林建川 on 16/8/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCClearCache : NSObject

/**
 *  缓存大小
 */
+ (float)folderSize;

/**
 *  清理缓存文件
 */
+ (void)clearCache;

@end
