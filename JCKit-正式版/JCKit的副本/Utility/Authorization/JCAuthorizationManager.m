//
//  JCAuthorizationManager.m
//
//  Created by molin.JC on 2017/4/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCAuthorizationManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Speech/Speech.h>
#import <Intents/Intents.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <Accounts/Accounts.h>
#import <HealthKit/HealthKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
@import CoreTelephony;

#define _iOSVersion(version) ([[[UIDevice currentDevice] systemVersion] doubleValue] >= version)

static void _handlerWithBlock(void (^block)()) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block ? block() : nil;
    });
}

#define _StatusHandle(s, b1, b2) status == s ? _handlerWithBlock(b1) : _handlerWithBlock(b2)

@interface JCAuthorizationManager () <CLLocationManagerDelegate>

//** 定位管理  **//

/** 地理位置管理对象 */
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^locationAlwaysAuthorizedHandler)();
@property (nonatomic, copy) void (^locationAlwaysUnAuthorizedHandler)();
@property (nonatomic, copy) void (^locationWhenInUseAuthorizedHandler)();
@property (nonatomic, copy) void (^locationWhenInUseUnAuthorizedHandler)();
@property (nonatomic, assign) BOOL isRequestLocationAlways;
//** end **//


@end

@implementation JCAuthorizationManager

+ (void)requestAuthorizationWithType:(JCAuthorizationType)type authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    
    switch (type) {
        case JCAuthorizationTypeNetwork:
            [self requestNetworkWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypePhotoLibrary:
            [self requestPhotoLibraryWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeVideo:
            [self requestCameraAccessWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeAudio:
            [self requestAudioAccessWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeNotification:
            [self requestNotificationWithAuthorizationHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeAddressBook:
            [self requestAddressBookWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeCalendar:
            [self requestCalendarWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeReminder:
            [self requestReminderWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeAppleMusic:
            [self requestAppleMusicWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeSpeechRecognizer:
            [self requestSpeechRecognizerWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeSiri:
            [self requestSiriWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeBluetooth:
            [self requestBluetoothWithAuthorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JCAuthorizationTypeMotionActivity:
            [self requestMotionWithAuthorizationHandler:authorizedHandler];
            break;
        case JCAuthorizationTypeAdvertisingIdentifier:
            [self requestAdvertisingWithAuthorizationHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
            break;
        default:
            NSAssert(!1, @"该方法暂不提供");
            break;
    }
}

#pragma mark - Photo Library

+ (void)requestPhotoLibraryWithAuthorizedHandler:(void (^)())authorizedHandler unAuthorizedHandler:(void (^)())unAuthorizedHandler {
    
    if (_iOSVersion(8.0)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        // 不确定(说明是第一次)
        if (status == PHAuthorizationStatusNotDetermined) {
            
            // 请求授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                _StatusHandle(PHAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
            }];
        }else {
            _StatusHandle(PHAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
        }
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        _StatusHandle(ALAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
#pragma clang diagnostic pop
    }
}

#pragma mark - Network

+ (void)requestNetworkWithAuthorizedHandler:(void (^)())authorizedHandler unAuthorizedHandler:(void (^)())unAuthorizedHandler {
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    CTCellularDataRestrictedState status = cellularData.restrictedState;
    
    if (status == kCTCellularDataRestrictedStateUnknown) {
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            _StatusHandle(kCTCellularDataNotRestricted, authorizedHandler, unAuthorizedHandler);
        };
    }else {
        _StatusHandle(kCTCellularDataNotRestricted, authorizedHandler, unAuthorizedHandler);
    }
}

#pragma mark - Avcapture Media

+ (void)requestCameraAccessWithAuthorizedHandler:(void (^)())authorizedHandler unAuthorizedHandler:(void (^)())unAuthorizedHandler {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            granted ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
        }];
    }else {
        _StatusHandle(AVAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
    }
}

+ (void)requestAudioAccessWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            granted ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
        }];
    }else {
        _StatusHandle(AVAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
    }
}

#pragma mark - Notification

+ (void)requestNotificationWithAuthorizationHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    NSUInteger options;
    
    if (_iOSVersion(10.0)) {
        options = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        options = UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
#pragma clang diagnostic pop
    }
    
    [self requestNotificationWithOptions:options authorizationHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
}

+ (void)requestNotificationWithOptions:(NSUInteger)options authorizationHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    if (_iOSVersion(10.0)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    granted ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
                }];
            }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                _handlerWithBlock(authorizedHandler);
            }else {
                _handlerWithBlock(unAuthorizedHandler);
            }
        }];
    }else if (_iOSVersion(8.0)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (![UIApplication sharedApplication].isRegisteredForRemoteNotifications) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:options categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
            if ([UIApplication sharedApplication].currentUserNotificationSettings.types != UIUserNotificationTypeNone) {
                _handlerWithBlock(authorizedHandler);
            }else {
                _handlerWithBlock(unAuthorizedHandler);
            }
        }else {
            _handlerWithBlock(authorizedHandler);
        }
