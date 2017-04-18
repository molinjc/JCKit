//
//  JCKeychain.m
//  JCViewLayout
//
//  Created by molin.JC on 2017/4/11.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCKeychain.h"
#import <security/Security.h>

static NSString * JCKeychainAttrAccessibleString(JCKeychainAttrAccessible accessible) {
    switch (accessible) {
        case JCKeychainAttrAccessibleWhenUnlocked:
            return (__bridge NSString *)(kSecAttrAccessibleWhenUnlocked);
        case JCKeychainAttrAccessibleAfterFirstUnlock:
            return (__bridge NSString *)(kSecAttrAccessibleAfterFirstUnlock);
        case JCKeychainAttrAccessibleAlways:
            return (__bridge NSString *)(kSecAttrAccessibleAlways);
        case JCKeychainAttrAccessibleWhenPasscodeSetThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly);
        case JCKeychainAttrAccessibleWhenUnlockedThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleWhenUnlockedThisDeviceOnly);
        case JCKeychainAttrAccessibleAfterFirstUnlockThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly);
        case JCKeychainAttrAccessibleAlwaysThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleAlwaysThisDeviceOnly);
        default:
            return nil;
    }
}

static JCKeychainAttrAccessible JCKeychainAttrAccessibleEnum(NSString *s) {
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlocked])
        return JCKeychainAttrAccessibleWhenUnlocked;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlock])
        return JCKeychainAttrAccessibleAfterFirstUnlock;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlways])
        return JCKeychainAttrAccessibleAlways;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly])
        return JCKeychainAttrAccessibleWhenPasscodeSetThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlockedThisDeviceOnly])
        return JCKeychainAttrAccessibleWhenUnlockedThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly])
        return JCKeychainAttrAccessibleAfterFirstUnlockThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlwaysThisDeviceOnly])
        return JCKeychainAttrAccessibleAlwaysThisDeviceOnly;
    return JCKeychainAttrAccessibleNone;
}

static id JCKeychainQuerySynchonizationID(JCKeychainQuerySynchronizationMode mode) {
    switch (mode) {
        case JCKeychainQuerySynchronizationModeAny:
            return (__bridge id)(kSecAttrSynchronizableAny);
        case JCKeychainQuerySynchronizationModeNo:
            return @(NO);
        case JCKeychainQuerySynchronizationModeYes:
            return @(YES);
        default:
            return (__bridge id)(kSecAttrSynchronizableAny);
    }
}

static JCKeychainQuerySynchronizationMode JCKeychainQuerySynchonizationEnum(NSNumber *num) {
    if ([num isEqualToNumber:@NO]) return JCKeychainQuerySynchronizationModeNo;
    if ([num isEqualToNumber:@YES]) return JCKeychainQuerySynchronizationModeYes;
    return JCKeychainQuerySynchronizationModeAny;
}

@implementation JCKeychain

+ (NSArray <JCKeychain *> *)allAccounts {
    JCKeychain *item = [JCKeychain new];
    return [item selects];
}

+ (NSString *)getPasswordForService:(NSString *)serviceName account:(NSString *)account {
    JCKeychain *item = [JCKeychain keychainForService:serviceName account:account];
    if (!item) {
        return nil;
    }
    return item.password;
}

+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
    if (!serviceName || !account) {
        return NO;
    }
    
    JCKeychain *item = [JCKeychain new];
    item.service = serviceName;
    item.account = account;
    return [item delete];
}

+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account {
    if (!password || !serviceName || !account) {
        return NO;
    }
    
    JCKeychain *item = [JCKeychain keychainForService:serviceName account:account];
    if (item.password) {
        item.password = password;
        return [item update];
    }else {
        return [item insert];
    }
}

+ (JCKeychain *)keychainForService:(NSString *)serviceName account:(NSString *)account {
    if (!serviceName || !account) {
        return nil;
    }
    JCKeychain *item = [JCKeychain new];
    item.service = serviceName;
    item.account = account;
    [item select];
    return item;
}

- (BOOL)insert {
    NSMutableDictionary *attrs = [self attrs];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)attrs, NULL);
    return status == errSecSuccess;
}

- (BOOL)update {
    NSMutableDictionary *attrs = [self queryAttrs];
    NSMutableDictionary *update = [self attrs];
    if (!attrs || !update) {
        return NO;
    }
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)attrs, (__bridge CFDictionaryRef)update);
    return status == errSecSuccess;
}

- (BOOL)delete {
    NSMutableDictionary *attrs = [self attrs];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)attrs);
    return status == errSecSuccess;
}

