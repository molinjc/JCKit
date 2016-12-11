//
//  JCNSUserDefaultsViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/30.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCNSUserDefaultsViewController.h"
#import "JCKitMacro.h"
#import "NSURL+JCURL.h"
#import "NSDictionary+JCBlock.h"

#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface JCUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

@implementation JCUser

- (NSString *)description {
    return [NSString stringWithFormat:@"<name:%@ age:%zd>",self.name, self.age];
}

@end

@interface JCNSUserDefaultsViewController ()

@end

@implementation JCNSUserDefaultsViewController

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)save {
//   NSUserDefaults只能存取NSString、NSArray、NSDictionary、NSData、NSNumber类型的数据。
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"保存数据" forKey:@"save"];
    JCUser *user = [JCUser new];
    user.name = @"name";
    user.age = 122;
//    [userDefaults setObject:@[user] forKey:@"user"];
}


- (void)read {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *save = [userDefaults objectForKey:@"save"];
    JCLog(@"%@",save);
    
    NSArray *array = [userDefaults objectForKey:@"user"];
    JCUser *user = array[0];
    JCLog(@"%@",user);
}

- (void)test1 {
    struct sockaddr_in zero_addr;
    bzero(&zero_addr, sizeof(zero_addr));
    zero_addr.sin_len = sizeof(zero_addr);
    zero_addr.sin_family = AF_INET;
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(ref, &flags);
    JCLog(@"%@",YYReachabilityStatusFromFlags(flags, YES));
}

static NSString * YYReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags, BOOL allowWWAN) {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return @"Not Reachable";
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
        (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return @"Reachable via WiFi";
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && allowWWAN) {
        return @" Reachable via WWAN (2G/3G/4G)";
    }
    
    return @"Reachable via WiFi";
}

- (void)test2 {
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.131:8080/craft4j/share/shareClientOrder.do?orderNo=20161202101213509"];
    JCLog(@"%@",url.parameters);
}

- (void)test3 {
    JCLog(@"%@",[NSBundle mainBundle].infoDictionary);
}

- (void)test4 {
    NSMutableDictionary *dic = @{@"a":@(NO)}.mutableCopy;
//    BOOL size = [dic boolForKey:@"a"];
//    if (size) {
//         JCLog(@"%@",@"12343");
//    }
}

- (void)test5 {
 
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self save];
    [self read];
    [self test1];
    [self test2];
    [self test3];
    [self test4];
    [self test5];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
