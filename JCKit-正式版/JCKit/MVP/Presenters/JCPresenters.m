//
//  JCPresenters.m
//
//  Created by molin.JC on 2017/3/23.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCPresenters.h"

@implementation JCPresenters

+ (instancetype)presenters {
    return [[self alloc] init];
}

- (JCSignal *)signal {
    if (!_signal) {
        _signal = [JCSignal signal];
    }
    return _signal;
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", [self class]);
}

@end

@implementation JCViewControllerPresenters

@synthesize viewController, pushController;

+ (instancetype)presentersWithViewController:(UIViewController *)viewController {
    JCViewControllerPresenters *presenter = [self presenters];
    presenter.viewController = viewController;
    presenter.pushController = viewController.navigationController ? viewController.navigationController : viewController.tabBarController.navigationController;
    return presenter;
}

- (void)pushViewControllerWithModel:(id)model {}

- (void)pushViewControllerWithClassName:(NSString *)name {
    Class class = NSClassFromString(name);
    
    if (class) {
        UIViewController *ctrl = class.new;
        [self.pushController pushViewController:ctrl animated:YES];
    }
}

@end
