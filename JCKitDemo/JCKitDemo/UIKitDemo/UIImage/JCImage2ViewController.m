//
//  JCImage2ViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCImage2ViewController.h"
#import "UIImage+Vector.h"
@interface JCImage2ViewController ()

@end

@implementation JCImage2ViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test1 {
    UIImageView *imageView1 = UIImageView.new;
    imageView1.frame = CGRectMake(10, 65, self.view.frame.size.width - 20, 200);
    imageView1.image = [UIImage iconWithFont:[UIFont systemFontOfSize:20]
                                       named:@"JC"
                               withTintColor:[UIColor blueColor]
                                clipToBounds:NO
                                     forSize:10];
    [self.view addSubview:imageView1];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
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
