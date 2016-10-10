//
//  JCCustomerDemoViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCCustomerDemoViewController.h"

@interface JCCustomerDemoViewController ()

@end

@implementation JCCustomerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCell:@"JCPopupBaseView" class:@"JCPopupViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
