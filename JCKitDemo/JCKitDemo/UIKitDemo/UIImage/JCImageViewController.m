//
//  JCImageViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 16/10/17.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCImageViewController.h"
#import "UIImage+JCImage.h"
#import "UIView+JCView.h"

@interface JCImageViewController ()

@property (nonatomic, strong) UIImageView *imageViewGIF;

@property (nonatomic, strong) UIImageView *imageViewText;

@end


@implementation JCImageViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageViewGIF];
    self.imageViewGIF.image = [UIImage animatedGIFNamed:@"waiting.gif"];
    
    [self.view addSubview:self.imageViewText];
    self.imageViewText.image = [[UIImage imageNamed:@"1"] imageWithText:@"图片上绘制文字" fontSize:15];
    
    [self layoutSubview];
    [self addButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)layoutSubview {
    self.imageViewGIF.frame = CGRectMake(0, 64, self.imageViewGIF.image.size.width, self.imageViewGIF.image.size.height);
    self.imageViewText.frame = CGRectMake(0, self.imageViewGIF.frame.size.height + 74, self.view.frame.size.width, 300);
}

- (void)addButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, self.view.frame.size.height - 70, 100, 50);
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonEvent:(id)sender {
    self.imageViewText.image = [self.view snapshotImageAfterScreenUpdates:NO];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

- (UIImageView *)imageViewGIF {
    if (!_imageViewGIF) {
        _imageViewGIF = [[UIImageView alloc] init];
        _imageViewGIF.backgroundColor = [UIColor grayColor];
    }
    return _imageViewGIF;
}

- (UIImageView *)imageViewText {
    if (!_imageViewText) {
        _imageViewText = [[UIImageView alloc] init];
    }
    return _imageViewText;
}

@end
