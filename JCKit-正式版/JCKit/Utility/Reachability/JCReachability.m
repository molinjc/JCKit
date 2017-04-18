//
//  JCReachability.m
//  JCViewLayout
//
//  Created by molin.JC on 2017/4/10.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#pragma mark - common

/**
 获取连接网络状态
 @param flags 保存返回连接状态的枚举
 @return 网络状态(JCReachabilityStatus)
 */
static JCReachabilityStatus JCReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags) {
    if (!flags) {
        return JCReachabilityStatusNone;
    }
    
    if (!(flags & kSCNetworkReachabilityFlagsReachable)) {
        return JCReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
        (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return JCReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
        return JCReachabilityStatusWWAN;
    }
    
    return JCReachabilityStatusWIFI;
}

/** 声明监听网络状态，具体实现在@end后面 */
static void JCReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info);

@implementation JCReachability {
    SCNetworkReachabilityRef _ref;
    CTTelephonyNetworkInfo * _networkInfo;
    BOOL _scheduled;
    NSMutableArray *_notifys;
}

#pragma mark - dealloc

- (void)dealloc {
    _notifyBlock = nil;
    [_notifys removeAllObjects];
    _notifys = nil;
    [self scheduled:NO];
    CFRelease(_ref);
}

#pragma mark - init

- (instancetype)init {
    struct sockaddr_in zero_Address;
    bzero(&zero_Address, sizeof(zero_Address));
    zero_Address.sin_len = sizeof(zero_Address);
    zero_Address.sin_family = AF_INET;
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_Address);
    return [self initWithRef:ref];
}

- (instancetype)initWithRef:(SCNetworkReachabilityRef)ref {
    if (!ref) {
        return nil;
    }
    
    if (self = [super init]) {
        _ref = ref;
        _notifys = NSMutableArray.new;
        
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
            _networkInfo = [CTTelephonyNetworkInfo new];
        }
    }
    return self;
}

+ (instancetype)reachability {
    return [[self alloc] init];
}

+ (instancetype)reachabilityForLocalWifi {
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&localWifiAddress);
    return [[self alloc] initWithRef:ref];
}

+ (instancetype)reachabilityWithURL:(NSString *)url {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    return [[self alloc] initWithRef:ref];
}

+ (instancetype)reachabilityWithIP:(NSString *)IP {
    struct sockaddr_in IP_Address;
    bzero(&IP_Address, sizeof(IP_Address));
    IP_Address.sin_len = sizeof(IP_Address);
    IP_Address.sin_family = AF_INET;
    IP_Address.sin_addr.s_addr = inet_addr([IP UTF8String]);
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&IP_Address);
    return [[self alloc] initWithRef:ref];
}

#pragma mark - Block Callback

/**
 预定当网络状态变化时通知下(监听网络状态)
 @param scheduled YES: 预定, NO: 取消预定
 */
- (void)scheduled:(BOOL)scheduled {
    if (_scheduled == scheduled) {
        return;
    }
    _scheduled = scheduled;
    
    if (_scheduled) {
        SCNetworkReachabilityContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
        SCNetworkReachabilitySetCallback(_ref, JCReachabilityCallback, &context);
        SCNetworkReachabilitySetDispatchQueue(_ref, [JCReachability sharedQueue]);
    }else {
        SCNetworkReachabilitySetDispatchQueue(_ref, NULL);
    }
}

+ (dispatch_queue_t)sharedQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.molin.JCKit.reachability", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

#pragma mark - NSNotificationCenter Callback

- (void)addNotifyName:(NSString *)name {
    [_notifys addObject:name];
}

- (void)removeNotifyName:(NSString *)name {
    [_notifys removeObject:name];
}

- (void)postNotify {
    for (NSString *name in _notifys) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:@{@"kReachability":self}];
    }
}

#pragma mark - Get / Set

- (BOOL)isReachable {
    return self.status != JCReachabilityStatusNone;
}

- (SCNetworkReachabilityFlags)flags {
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(_ref, &flags);
    return flags;
}

- (JCReachabilityStatus)status {
    return JCReachabilityStatusFromFlags([self flags]);
}

- (JCReachabilityWWANStatus)WWANStatus {
    if (!_networkInfo) {
        return JCReachabilityWWANStatusNone;
    }
    
    NSString *status = _networkInfo.currentRadioAccessTechnology;
    if (!status) {
        return JCReachabilityWWANStatusNone;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{CTRadioAccessTechnologyGPRS         : @(JCReachabilityWWANStatus2G),
                CTRadioAccessTechnologyEdge         : @(JCReachabilityWWANStatus2G),
                CTRadioAccessTechnologyWCDMA        : @(JCReachabilityWWANStatus3G),
                CTRadioAccessTechnologyHSDPA        : @(JCReachabilityWWANStatus3G),
                CTRadioAccessTechnologyHSUPA        : @(JCReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMA1x       : @(JCReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORev0 : @(JCReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevA : @(JCReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevB : @(JCReachabilityWWANStatus3G),
                CTRadioAccessTechnologyeHRPD        : @(JCReachabilityWWANStatus3G),
                CTRadioAccessTechnologyLTE          : @(JCReachabilityWWANStatus4G)};
    });
    
    NSNumber *num = dic[status];
    if (num) {
        return num.unsignedIntegerValue;
    }
    return JCReachabilityWWANStatusNone;
}

- (void)setNotifyBlock:(void (^)(JCReachability *))notifyBlock {
    _notifyBlock = [notifyBlock copy];
    [self scheduled:(_notifyBlock != nil)];
}

@end

static void JCReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    JCReachability *self = ((__bridge JCReachability *)info);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self postNotify];
        if (self.notifyBlock) {
            self.notifyBlock(self);
        }
    });
}
