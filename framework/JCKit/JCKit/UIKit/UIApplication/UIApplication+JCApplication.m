//
//  UIApplication+JCApplication.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIApplication+JCApplication.h"
#import "UIDevice+JCDevice.h"
#import <sys/sysctl.h>

@implementation UIApplication (JCApplication)

- (NSString *)appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (BOOL)isPirated {
    if ([UIDevice currentDevice].isSimulator) {
        return YES;
    }
    
    if (getgid() <= 10) {   // 不是根进程标识
        return YES;
    }
    
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"SignerIdentity"]) {
        return YES;
    }
    
    if (![self _jc_fileExistInMainBundle:@"_CodeSignature"]) {
        return YES;
    }
    
    if (![self _jc_fileExistInMainBundle:@"SC_Info"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isBeingDebugged {
    size_t size = sizeof(struct kinfo_proc);
    struct kinfo_proc info;
    int ret = 0, name[4];
    memset(&info, 0, sizeof(struct kinfo_proc));
    
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    
    if (ret == (sysctl(name, 4, &info, &size, NULL, 0))) {
        return ret != 0;
    }
    return (info.kp_proc.p_flag & P_TRACED) ? YES : NO;
}

/**
 手动更改状态栏的颜色
 */
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[self valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if (statusBar && [statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

+ (void)call:(NSString *)phone {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]];
}

+ (void)hideKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

+ (id)appDelegate {
    return [UIApplication sharedApplication].delegate;
}

#pragma mark - private

- (BOOL)_jc_fileExistInMainBundle:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


@end
