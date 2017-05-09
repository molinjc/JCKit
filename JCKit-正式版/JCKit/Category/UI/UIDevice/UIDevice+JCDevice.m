//
//  UIDevice+JCDevice.m
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIDevice+JCDevice.h"
#import "NSString+JCString.h"
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <mach/mach.h>

@implementation UIDevice (JCDevice)

/**
 系统版本
 */
+ (float)systemVersion {
    static float version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.floatValue;
    });
    return version;
}

/**
 是否是iPad设备
 */
- (BOOL)isPad {
    static dispatch_once_t onceToken;
    static BOOL pad;
    dispatch_once(&onceToken, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

/**
 是否是iPhone设备
 */
- (BOOL)isPhone {
    static dispatch_once_t onceToken;
    static BOOL phone;
    dispatch_once(&onceToken, ^{
        phone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    });
    return phone;
}

/**
 是否是模拟器
 */
- (BOOL)isSimulator {
    static dispatch_once_t onceToken;
    static BOOL simulator;
    dispatch_once(&onceToken, ^{
        NSString *model = [self machineModel];
        if ([model isEqualToString:@"x86_64"] || [model isEqualToString:@"i386"]) {
            simulator = YES;
        }
    });
    return simulator;
}

/**
 是否已经越狱
 */
- (BOOL)isJailbroken {
    if (self.isSimulator) {
        return NO;
    }
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString stringWithUUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    return NO;
}

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED

/**
 是否能打电话
 */
- (BOOL)canMakePhoneCalls {
    static BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}
#endif

/**
 获取设备号（如iPhone5,3、iPhone7,1...）
 */
- (NSString *)machineModel {
    static dispatch_once_t onceToken;
    static NSString *model;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

/**
 获取设备名（如iPhone6、iPhone6s...）
 */
- (NSString *)machineModelName {
    static dispatch_once_t onceToken;
    static NSString *name;
    dispatch_once(&onceToken, ^{
        NSString *model = [self machineModel];
        if (!model) {
            return ;
        }
        NSDictionary *dic = @{
                              @"Watch1,1" : @"Apple Watch",
                              @"Watch1,2" : @"Apple Watch",
                              
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5",
                              @"iPhone5,2" : @"iPhone 5",
                              @"iPhone5,3" : @"iPhone 5c",
                              @"iPhone5,4" : @"iPhone 5c",
                              @"iPhone6,1" : @"iPhone 5s",
                              @"iPhone6,2" : @"iPhone 5s",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              
                              @"iPad1,1" : @"iPad 1",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2",
                              @"iPad2,5" : @"iPad mini 1",
                              @"iPad2,6" : @"iPad mini 1",
                              @"iPad2,7" : @"iPad mini 1",
                              @"iPad3,1" : @"iPad 3 (WiFi)",
                              @"iPad3,2" : @"iPad 3 (4G)",
                              @"iPad3,3" : @"iPad 3 (4G)",
                              @"iPad3,4" : @"iPad 4",
                              @"iPad3,5" : @"iPad 4",
                              @"iPad3,6" : @"iPad 4",
                              @"iPad4,1" : @"iPad Air",
                              @"iPad4,2" : @"iPad Air",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad4,4" : @"iPad mini 2",
                              @"iPad4,5" : @"iPad mini 2",
                              @"iPad4,6" : @"iPad mini 2",
                              @"iPad4,7" : @"iPad mini 3",
                              @"iPad4,8" : @"iPad mini 3",
                              @"iPad4,9" : @"iPad mini 3",
                              @"iPad5,1" : @"iPad mini 4",
                              @"iPad5,2" : @"iPad mini 4",
                              @"iPad5,3" : @"iPad Air 2",
                              @"iPad5,4" : @"iPad Air 2",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) {
            name = model;
        }
    });
    return name;
}

/**
 系统启动时间
 */
- (NSDate *)systemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}

#pragma mark - 网络相关

/**
 lo0 本地ip：127.0.0.1
 en0 局域网：192.168.1.1
 pdp_ip0 WWAN地址，即3G ip,
 bridge0 桥接、热点ip：172.20.10.1
 */

/**
 获取该设备的当前WIFI链接的IP地址
 @return @"192.168.1.111"/nil
 */
- (NSString *)ipAddressWIFI {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

/**
 获取该设备手机网络(WWAN)的IP地址
 @return @"10.2.2.222"/nil
 */
- (NSString *)ipAddressCell {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

#pragma mark - 磁盘空间

/**
 磁盘总空间
 */
- (int64_t)diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        return -1;
    }
    int64_t space = [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) {
        space = -1;
    }
    return space;
}

/**
 空闲的磁盘空间
 */
- (int64_t)diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        return -1;
    }
    int64_t space = [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) {
        space = -1;
    }
    return space;
}

/**
 使用的磁盘空间
 */
- (int64_t)diskSpaceUsed {
    int64_t total = self.diskSpace;
    int64_t free = self.diskSpaceFree;
    if (total < 0 || free < 0) {
        return -1;
    }
    int64_t used = total - free;
    if (used < 0) {
        used = -1;
    }
    return used;
}

#pragma mark - 内存信息

/**
 总内存
 */
- (int64_t)memoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) {
        mem = -1;
    }
    return mem;
}

/**
 使用的内存
 */
- (int64_t)memoryUsed {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

/**
 Free:表示这些[内存]中的数据是无效的，这些空间可以随时被程序使用
 */
- (int64_t)memoryFree {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    return vm_stat.free_count * page_size;
}

/**
 Active:表示这些[内存]数据正在使用种，或者刚被使用过。
 */
- (int64_t)memoryActive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    return vm_stat.active_count * page_size;
}

/**
 Inactive:表示这些[内存]中的数据是有效的，但是最近没有被使用
 */
- (int64_t)memoryInactive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    return vm_stat.inactive_count * page_size;
}

/**
 Wired:系统核心占用的，永远不会从系统物理[内存]种驱除
 */
- (int64_t)memoryWired {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    return vm_stat.wire_count * page_size;
}

/**
 便携式存储器
 */
- (int64_t)memoryPurgable {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    return vm_stat.purgeable_count * page_size;
}

- (NSString *(^)(int64_t))sizeString {
    return ^(int64_t size) {
        int64_t size_k = size / 1024.0;
        int64_t size_M = size_k / 1024.0;
        int64_t size_G = size_M / 1024.0;
        if (size_G > 0.01) {
            return [NSString stringWithFormat:@"%lldG",size_G];
        }
        if (size_M > 0.01) {
            return [NSString stringWithFormat:@"%lldM",size_M];
        }
        return [NSString stringWithFormat:@"%lldk",size_k];
    };
}

@end
