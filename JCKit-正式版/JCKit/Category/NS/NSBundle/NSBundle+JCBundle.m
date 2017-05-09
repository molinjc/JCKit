//
//  NSBundle+JCBundle.m
//
//  Created by molin.JC on 2016/12/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSBundle+JCBundle.h"

@implementation NSBundle (JCBundle)

/**
 最小适配的系统版本
 */
- (NSString *)minimumOSVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MinimumOSVersion"];
}

/**
 项目名
 */
- (NSString *)bundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

/**
 Bundle Identifier
 */
- (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

/**
 项目版本号
 */
- (NSString *)bundleShortVersionString {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

/**
 项目的Icon文件
 */
- (NSString *)bundleIconFile {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"];
}

@end
