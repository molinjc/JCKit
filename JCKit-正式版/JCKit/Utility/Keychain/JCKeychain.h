//
//  JCKeychain.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/4/11.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Keychain的信息是存在于每个应用（app）的沙盒之外的，所以keychain里保存的信息不会因App被删除而丢失，在用户重新安装App后依然有效，数据还在。
 SecItemAdd 增
 SecItemUpdate 改
 SecItemDelete 删
 SecItemCopyMatching 查
 */

/**
 可访问性
 - JCKeychainAttrAccessibleNone:
 - JCKeychainAttrAccessibleWhenUnlocked: 
                kSecAttrAccessibleWhenUnlocked， 解锁可访问，备份
 - JCKeychainAttrAccessibleAfterFirstUnlock: 
                kSecAttrAccessibleAfterFirstUnlock 第一次解锁后可访问，备份
 - JCKeychainAttrAccessibleAlways: 
                 kSecAttrAccessibleAlways, 一直可访问，备份
 - JCKeychainAttrAccessibleWhenUnlockedThisDeviceOnly: 
                 kSecAttrAccessibleWhenUnlockedThisDeviceOnly, 解锁可访问，不备份
 - JCKeychainAttrAccessibleAfterFirstUnlockThisDeviceOnly:                 
                 kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, 第一次解锁后可访问，不备份
 - JCKeychainAttrAccessibleAlwaysThisDeviceOnly: 
                 kSecAttrAccessibleAlwaysThisDeviceOnly, 一直可访问，不备份
 - JCKeychainAttrAccessibleWhenPasscodeSetThisDeviceOnly:
                 kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, 总是可以访问
 */
typedef NS_ENUM(NSUInteger, JCKeychainAttrAccessible) {
    JCKeychainAttrAccessibleNone = 0,
    JCKeychainAttrAccessibleWhenUnlocked,
    JCKeychainAttrAccessibleAfterFirstUnlock,
    JCKeychainAttrAccessibleAlways,
    JCKeychainAttrAccessibleWhenUnlockedThisDeviceOnly,
    JCKeychainAttrAccessibleAfterFirstUnlockThisDeviceOnly,
    JCKeychainAttrAccessibleAlwaysThisDeviceOnly,
    JCKeychainAttrAccessibleWhenPasscodeSetThisDeviceOnly
};

/**
 同步模式
 - JCKeychainQuerySynchronizationModeAny: 不关心同步
 - JCKeychainQuerySynchronizationModeNo: 不同步
 - JCKeychainQuerySynchronizationModeYes: 同步
 */
typedef NS_ENUM (NSUInteger, JCKeychainQuerySynchronizationMode) {
    JCKeychainQuerySynchronizationModeAny = 0,
    JCKeychainQuerySynchronizationModeNo,
    JCKeychainQuerySynchronizationModeYes,
};

static inline NSString * JCService(NSString *name) {
    return [NSString stringWithFormat:@"%@.%@", [NSBundle mainBundle].bundleIdentifier, name];
}

@interface JCKeychain : NSObject <NSCopying>

+ (NSArray <JCKeychain *> *)allAccounts;

+ (NSString *)getPasswordForService:(NSString *)serviceName account:(NSString *)account;

+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account;

+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account;

+ (JCKeychain *)keychainForService:(NSString *)serviceName account:(NSString *)account;

/** 增加 */
- (BOOL)insert;

/** 更新 */
- (BOOL)update;

/** 删除 */
- (BOOL)delete;

/** 查询一个 */
- (BOOL)select;

/** 查询多个 */
- (NSArray <JCKeychain *> *)selects;

/** 所具有服务 kSecAttrService */
@property (nonatomic, copy) NSString *service;

/** 账户名  kSecAttrAccount */
@property (nonatomic, copy) NSString *account;

/** 写入值 kSecValueData */
@property (nonatomic, copy) NSData *passwordData;

/** 所要存储的值，它会生成passwordData */
@property (nonatomic, copy) NSString *password;

/** 所要存储的对象，它会生成passwordData */
@property (nonatomic, copy) id <NSCoding> passwordObject;

/** 标签(给用户看) kSecAttrLabel */
@property (nonatomic, copy) NSString *label;

/** 类型 kSecAttrType (4字符，如'aLXY') */
@property (nonatomic, copy) NSNumber *type;

/** 创建者 kSecAttrCreator (4字符，如'aLXY') */
@property (nonatomic, copy) NSNumber *creater;

/** 注释 kSecAttrComment */
@property (nonatomic, copy) NSString *comment;

/** 描述 kSecAttrDescription */
@property (nonatomic, copy) NSString *descr;

/** 最后一次修改日期 kSecAttrModificationDate */
@property (nonatomic, copy) NSDate *modificationDate;

/** 创建日期 kSecAttrCreationDate */
@property (nonatomic, copy) NSDate *creationDate;

/** 访问组 kSecAttrAccessGroup */
@property (nonatomic, copy) NSString *accessGroup;

/** 可访问性 kSecAttrAccessible */
@property (nonatomic, assign) JCKeychainAttrAccessible accessible;

/** kSecAttrSynchronizable */
@property (nonatomic, assign) JCKeychainQuerySynchronizationMode synchronizable;

@end
