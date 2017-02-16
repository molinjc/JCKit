//
//  JCUISearchBarViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCUISearchBarViewController.h"

@interface JCUISearchBarViewController ()
{
//    UISearchBar *_searchBar;
}
@end

@implementation JCUISearchBarViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test1 {
    UISearchBar * bar = [[UISearchBar alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 250) * 0.5 , 100, 250, 40)];
    [self.view addSubview:bar];
    
//    bar.prompt = @"搜索框";
    bar.placeholder = @"占位符";
    bar.showsBookmarkButton = YES;
    
   // 这一对方法用于获取和设置附加选择按钮视图中切换按钮的图案
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
