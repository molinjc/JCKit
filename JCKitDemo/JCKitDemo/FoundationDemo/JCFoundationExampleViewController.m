//
//  JCFoundationExampleViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCFoundationExampleViewController.h"

@interface JCFoundationExampleViewController ()

@end

@implementation JCFoundationExampleViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCell:@"JSON" class:@"JCJSONViewController"];
    [self addCell:@"NSUserDefaults" class:@"JCNSUserDefaultsViewController"];
    [self addCell:@"NSCache" class:@"JCNSCacheViewController"];
    
    
//    Class class = NSClassFromString(@"JCJSONViewController"); // 根据给定的类名创建一个类
//    if (class) {
//        UIViewController *ctrl = class.new;  // 也可以用[class new],把类给UIViewController
//        ctrl.title = @"JSON";
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
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
