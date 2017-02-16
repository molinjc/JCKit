//
//  JCScanViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCScanViewController.h"
#import "JCQRCodeScanViewBase.h"

@interface JCScanViewController ()
@property (nonatomic, strong) JCQRCodeScanViewBase *scanView;
@end

@implementation JCScanViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scanView = [[JCQRCodeScanViewBase alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds)/3*2, CGRectGetWidth([UIScreen mainScreen].bounds)/3*2)];
    _scanView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, CGRectGetHeight([UIScreen mainScreen].bounds)/2);
    [self.view addSubview:_scanView];
    [_scanView startScan];
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
