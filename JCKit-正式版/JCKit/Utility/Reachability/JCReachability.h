//
//  JCReachability.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/4/10.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 网络状态
 - JCReachabilityStatusNone: 无网络
 - JCReachabilityStatusWWAN: WWAN (2G/3G/4G) 网络
 - JCReachabilityStatusNoneWIFI: WiFi 网络
 */
typedef NS_ENUM(NSUInteger, JCReachabilityStatus) {
    JCReachabilityStatusNone = 0,
    JCReachabilityStatusWWAN = 1,
    JCReachabilityStatusWIFI = 2,
};

/**
 运营商网络时的网络类型
 - JCReachabilityWWANStatusNone: 无网络类型
 - JCReachabilityWWANStatus2G: 2G网络(GPRS/EDGE) 10~100Kbps
 - JCReachabilityWWANStatus3G: 3G网络(WCDMA/HSDPA/...) 1~10Mbps
 - JCReachabilityWWANStatus4G: 4G网络(eHRPD/LTE) 100Mbps
 */
typedef NS_ENUM(NSUInteger, JCReachabilityWWANStatus) {
    JCReachabilityWWANStatusNone = 0,
    JCReachabilityWWANStatus2G,
    JCReachabilityWWANStatus3G,
    JCReachabilityWWANStatus4G,
};

@interface JCReachability : NSObject

/** 网络状态 */
@property (nonatomic, assign, readonly) JCReachabilityStatus status;

/** 手机运营商网络状态 */
@property (nonatomic, assign, readonly) JCReachabilityWWANStatus WWANStatus;

/** 用block回调 */
@property (nonatomic, copy) void (^notifyBlock)(JCReachability *reachability);

/** 是否有网络 */
@property (nonatomic, assign, readonly, getter=isReachable) BOOL reachable;

/** 无指定地址创建JCReachability */
+ (instancetype)reachability;

/** 指定本地WIFI地址创建JCReachability */
+ (instancetype)reachabilityForLocalWifi;

/**
 根据网址创建JCReachability
 @param url 网址 www.apple.com
 */
+ (instancetype)reachabilityWithURL:(NSString *)url;

/**
 根据IP地址创建JCReachability
 @param IP 192.168.0.1
 */
+ (instancetype)reachabilityWithIP:(NSString *)IP;

/** 添加一个通知名 */
- (void)addNotifyName:(NSString *)name;

/** 删除一个通知名 */
- (void)removeNotifyName:(NSString *)name;

@end
