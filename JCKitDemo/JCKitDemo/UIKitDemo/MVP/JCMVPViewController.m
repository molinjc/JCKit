//
//  JCMVPViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCMVPViewController.h"
#import "JCMVPPresenter.h"

@interface JCMVPViewController ()

@property (nonatomic, strong) JCMVPPresenter *mvpPresenter;

@property (nonatomic, copy) NSString *string; // 用于KVO

@end

@implementation JCMVPViewController

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)button1E:(id)sender {
    [self.mvpPresenter event1];
}

- (void)button2E:(id)sender {
    [self.mvpPresenter event2];
}

- (void)button3E:(id)sender {
    self.string = [NSString stringWithFormat:@"%d",arc4random()/1000];
}

- (void)addButons {
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.backgroundColor = [UIColor lightGrayColor];
    [button1 addTarget:self action:@selector(button1E:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(20, 74, 100, 40);
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.backgroundColor = [UIColor grayColor];
    [button2 addTarget:self action:@selector(button2E:) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(20, 124, 100, 40);
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.backgroundColor = [UIColor grayColor];
    [button3 addTarget:self.mvpPresenter.mvpSignal action:@selector(sendSubscriptionNumber:withValue:) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(20, 174, 100, 40);
    [self.view addSubview:button3];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.string = @"1";
    
    self.mvpPresenter = [[JCMVPPresenter alloc] init];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:@"button1" callback:^(NSString *value){
        NSLog(@"button1: %@",value);
    }];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:@"button2" callback:^(NSString *value){
        NSLog(@"button2: %@",value);
    }];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:@"stringKVO" observe:self keyPath:@"string"];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:@"stringKVO" callback:^(JCMVPViewController *vc, NSString *newS, NSString *oldS){
        NSLog(@"VC:%@; new:%@; old:%@",vc,newS,oldS);
    }];
    
    [self addButons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"View已经消失");
    self.mvpPresenter = nil;
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
