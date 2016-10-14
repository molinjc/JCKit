//
//  UIAlertView+JCStream.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (JCStream)

@property (nonatomic, copy) void (^clickedButtonBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@end
