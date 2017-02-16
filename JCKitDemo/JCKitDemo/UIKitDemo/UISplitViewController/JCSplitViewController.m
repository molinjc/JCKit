//
//  JCSplitViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCSplitViewController.h"
#import "JCPartViewController.h"

@interface JCSplitViewController ()

@end

@implementation JCSplitViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test {
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.view.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height);
    UINavigationController *nvc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    vc1.title = @"vc1";
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor darkGrayColor];
    vc2.view.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, self.view.frame.size.height);
    UINavigationController *nvc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    vc2.title = @"vc2";
    
    splitVC.viewControllers = @[nvc1, nvc2];
    //    [self presentModalViewController:splitVC animated:YES];
    [self presentViewController:splitVC animated:YES completion:^{
        
    }];
}

- (void)test2 {
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.view.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height);
    UINavigationController *nvc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    vc1.title = @"vc1";
    
    JCPartViewController *part = [[JCPartViewController alloc] init];
    [part addViewController:nvc1];
    [self.navigationController pushViewController:part animated:YES];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
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