- (BOOL)select {
    NSMutableDictionary *attrs = [self attrs];
    attrs[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    attrs[(__bridge id)kSecReturnAttributes] = @YES;
    attrs[(__bridge id)kSecReturnData] = @YES;
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)attrs, &result);
    
    if (status != errSecSuccess) {
        return NO;
    }
    
    NSDictionary *dic = (__bridge NSDictionary *)(result);
    if (dic) {
        [self setValueWithAttrs:dic];
        return YES;
    }
    return NO;
}

- (NSArray <JCKeychain *> *)selects {
    NSMutableDictionary *attrs = [self attrs];
    attrs[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    attrs[(__bridge id)kSecReturnAttributes] = @YES;
    attrs[(__bridge id)kSecReturnData] = @YES;
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)attrs, &result);
    
    if (status != errSecSuccess) {
        return nil;
    }
    
    NSMutableArray *res = [NSMutableArray new];
    NSArray *arr = (__bridge NSArray *)(result);
    for (NSDictionary *dic in arr) {
        JCKeychain *item = [[JCKeychain alloc] initWithAttrs:dic];
        if (item) {
            [res addObject:item];
        }
    }
    return res;
}

- (instancetype)initWithAttrs:(NSDictionary *)attrs {
    if (self = [self init]) {
        [self setValueWithAttrs:attrs];
    }
    return self;
}

- (void)setValueWithAttrs:(NSDictionary *)attrs {
    self.service = attrs[(__bridge id)kSecAttrService];
    self.account = attrs[(__bridge id)kSecAttrAccount];
    self.passwordData = attrs[(__bridge id)kSecValueData];
    self.label = attrs[(__bridge id)kSecAttrLabel];
    self.type = attrs[(__bridge id)kSecAttrType];
    self.creater = attrs[(__bridge id)kSecAttrCreator];
    self.comment = attrs[(__bridge id)kSecAttrComment];
    self.descr = attrs[(__bridge id)kSecAttrDescription];
    self.modificationDate = attrs[(__bridge id)kSecAttrModificationDate];
    self.creationDate = attrs[(__bridge id)kSecAttrCreationDate];
    self.accessGroup = attrs[(__bridge id)kSecAttrAccessGroup];
    self.accessible = JCKeychainAttrAccessibleEnum(attrs[(__bridge id)kSecAttrAccessible]);
    self.synchronizable = JCKeychainQuerySynchonizationEnum(attrs[(__bridge id)kSecAttrSynchronizable]);
}

- (id)copyWithZone:(NSZone *)zone {
    JCKeychain *item = [JCKeychain new];
    item.service = self.service;
    item.account = self.account;
    item.passwordData = self.passwordData;
    item.label = self.label;
    item.type = self.type;
    item.creater = self.creater;
    item.comment = self.comment;
    item.descr = self.descr;
    item.modificationDate = self.modificationDate;
    item.creationDate = self.creationDate;
    item.accessGroup = self.accessGroup;
    item.accessible = self.accessible;
    item.synchronizable = self.synchronizable;
    return item;
}

- (NSMutableDictionary *)attrs {
    NSMutableDictionary * attrs = [self queryAttrs];
    
    if (self.label) {
        attrs[(__bridge id)kSecAttrLabel] = self.label;
    }
    
    if (self.accessible) {
        attrs[(__bridge id)kSecAttrAccessible] = JCKeychainAttrAccessibleString(self.accessible);
    }
    
    if (self.passwordData) {
        attrs[(__bridge id)kSecValueData] = self.passwordData;
    }
    if (self.type) {
        attrs[(__bridge id)kSecAttrType] = self.type;
    }
    if (self.creater) {
        attrs[(__bridge id)kSecAttrCreator] = self.creater;
    }
    if (self.comment) {
        attrs[(__bridge id)kSecAttrComment] = self.comment;
    }
    if (self.descr) {
        attrs[(__bridge id)kSecAttrDescription] = self.descr;
    }
    
    return attrs;
}

- (NSMutableDictionary *)queryAttrs {
    NSMutableDictionary * attrs = NSMutableDictionary.new;
    attrs[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    if (self.account) {
        attrs[(__bridge id)kSecAttrAccount] = self.account;
    }
    
    if (self.service) {
        attrs[(__bridge id)kSecAttrService] = self.service;
    }
    
    if (self.accessGroup) {
        attrs[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    attrs[(__bridge id)kSecAttrSynchronizable] = JCKeychainQuerySynchonizationID(self.synchronizable);
    return attrs;
}

#pragma mark - Set/Get

- (NSString *)password {
    if ([self.passwordData length]) {
        return [[NSString alloc] initWithData:self.passwordData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (void)setPassword:(NSString *)password {
    self.passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)setPasswordObject:(id <NSCoding> )object {
    self.passwordData = [NSKeyedArchiver archivedDataWithRootObject:object];
}

- (id <NSCoding> )passwordObject {
    if ([self.passwordData length]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:self.passwordData];
    }
    return nil;
}

@end
