//
//  JCButtonViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/9.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCButtonViewController.h"
#import "JCProgressButton.h"

@interface JCButtonViewController ()
@property (nonatomic, strong) JCProgressButton *button;
@end

@implementation JCButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _button = [[JCProgressButton alloc] initWithFrame:CGRectMake(10, 77, 50, 50)];
    _button.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_button];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_button state];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
