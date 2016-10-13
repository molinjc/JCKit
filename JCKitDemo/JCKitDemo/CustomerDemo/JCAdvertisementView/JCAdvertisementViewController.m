//
//  JCAdvertisementViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/13.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCAdvertisementViewController.h"
#import "JCAdvertisementView.h"
#import "JCKitMacro.h"

@interface JCAdvertisementViewController ()<JCAdvertisementViewDataSource>

@property (nonatomic, strong) JCAdvertisementView *advertisementView;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation JCAdvertisementViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"]].mutableCopy;
    [self.view addSubview:self.advertisementView];
    
    [self layoutSubview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.advertisementView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)layoutSubview {
    self.advertisementView.frame = self.view.bounds;
}

#pragma mark - Custom Delegate(自定义的代理)

- (NSInteger)numberOfSectionsInAdvertisementView:(JCAdvertisementView *)advertisementView {
    return self.datas.count;
}

- (void)advertisementView:(JCAdvertisementView *)advertisementView imageView:(UIImageView *)imageView forRowAtIndex:(NSInteger)index {
    imageView.image = self.datas[index];
}

- (void)advertisementView:(JCAdvertisementView *)advertisementView didSelectAtIndex:(NSInteger)index {
    JCLog(@"点击了%zd",index);
}

#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

- (JCAdvertisementView *)advertisementView {
    if (!_advertisementView) {
        _advertisementView = [[JCAdvertisementView alloc] initWithDataSource:self];
    }
    return _advertisementView;
}

@end
