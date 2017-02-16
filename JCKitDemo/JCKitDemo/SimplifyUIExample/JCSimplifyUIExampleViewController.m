//
//  JCSimplifyUIExampleViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/2/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCSimplifyUIExampleViewController.h"
#import "JCSimplifyUI.h"
#import "JCKit.h"

@interface JCSimplifyUIExampleViewController ()

@end

@implementation JCSimplifyUIExampleViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)demo1 {
    UIView *demo1 = [UIView focusUIViewInit:^(UIView *ins) {
        ins.backgroundColor = COLOR(@"blue");
        ins.frame = FRAME_XYWH(10, 64, 100, 100);
    }];
    [self.view addSubview:demo1];
    
    UILabel *label = [UILabel focusUILabelInit:^(UILabel *ins) {
        ins.text = @"4567890-";
        ins.frame = FRAME_XYWH(0, 0, 100, 100);
        ins.textAlignment = NSTextAlignmentCenter;
    }];
    [demo1 addSubview:label];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demo1];
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
