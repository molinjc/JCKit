//
//  JCJCCodedLockViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/12.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCJCCodedLockViewController.h"
#import "JCCodedLockView.h"

@interface JCJCCodedLockViewController ()<JCCodedLockViewDelegate>

@end

@implementation JCJCCodedLockViewController
{
    JCCodedLockView *_codedLockView;
}
#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)initWithCodedLockView {
    _codedLockView = [[JCCodedLockView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)
                              andWithButtonStateNormalImage:[UIImage imageNamed:@"tabbar_mainframe"]
                                 orButtonStateSelectedImage:[UIImage imageNamed:@"tabbar_mainframeHL"]];
    [self.view addSubview:_codedLockView];
    _codedLockView.delegate = self;
}

#pragma mark - JCCodedLockViewDelegate

- (void)codedLockView:(JCCodedLockView *)codedLockView didFinishPath:(NSMutableString *)path {
    NSLog(@"JCJCCodedLockViewController:%@",path);
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithCodedLockView];
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
