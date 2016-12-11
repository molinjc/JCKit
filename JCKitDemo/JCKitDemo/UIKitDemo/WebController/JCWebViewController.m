//
//  JCWebViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCWebViewController.h"

@interface JCWebViewController () <UIWebViewDelegate>
{
    NSURL     * _url;
    UIWebView * _webView;
}
@end

@implementation JCWebViewController

- (instancetype)initWithURLString:(NSString *)string {
    if (self = [super init]) {
        _urlString = string;
        _url = [NSURL URLWithString:_urlString];
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _webView.frame = self.view.bounds;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7) {
        CGRect frame = _webView.frame;
        frame.size.height -= 44;
        _webView.frame = frame;
    }
    
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - System Delegate(系统类的代理)

//当网页视图已经开始加载一个请求后，得到通知
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//当网页视图结束加载一个请求之后，得到通知
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
