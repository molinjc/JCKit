//
//  JC3DTouchViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/17.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JC3DTouchViewController.h"
#import "JCTouchShowViewController.h"

@interface JC3DTouchViewController () <UIViewControllerPreviewingDelegate>

@end

@implementation JC3DTouchViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test1 {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    view.frame = CGRectMake(10, 65, self.view.frame.size.width - 20, 200);
    [self.view addSubview:view];
    [self registerForPreviewingWithDelegate:self sourceView:view];
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

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    JCTouchShowViewController *viewController = [[JCTouchShowViewController alloc] init];
    viewController.preferredContentSize = CGSizeMake(100, 100);
    
//    previewingContext.sourceRect = CGRectMake(10, location.y - 10, self.view.frame.size.width - 20, 100);
    return viewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
}

#pragma mark - Setter/Getter(懒加载)

@end
