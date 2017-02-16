//
//  JCLogBaseViewController.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLogTextView.h"

#define _Log(string, ...) [self.logTextView logText:[NSString stringWithFormat:(string), ##__VA_ARGS__]]

@interface JCLogBaseViewController : UIViewController

@property (nonatomic, strong) JCLogTextView *logTextView;

@end
