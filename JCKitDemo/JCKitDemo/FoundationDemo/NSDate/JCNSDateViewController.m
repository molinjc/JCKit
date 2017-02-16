//
//  JCNSDateViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCNSDateViewController.h"
#import "JCLogTextView.h"
#import <StoreKit/StoreKit.h>

@interface JCNSDateViewController () <SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) JCLogTextView *logT;
@end

@implementation JCNSDateViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test {
    /// 时间转时间戳的方法
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [_logT logText:@"%@", timeSp];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSp longLongValue]];
    [_logT logText:@"%@", confromTimesp];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logT = [[JCLogTextView alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width - 20, self.view.frame.size.height - 84)];
    _logT.editable = NO;
    _logT.layer.borderColor = [UIColor blackColor].CGColor;
    _logT.layer.borderWidth = 1;
    [self.view addSubview:_logT];
    
    [self test];
    
    [self openAppWithIdentifier:@"940489630"];
}

- (void)openAppWithIdentifier:(NSString *)appId {
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [self presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - Setter/Getter(懒加载)

@end
