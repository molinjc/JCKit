//
//  JCLogBaseViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCLogBaseViewController.h"

@interface JCLogBaseViewController ()

@end

@implementation JCLogBaseViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)_initLogTextView {
    _logTextView = JCLogTextView.new;
    
    CGFloat x = 10;
    CGFloat y = 10;
    CGFloat w = self.view.frame.size.width - x * 2;
    CGFloat h = self.view.frame.size.height - y - x;
    if (self.navigationController.navigationBar) {
        y = 74;
        h = self.view.frame.size.height - y - x;
    }
    
    _logTextView.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:_logTextView];
    
    _logTextView.layer.borderWidth = 1;
    _logTextView.layer.borderColor = [UIColor blackColor].CGColor;
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _initLogTextView];
    
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
