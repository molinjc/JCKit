//
//  JCWebViewController.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCWebViewController : UIViewController

@property (nonatomic, copy) NSString *urlString;

- (instancetype)initWithURLString:(NSString *)string;

@end
