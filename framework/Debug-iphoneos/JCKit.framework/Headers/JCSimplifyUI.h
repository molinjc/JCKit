//
//  JCSimplifyUI.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/2/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 简化AppDelegate里的window的初始化
 
 @param rootViewController 根视图
 @param backgroundColor 背景颜色
 */
#define JCAppDelegate_window(root, color) \
self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];\
self.window.rootViewController = root;\
self.window.backgroundColor = color;\
[self.window makeKeyAndVisible];

#pragma mark - 视图初始化宏

#define VIEW                         [[UIView alloc] init]
#define LABEL                        [[UILabel alloc] init]
#define IMAGEVIEW                    [[UIImageView alloc] init]
#define TEXTVIEW                     [[UITextView alloc] init]
#define TEXTFIELD                    [[UITextField alloc] init]
#define VIEWCONTROLLER               [[UIViewController alloc] init]
#define BUTTON(type)                 [UIButton buttonWithType:type]
#define WEBVIEW                      [[UIWebView alloc] init]
#define CONTROL                      [[UIControl alloc] init]
#define FONT(size)                   [UIFont systemFontOfSize:size]
#define SCREEN                       [UIScreen mainScreen]
#define DEVICE                       [UIDevice currentDevice]
#define APPLICATION                  [UIApplication sharedApplication]
#define TABLEVIEWCELL(style, reuse)  [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuse]
#define GESTURERECOGNIZER            [[UIGestureRecognizer alloc] init]
#define NACIGATIONCONTROLLER(root)   [[UINavigationController alloc] initWithRootViewController:root]
#define VISUALEFFECTVIEW(effect)     [[UIVisualEffectView alloc] initWithEffect:effect]
#define TABLEVIEW                    [[UITableView alloc] init]
#define NAVIGATIONITEM               [[UINavigationItem alloc] init]
#define RESPONDER                    [UIResponder nextResponder]
#define LAYER                        [[CALayer alloc] init]

#pragma mark - 视图初始化方法，集中设置

#define FocusUI_Init_H(className) \
@interface className (JCFocus)\
+ (instancetype)focus##className##Init:(void (^)(className *ins))focus;\
@end

FocusUI_Init_H(UIView)
FocusUI_Init_H(UILabel)
FocusUI_Init_H(UITableView)
FocusUI_Init_H(UIImageView)
FocusUI_Init_H(UIControl)
FocusUI_Init_H(UICollectionView)
FocusUI_Init_H(UITextView)
FocusUI_Init_H(UITextField)
FocusUI_Init_H(UISwitch)
FocusUI_Init_H(UIScrollView)
FocusUI_Init_H(UIButton)
