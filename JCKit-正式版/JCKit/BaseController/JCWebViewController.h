//
//  JCWebViewController.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/3/29.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCWebViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

- (void)loadURLWithString:(NSString *)string;

- (void)loadURL:(NSURL *)url;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)string;

/** 加载本地资源, resource为文件名(name.type) */
- (void)loadForResource:(NSString *)resource;

@end
