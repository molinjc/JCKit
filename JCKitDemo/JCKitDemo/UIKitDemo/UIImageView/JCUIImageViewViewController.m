//
//  JCUIImageViewViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCUIImageViewViewController.h"
#import "UIImageView+JCImageView.h"

@interface JCUIImageViewViewController ()

@property (nonatomic, strong) UIImageView *imageView1;

@property (nonatomic, strong) UIImageView *imageView2;

@end

@implementation JCUIImageViewViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"up1"];
    
    _imageView1 = UIImageView.new;
    _imageView1.frame = CGRectMake(self.view.frame.size.width / 2 - image.size.width / 2, 65, image.size.width, image.size.height/2);
    _imageView1.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:_imageView1];
    
    _imageView2 = UIImageView.new;
    _imageView2.frame = CGRectMake(self.view.frame.size.width / 2 - image.size.width / 2, 70 + image.size.height, image.size.width, image.size.height/2);
    [self.view addSubview:_imageView2];

    _imageView1.image = image;
    [_imageView2 faceDetectWithImage:image fast:NO];
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
