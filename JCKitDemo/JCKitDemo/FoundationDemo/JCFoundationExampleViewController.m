//
//  JCFoundationExampleViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCFoundationExampleViewController.h"
#import "JCKit.h"
@interface JCFoundationExampleViewController ()

@end

@implementation JCFoundationExampleViewController

- (void)test_NSLocale {
    JCLog(@"%@", [NSLocale ISOCountryCodes]);  // 所有的ISO定义的国家地区编码
    JCLog(@"%@", [NSLocale ISOCurrencyCodes]); // 所有的ISO定义的货币编码
    JCLog(@"%@", [NSLocale ISOLanguageCodes]); // 所有ISO定义的语言编码
    JCLog(@"%@", [[NSLocale currentLocale] localeIdentifier]); // 获取当前系统设置语言的标识符
    
    //获取系统当前时间
    NSDate *currentDate=[NSDate dateWithString:@"2016-12-01 12:33:21"];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:sszzz"];
    //NSDate转NSString
    NSString *currentDateString=[dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    JCLog(@"1:%@",currentDateString);
    NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.locale = usLocale;
    JCLog(@"2:%@",currentDateString);
    double d = NAN;
    JCLog(@"%d", isn(d));
    
}

int isn(double d) {
    return d == d;
}

+ (void)haha {
    JCLog(@"haha");
}

- (void)date {
    JCLog(@"%@", [self stringWithTimelineDate:[NSDate dateWithString:@"2016-12-01 12:33:21"]]);
}

- (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterFullDate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"M/d/yy"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // local time error
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60) {
        return [NSString stringWithFormat:@"%ds",(int)(delta)];
    } else if (delta < 60 * 60) {
        return [NSString stringWithFormat:@"%dm", (int)(delta / 60.0)];
    } else if (delta < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%dh", (int)(delta / 60.0 / 60.0)];
    } else if (delta < 60 * 60 * 24 * 7) {
        return [NSString stringWithFormat:@"%dd", (int)(delta / 60.0 / 60.0 / 24.0)];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCell:@"JSON" class:@"JCJSONViewController"];
    [self addCell:@"NSUserDefaults" class:@"JCNSUserDefaultsViewController"];
    [self addCell:@"NSCache" class:@"JCNSCacheViewController"];
    [self addCell:@"NSInvocation" class:@"JCNSInvocationViewController"];
    [self addCell:@"NSDate" class:@"JCNSDateViewController"];
    
    [self test_NSLocale];
//    Class class = NSClassFromString(@"JCJSONViewController"); // 根据给定的类名创建一个类
//    if (class) {
//        UIViewController *ctrl = class.new;  // 也可以用[class new],把类给UIViewController
//        ctrl.title = @"JSON";
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
    
    [self date];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
