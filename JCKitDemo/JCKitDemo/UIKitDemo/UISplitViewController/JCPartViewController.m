//
//  JCPartViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCPartViewController.h"

@interface JCPartViewController ()
{
    NSMutableArray *_viewControllers;
}
@end

@implementation JCPartViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

- (instancetype)init {
    if (self = [super init]) {
        _viewControllers = [NSMutableArray new];
    }
    return self;
}

- (void)addViewController:(UIViewController *)viewController {
    [_viewControllers addObject:viewController];
    [self.view addSubview:viewController.view];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