#pragma clang diagnostic pop
    }
}

#pragma mark - Address Book

+ (void)requestAddressBookWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    
    if (_iOSVersion(9.0)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (status == CNAuthorizationStatusNotDetermined) {
            [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                granted ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
            }];
        }else {
            _StatusHandle(CNAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
        }
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        if (status == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreate(), ^(bool granted, CFErrorRef error) {
                granted ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
            });
        }else {
            _StatusHandle(kABAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
        }
#pragma clang diagnostic pop
    }
}

#pragma mark - Calendar

+ (void)requestCalendarWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    if (status == EKAuthorizationStatusNotDetermined) {
        [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            granted ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
        }];
    }else {
        _StatusHandle(EKAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
    }
}

#pragma mark - Reminder

+ (void)requestReminderWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    if (status == EKAuthorizationStatusNotDetermined) {
        [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
            granted ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
        }];
    }else {
        _StatusHandle(EKAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
    }
}

#pragma mark - Apple Music

+ (void)requestAppleMusicWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
    
    if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            _StatusHandle(MPMediaLibraryAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
        }];
    }else {
        _StatusHandle(MPMediaLibraryAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
    }
    
}

#pragma mark - Speech Recognizer

+ (void)requestSpeechRecognizerWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    
    if (status == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            _StatusHandle(SFSpeechRecognizerAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
        }];
    }else {
        _StatusHandle(SFSpeechRecognizerAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
    }
}

#pragma mark - Siri

+ (void)requestSiriWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    
    if (!_iOSVersion(10.0)) {
        NSAssert(_iOSVersion(10.0), @"该方法必须在iOS10.0或以上版本使用");
        return;
    }
    INSiriAuthorizationStatus status = [INPreferences siriAuthorizationStatus];
    
    if (status == INSiriAuthorizationStatusNotDetermined) {
        [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
            _StatusHandle(INSiriAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
        }];
    }else {
        _StatusHandle(INSiriAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
    }
}

#pragma mark - Bluetooth

+ (void)requestBluetoothWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    
    if (status == CBPeripheralManagerAuthorizationStatusNotDetermined) {
        [[[CBCentralManager alloc] init] scanForPeripheralsWithServices:nil options:nil];
    }else {
        _StatusHandle(CBPeripheralManagerAuthorizationStatusAuthorized, authorizedHandler, unAuthorizedHandler);
    }
}

#pragma mark - Motion Activity

