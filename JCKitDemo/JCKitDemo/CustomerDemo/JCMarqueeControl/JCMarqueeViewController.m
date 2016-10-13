//
//  JCMarqueeViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/13.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCMarqueeViewController.h"
#import "JCMarqueeControl.h"
#import "UIView+JCLayout.h"
#import "UIFont+JCScale.h"

@interface JCMarqueeViewController ()

@property (nonatomic, strong) JCMarqueeControl *marqueelView1;

@property (nonatomic, strong) JCMarqueeControl *marqueelView2;

@end

@implementation JCMarqueeViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.marqueelView1];
    [self.view addSubview:self.marqueelView2];
    [self layoutSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.marqueelView1.isMarquee = YES;
    self.marqueelView2.isMarquee = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)layoutSubView {
    self.marqueelView1.layoutLeft(20).layoutRight(20).layoutHeight(40).layoutCenterY(0);
//    self.marqueelView1.frame = CGRectMake(20, 300, 335, 40);
    
    self.marqueelView2.layoutLeft(20).layoutRight(20).layoutHeight(40).layoutAtSameLayerBottom(self.marqueelView1,40);
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

- (JCMarqueeControl *)marqueelView1 {
    if (!_marqueelView1) {
        _marqueelView1 = [[JCMarqueeControl alloc] init];
        _marqueelView1.backgroundColor = [UIColor grayColor];
        _marqueelView1.text = @"--跑马灯测试----------跑马灯测试--";
    }
    return _marqueelView1;
}

- (JCMarqueeControl *)marqueelView2 {
    if (!_marqueelView2) {
        _marqueelView2 = [[JCMarqueeControl alloc] init];
        _marqueelView2.font = [UIFont fontNameWithHelveticaOblique:15];
        _marqueelView2.text = @"--跑马灯测试----------跑马灯测试--";
        _marqueelView2.textColor = [UIColor greenColor];
    }
    return _marqueelView2;
}

@end
