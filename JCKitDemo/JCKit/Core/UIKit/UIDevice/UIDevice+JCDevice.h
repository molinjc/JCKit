//
//  UIDevice+JCDevice.h
//  JCKitDemo
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSystemVersion [UIDevice systemVersion]
#define iOS6Later (kSystemVersion >= 6)
#define iOS7Later (kSystemVersion >= 7)
#define iOS8Later (kSystemVersion >= 8)
#define iOS9Later (kSystemVersion >= 9)
#define iOS10Later (kSystemVersion >= 10)

@interface UIDevice (JCDevice)

/**
 是否是iPad设备
 */
@property (nonatomic, readonly) BOOL isPad;

/**
 是否是模拟器
 */
@property (nonatomic, readonly) BOOL isSimulator;

/**
 是否已经越狱
 */
@property (nonatomic, readonly) BOOL isJailbroken;

/**
 是否能打电话
 */
@property (nonatomic, readonly) BOOL canMakePhoneCalls;

/**
 获取设备号（如iPhone5,3、iPhone7,1...）
 */
@property (nonatomic, readonly) NSString *machineModel;

/**
 获取设备名（如iPhone6、iPhone6s...）
 */
@property (nonatomic, readonly) NSString *machineModelName;

/**
 系统启动时间
 */
@property (nonatomic, readonly) NSDate *systemUptime;

/**
 获取该设备的当前WIFI链接的IP地址
 @return @"192.168.1.111"/nil
 */
@property (nonatomic, readonly) NSString *ipAddressWIFI;

/**
 获取该设备手机网络的IP地址
 @return @"10.2.2.222"/nil
 */
@property (nonatomic, readonly) NSString *ipAddressCell;

#pragma mark - 磁盘空间

/**
 磁盘总空间
 */
@property (nonatomic, readonly) int64_t diskSpace;

/**
 空闲的磁盘空间
 */
@property (nonatomic, readonly) int64_t diskSpaceFree;

/**
 使用的磁盘空间
 */
@property (nonatomic, readonly) int64_t diskSpaceUsed;

#pragma mark - 内存信息

/**
 总内存
 */
@property (nonatomic, readonly) int64_t memoryTotal;

/**
 使用的内存
 */
@property (nonatomic, readonly) int64_t memoryUsed;

/**
 Free:表示这些[内存]中的数据是无效的，这些空间可以随时被程序使用
 */
@property (nonatomic, readonly) int64_t memoryFree;

/**
 Active:表示这些[内存]数据正在使用种，或者刚被使用过。
 */
@property (nonatomic, readonly) int64_t memoryActive;

/**
 Inactive:表示这些[内存]中的数据是有效的，但是最近没有被使用
 */
@property (nonatomic, readonly) int64_t memoryInactive;

/**
 Wired:系统核心占用的，永远不会从系统物理[内存]种驱除
 */
@property (nonatomic, readonly) int64_t memoryWired;

/**
 便携式存储器 ????
 */
@property (nonatomic, readonly) int64_t memoryPurgable;

/**
 系统版本
 */
+ (float)systemVersion;

/**
 将字节转换成k/M/G
 */
@property (nonatomic, weak, readonly) NSString *(^sizeString)(int64_t);

@end
