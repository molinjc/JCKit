//
//  NSBundle+JCBundle.h
//
//  Created by molin.JC on 2016/12/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (JCBundle)

/**
 最小适配的系统版本
 */
- (NSString *)minimumOSVersion;

/**
 项目名
 */
- (NSString *)bundleName;

/**
 Bundle Identifier
 */
- (NSString *)bundleIdentifier;

/**
 项目版本号
 */
- (NSString *)bundleShortVersionString;

/**
 项目的Icon文件
 */
- (NSString *)bundleIconFile;

@end
