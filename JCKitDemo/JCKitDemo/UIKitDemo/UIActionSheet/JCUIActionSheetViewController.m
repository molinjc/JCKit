//
//  JCUIActionSheetViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/16.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCUIActionSheetViewController.h"

@interface JCUIActionSheetViewController () <UIActionSheetDelegate>

@end

@implementation JCUIActionSheetViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test1 {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"测试" delegate:self cancelButtonTitle:@"button1" destructiveButtonTitle:@"button2" otherButtonTitles:@"button3",@"...", nil];
    
    [actionSheet showInView:self.view];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex:%zd", buttonIndex);
}

#pragma mark - Setter/Getter(懒加载)

@end
