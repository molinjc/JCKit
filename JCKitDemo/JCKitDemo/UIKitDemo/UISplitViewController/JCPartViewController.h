//
//  JCPartViewController.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/1/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCPartViewController : UIViewController

@property (nonatomic, strong) NSArray<UIViewController *> *partViewControllers;

- (void)addViewController:(UIViewController *)viewController;

@end
