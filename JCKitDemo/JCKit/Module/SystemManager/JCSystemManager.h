//
//  JCSystemManager.h
//  XHVersionExample
//
//  Created by molin.JC on 2016/11/24.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCSystemManager : NSObject

/**
 检查版本
 @param block 回调值BOOL， NO:无新版本；YES:有新版本
 */
+ (void)inspectVersion:(void (^)(BOOL))block;

/**
 APP的版本与外部传进来的版本比较
 @param version 外部传进来的版本
 @return NO：APP的版本最大，也就是最新的版本  ; YES：外部版本比较大，有新版本
 */
+ (BOOL)compareWithExternalVersion:(NSString *)version;

/**
 APP的版本
 @return 字符串
 */
+ (NSString *)appVersionString;

@end

@interface JCSystemManager (JCAuthority)



@end

@interface JCAppInfo : NSObject

/**
 *  版本号
 */
@property(nonatomic, copy) NSString * version;

/**
 *  更新日志
 */
@property(nonatomic, copy) NSString *releaseNotes;

/**
 *  更新时间
 */
@property(nonatomic, copy) NSString *currentVersionReleaseDate;

/**
 *  APPId
 */
@property(nonatomic, copy) NSString *trackId;

/**
 *  bundleId
 */
@property(nonatomic, copy) NSString *bundleId;

/**
 *  AppStore地址
 */
@property(nonatomic, copy) NSString *trackViewUrl;

/**
 *  APP简介
 */
@property(nonatomic, copy) NSString *appDescription;

/**
 *  开发商
 */
@property(nonatomic, copy) NSString *sellerName;

/**
 *  文件大小
 */
@property(nonatomic, copy) NSString *fileSizeBytes;

/**
 *  展示图
 */
@property(nonatomic, strong) NSArray *screenshotUrls;

- (instancetype)initWithResult:(NSDictionary *)result;

@end