+ (void)requestMotionWithAuthorizationHandler:(void(^)())authorizedHandler {
    BOOL isSupport = [CMMotionActivityManager isActivityAvailable];
    NSAssert(isSupport, @"不支持活动与体能训练记录");
    
    CMMotionActivityManager *manager = [[CMMotionActivityManager alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [manager startActivityUpdatesToQueue:queue withHandler:^(CMMotionActivity *activity) {
        _handlerWithBlock(authorizedHandler);
    }];
}

#pragma mark - Advertising Identifier

+ (void)requestAdvertisingWithAuthorizationHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    BOOL isAuthorized = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    isAuthorized ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
}

#pragma mark - Share Account

+ (void)requestShareWithAuthorizationShareType:(JCAuthorizationShareType)type options:(NSDictionary *)options authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler errorHandler:(void(^)(NSError *error))errorHandler {
    switch (type) {
        case JCAuthorizationShareTypeTwitter:
            [self _requestShareWithAccountTypeIndentifier:ACAccountTypeIdentifierTwitter
                                                  options:options
                                        authorizedHandler:authorizedHandler
                                      unAuthorizedHandler:unAuthorizedHandler
                                             errorHandler:errorHandler];
            break;
        case JCAuthorizationShareTypeFacebook:
            [self _requestShareWithAccountTypeIndentifier:ACAccountTypeIdentifierFacebook
                                                  options:options
                                        authorizedHandler:authorizedHandler
                                      unAuthorizedHandler:unAuthorizedHandler
                                             errorHandler:errorHandler];
            break;
        case JCAuthorizationShareTypeSinaWeibo:
            [self _requestShareWithAccountTypeIndentifier:ACAccountTypeIdentifierSinaWeibo
                                                  options:options
                                        authorizedHandler:authorizedHandler
                                      unAuthorizedHandler:unAuthorizedHandler
                                             errorHandler:errorHandler];
            break;
        case JCAuthorizationShareTypeTencentWeibo:
            [self _requestShareWithAccountTypeIndentifier:ACAccountTypeIdentifierTencentWeibo
                                                  options:options
                                        authorizedHandler:authorizedHandler
                                      unAuthorizedHandler:unAuthorizedHandler
                                             errorHandler:errorHandler];
            break;
        default:
            break;
    }
}

+ (void)_requestShareWithAccountTypeIndentifier:(NSString *)typeIndentifier options:(NSDictionary *)options authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler errorHandler:(void(^)(NSError *error))errorHandler {
    ACAccountStore *accounStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accounStore accountTypeWithAccountTypeIdentifier:typeIndentifier];
    
    if ([accountType accessGranted]) {
        _handlerWithBlock(authorizedHandler);
    }else {
        
        if ([typeIndentifier isEqualToString:ACAccountTypeIdentifierFacebook] ||
            [typeIndentifier isEqualToString:ACAccountTypeIdentifierTencentWeibo]) {
            NSAssert(options, @"Option不能为nil");
        }
        
        [accounStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
            granted ? _handlerWithBlock(authorizedHandler) : error ? _handlerWithBlock(errorHandler) : _handlerWithBlock(unAuthorizedHandler);
        }];
    }
}

#pragma mark - HealthKit

+ (NSSet<HKSampleType *> *)setWithSampleType:(HKQuantityTypeIdentifier)identifier, ... {
    
    if (!identifier) {
        return nil;
    }
    NSMutableSet *set = [NSMutableSet new];
    id nextIdentifier = identifier;
    va_list arglist;
    va_start(arglist, identifier);
    do {
        HKSampleType *type = [HKSampleType quantityTypeForIdentifier:nextIdentifier];
        [set addObject:type];
    } while ((nextIdentifier = va_arg(arglist, HKQuantityTypeIdentifier)));
    
    va_end(arglist);
    return set.mutableCopy;
}

+ (NSSet<HKObjectType *> *)setWithObjectType:(HKQuantityTypeIdentifier)identifier, ... {
    
    if (!identifier) {
        return nil;
    }
    NSMutableSet *set = [NSMutableSet new];
    id nextIdentifier = identifier;
    va_list arglist;
    va_start(arglist, identifier);
    do {
        HKObjectType *type = [HKObjectType quantityTypeForIdentifier:nextIdentifier];
        [set addObject:type];
    } while ((nextIdentifier = va_arg(arglist, HKQuantityTypeIdentifier)));
    
    va_end(arglist);
    return set.mutableCopy;
}

+ (void)requestHealthAuthorizationWithShareTypesAndReadTypes:(NSSet<HKObjectType *> *)types authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    [self requestHealthAuthorizationWithShareTypes:types readTypes:types authorizedHandler:authorizedHandler unAuthorizedHandler:unAuthorizedHandler];
}

