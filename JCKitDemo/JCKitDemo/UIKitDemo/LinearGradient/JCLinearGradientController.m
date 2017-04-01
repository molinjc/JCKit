//
//  JCLinearGradientController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/3/31.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCLinearGradientController.h"
#import "UILabel+JCLabel.h"
#import "UIImage+JCImage.h"
#import "UIImageView+JCImageView.h"

@interface JCLinearGradientController ()

@end

#define UIColorFronHSB(h,s,b)               [UIColor colorWithHue:h saturation:s brightness:b alpha:1.0f]

@implementation JCLinearGradientController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)_lableInit {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 70, self.view.frame.size.width, 30);
    label.text = @"测试直线渐变测试直线渐变测试直线渐变测试直线渐变测试直线渐变";
    [self.view addSubview:label];
    [label setLinearGradientWithColor:@[[UIColor blueColor], [UIColor greenColor], [UIColor redColor]]];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(20, 110, 300, 30);
    label1.text = @"测试直线渐变测试直线渐变测试直线渐变测试直线渐变测试直线渐变";
    [self.view addSubview:label1];
    [label1 setGradientChromatoAnimation:@[@[UIColorFronHSB(0.63, 0.69, 0.88),
                                             UIColorFronHSB(0.75, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.73, 0.69, 0.88),
                                             UIColorFronHSB(0.85, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.83, 0.69, 0.88),
                                             UIColorFronHSB(0.95, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.88, 0.69, 0.88),
                                             UIColorFronHSB(1, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.98, 0.69, 0.88),
                                             UIColorFronHSB(0.1, 0.69, 0.88)],
                                           @[UIColorFronHSB(1, 0.69, 0.88),
                                             UIColorFronHSB(0.12, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.1, 0.69, 0.88),
                                             UIColorFronHSB(0.22, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.2, 0.69, 0.88),
                                             UIColorFronHSB(0.32, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.3, 0.69, 0.88),
                                             UIColorFronHSB(0.42, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.4, 0.69, 0.88),
                                             UIColorFronHSB(0.52, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.5, 0.69, 0.88),
                                             UIColorFronHSB(0.62, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.6, 0.69, 0.88),
                                             UIColorFronHSB(0.72, 0.69, 0.88)],
                                           @[UIColorFronHSB(0.63, 0.69, 0.88),
                                             UIColorFronHSB(0.75, 0.69, 0.88)]]];
}

- (void)_imageInit {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(20, 150, 300, 40);
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageLinearGradientWithColors:@[[UIColor blueColor], [UIColor greenColor]] directionType:JCLinearGradientDirectionLevel size:CGSizeMake(300, 40)];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(20, 200, 300, 50);
    [self.view addSubview:imageView2];
    imageView2.image = [UIImage imageLinearGradientWithColors:@[UIColorFronHSB(0.63, 0.69, 0.88), UIColorFronHSB(0.75, 0.69, 0.88)] directionType:JCLinearGradientDirectionLevel size:CGSizeMake(300, 50)];
    [imageView2 gradientChromatoAnimationWithColors:@[@[UIColorFronHSB(0.63, 0.69, 0.88),
                                                       UIColorFronHSB(0.75, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.73, 0.69, 0.88),
                                                       UIColorFronHSB(0.85, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.83, 0.69, 0.88),
                                                       UIColorFronHSB(0.95, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.88, 0.69, 0.88),
                                                       UIColorFronHSB(1, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.98, 0.69, 0.88),
                                                       UIColorFronHSB(0.1, 0.69, 0.88)],
                                                     @[UIColorFronHSB(1, 0.69, 0.88),
                                                       UIColorFronHSB(0.12, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.1, 0.69, 0.88),
                                                       UIColorFronHSB(0.22, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.2, 0.69, 0.88),
                                                       UIColorFronHSB(0.32, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.3, 0.69, 0.88),
                                                       UIColorFronHSB(0.42, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.4, 0.69, 0.88),
                                                       UIColorFronHSB(0.52, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.5, 0.69, 0.88),
                                                       UIColorFronHSB(0.62, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.6, 0.69, 0.88),
                                                       UIColorFronHSB(0.72, 0.69, 0.88)],
                                                     @[UIColorFronHSB(0.63, 0.69, 0.88),
                                                       UIColorFronHSB(0.75, 0.69, 0.88)]]];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _lableInit];
    [self _imageInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"JCLinearGradientController -- dealloc");
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
