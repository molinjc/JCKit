//
//  JCAuthorizationManager.h
//
//  Created by molin.JC on 2017/4/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 在info.plist里要设置权限说明
 Privacy - Photo Library Usage Description        -- 相册
 Privacy - Camera Usage Description               -- 相机
 Privacy - Contacts Usage Description             -- 通讯录
 Privacy - Calendars Usage Description            -- 日历
 Privacy - Reminders Usage Description            -- 提醒事项
 Privacy - Location Usage Description             -- 访问位置
 Privacy - Location Always Usage Description      -- 始终访问位置
 Privacy - Location When In Use Usage Description -- 使用期间访问位置
 Privacy - Media Library Usage Description        -- 媒体资料库
 Privacy - Microphone Usage Description           -- 麦克风
 Privacy - Speech Recognition Usage Description   -- 语音识别
 Privacy - Siri Usage Description                 -- 使用Siri助手
 Privacy - Bluetooth Peripheral Usage Description -- 蓝牙共享
 Privacy - Health Share Usage Description         -- 健康共享数据
 Privacy - Health Update Usage Description        -- 健康更新数据
 Privacy - Motion Usage Description               -- 活动与体能训练记录
 */

/**
 请求授权类型
 - JCAuthorizationTypeNetwork:               网络/Cellular Network
 - JCAuthorizationTypePhotoLibrary:          相册/PhotoLibrary
 - JCAuthorizationTypeVideo:                 相机/Camera
 - JCAuthorizationTypeAudio:                 麦克风/Audio
 - JCAuthorizationTypeNotification           远程推送/Notification
 - JCAuthorizationTypeAddressBook:           通讯录/AddressBook
 - JCAuthorizationTypeCalendar:              日历/Calendar
 - JCAuthorizationTypeReminder:              提醒事项/Reminder
 - JCAuthorizationTypeAppleMusic:            媒体资料库/AppleMusic
 - JCAuthorizationTypeSpeechRecognizer:      语音识别/SpeechRecognizer
 - JCAuthorizationTypeSiri:                  Siri(must in iOS10 or later)
 - JCAuthorizationTypeBluetooth:             蓝牙共享/Bluetooth
 - JCAuthorizationTypeMotionActivity:        活动与体能训练记录/MotionActivity
 - JCAuthorizationTypeAdvertisingIdentifier: 广告标识/AdvertisingIdentifier
 */
typedef NS_ENUM(NSUInteger, JCAuthorizationType) {
    JCAuthorizationTypeNetwork = 1,
    JCAuthorizationTypePhotoLibrary,
    JCAuthorizationTypeVideo,
    JCAuthorizationTypeAudio,
    JCAuthorizationTypeNotification,
    JCAuthorizationTypeAddressBook,
    JCAuthorizationTypeCalendar,
    JCAuthorizationTypeReminder,
    JCAuthorizationTypeAppleMusic,
    JCAuthorizationTypeSpeechRecognizer,
    JCAuthorizationTypeSiri,
    JCAuthorizationTypeBluetooth,
    JCAuthorizationTypeMotionActivity,
    JCAuthorizationTypeAdvertisingIdentifier,
};

/**
 请求分享授权类型
 - JCAuthorizationShareTypeTwitter:      推特/Twitter
 - JCAuthorizationShareTypeFacebook:     脸书/Facebook
 - JCAuthorizationShareTypeSinaWeibo:    新浪微博/SinaWeibo
 - JCAuthorizationShareTypeTencentWeibo: 腾讯微博/TencentWeibo
 */
typedef NS_ENUM(NSUInteger, JCAuthorizationShareType) {
    JCAuthorizationShareTypeTwitter,
    JCAuthorizationShareTypeFacebook,
    JCAuthorizationShareTypeSinaWeibo,
    JCAuthorizationShareTypeTencentWeibo,
};

/** 授权管理 */
@interface JCAuthorizationManager : NSObject

/**
 请求授权
 @param type 授权类型
 @param authorizedHandler 成功授权
 @param unAuthorizedHandler 不授权
 */
+ (void)requestAuthorizationWithType:(JCAuthorizationType)type authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 定位

/** 创建关于定位的授权管理, 由于定位用代理回调, 所以需要持有授权管理对象 */
+ (instancetype)authorizationManagerWithLocation;
/** 创建关于定位的授权管理 */
- (instancetype)initWithLocationManager;
/** 一直请求定位权限 */
- (void)requestLocationAlwaysWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;
/** 使用时请求定位权限 */
- (void)requestLocationWhenInUseWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - Network

+ (void)requestNetworkWithAuthorizedHandler:(void (^)())authorizedHandler unAuthorizedHandler:(void (^)())unAuthorizedHandler;

#pragma mark - 相册

+ (void)requestPhotoLibraryWithAuthorizedHandler:(void (^)())authorizedHandler unAuthorizedHandler:(void (^)())unAuthorizedHandler;

#pragma mark - 多媒体

/** 相机 */
+ (void)requestCameraAccessWithAuthorizedHandler:(void (^)())authorizedHandler unAuthorizedHandler:(void (^)())unAuthorizedHandler;

/** 麦克风 */
+ (void)requestAudioAccessWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 远程推送

/** 请求远程推送, options为UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound */
+ (void)requestNotificationWithAuthorizationHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

+ (void)requestNotificationWithOptions:(NSUInteger)options authorizationHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 通讯录

+ (void)requestAddressBookWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 日历

+ (void)requestCalendarWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 提醒事项

+ (void)requestReminderWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 媒体资料库

+ (void)requestAppleMusicWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 语音识别

+ (void)requestSpeechRecognizerWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - Siri

+ (void)requestSiriWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 蓝牙

+ (void)requestBluetoothWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 活动与体能训练记录

/** 活动与体能训练记录的授权, 由于CMMotionActivityManager只有成功的回调, 所以这里就没有失败的回调 */
+ (void)requestMotionWithAuthorizationHandler:(void(^)())authorizedHandler;

#pragma mark - 广告标识

+ (void)requestAdvertisingWithAuthorizationHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

#pragma mark - 分享

+ (void)requestShareWithAuthorizationShareType:(JCAuthorizationShareType)type options:(NSDictionary *)options authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler errorHandler:(void(^)(NSError *error))errorHandler;

#pragma mark - 健康(HealthKit)

#define _HKSampleTypeSet(...) [JCAuthorizationManager setWithSampleType:__VA_ARGS__, nil]
#define _HKObjectTypeSet(...) [JCAuthorizationManager setWithObjectType:__VA_ARGS__, nil]

/** 写入项 */
+ (NSSet *)setWithSampleType:(NSString *)identifier, ...;
/** 读取项 */
+ (NSSet *)setWithObjectType:(NSString *)identifier, ...;

/**
 健康授权
 @param typesToShare 要写入的哪些项
 @param typesToRead 要读取的哪些项
 */
+ (void)requestHealthAuthorizationWithShareTypes:(NSSet *)typesToShare readTypes:(NSSet *)typesToRead authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

/** 健康授权, 写入和读取是一样的 */
+ (void)requestHealthAuthorizationWithShareTypesAndReadTypes:(NSSet *)types authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler;

@end
