//
//  JCTouchShowViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/17.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCTouchShowViewController.h"

@interface JCTouchShowViewController ()<UIPreviewActionItem>

@end

@implementation JCTouchShowViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"test1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"点击1");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"test2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"点击2");
    }];
    
    return @[action1, action2];
}

#pragma mark - Setter/Getter(懒加载)

@end