+ (void)requestHealthAuthorizationWithShareTypes:(NSSet<HKSampleType *> *)typesToShare readTypes:(NSSet<HKObjectType *> *)typesToRead authorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    
    // 判断HealthKit是否可用
    BOOL isSupportHealthKit = [HKHealthStore isHealthDataAvailable];
    NSAssert(isSupportHealthKit, @"不支持HealthKit");
    
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
    __block BOOL shouldRequestAccess = NO;
    
    if (typesToShare.count > 0) {
        [typesToShare enumerateObjectsUsingBlock:^(HKSampleType * _Nonnull obj, BOOL * _Nonnull stop) {
            HKAuthorizationStatus status = [healthStore authorizationStatusForType:obj];
            
            if (status == HKAuthorizationStatusNotDetermined) {
                shouldRequestAccess = YES;
                *stop = YES;
            }
        }];
    }else {
        if (typesToRead.count > 0) {
            [typesToRead enumerateObjectsUsingBlock:^(HKObjectType * _Nonnull obj, BOOL * _Nonnull stop) {
                HKAuthorizationStatus status = [healthStore authorizationStatusForType:obj];
                
                if (status == HKAuthorizationStatusNotDetermined) {
                    shouldRequestAccess = YES;
                    *stop = YES;
                }
            }];
        }else {
            NSAssert(typesToRead.count > 0, @"待请求的权限类型数组不能为空");
        }
    }
    
    if (shouldRequestAccess) {
        [healthStore requestAuthorizationToShareTypes:typesToShare readTypes:typesToRead completion:^(BOOL success, NSError * _Nullable error) {
            success ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
        }];
    }else {
        __block BOOL isAuthorized = NO;
        
        if (typesToShare.count > 0) {
            [typesToShare enumerateObjectsUsingBlock:^(HKSampleType * _Nonnull obj, BOOL * _Nonnull stop) {
                HKAuthorizationStatus status = [healthStore authorizationStatusForType:obj];
                
                if (status == HKAuthorizationStatusNotDetermined ||
                    status == HKAuthorizationStatusSharingDenied) {
                    isAuthorized = NO;
                }else {
                    isAuthorized = YES;
                }
            }];
        }else {
            if (typesToRead.count > 0) {
                [typesToRead enumerateObjectsUsingBlock:^(HKObjectType * _Nonnull obj, BOOL * _Nonnull stop) {
                    HKAuthorizationStatus status = [healthStore authorizationStatusForType:obj];
                    
                    if (status == HKAuthorizationStatusNotDetermined ||
                        status == HKAuthorizationStatusSharingDenied) {
                        isAuthorized = NO;
                    }else {
                        isAuthorized = YES;
                    }
                }];
            }else {
                NSAssert(typesToRead.count > 0, @"待请求的权限类型数组不能为空");
            }
        }
        
        isAuthorized ? _handlerWithBlock(authorizedHandler) : _handlerWithBlock(unAuthorizedHandler);
    }
}

#pragma mark - Location

+ (instancetype)authorizationManagerWithLocation {
    return [[self alloc] initWithLocationManager];
}

- (instancetype)initWithLocationManager {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

/** 一直请求定位权限 */
- (void)requestLocationAlwaysWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSAssert([CLLocationManager locationServicesEnabled], @"启用位置服务失败");
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        self.locationAlwaysAuthorizedHandler = authorizedHandler;
        self.locationAlwaysUnAuthorizedHandler = unAuthorizedHandler;
        [self.locationManager requestAlwaysAuthorization];
        self.isRequestLocationAlways = YES;
    }else {
        _StatusHandle(kCLAuthorizationStatusAuthorizedAlways, authorizedHandler, unAuthorizedHandler);
    }
}

/** 使用时请求定位权限 */
- (void)requestLocationWhenInUseWithAuthorizedHandler:(void(^)())authorizedHandler unAuthorizedHandler:(void(^)())unAuthorizedHandler {
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSAssert([CLLocationManager locationServicesEnabled], @"启用位置服务失败");
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        self.locationWhenInUseAuthorizedHandler = authorizedHandler;
        self.locationWhenInUseUnAuthorizedHandler = unAuthorizedHandler;
        [self.locationManager requestWhenInUseAuthorization];
        self.isRequestLocationAlways = NO;
    }else {
        _StatusHandle(kCLAuthorizationStatusAuthorizedWhenInUse, authorizedHandler, unAuthorizedHandler);
    }
}

/** CLLocationManagerDelegate */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        _handlerWithBlock(self.locationAlwaysUnAuthorizedHandler);
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _handlerWithBlock(self.locationWhenInUseAuthorizedHandler);
    }else {
        self.isRequestLocationAlways ? _handlerWithBlock(self.locationAlwaysUnAuthorizedHandler) : _handlerWithBlock(self.locationWhenInUseUnAuthorizedHandler);
    }
}

@end
