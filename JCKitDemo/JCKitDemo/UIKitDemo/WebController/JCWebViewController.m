//
//  JCWebViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCWebViewController.h"

@interface JCWebViewController ()

@end

@implementation JCWebViewController

- (instancetype)init {
    if (self = [super init]) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)string {
    if (self = [self init]) {
        _urlString = string;
        _url = [NSURL URLWithString:_urlString];
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    _urlString = urlString;
}

- (void)setURL:(NSURL *)url {
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    _url = url;
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
    
    if (!self.title.length) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

@end
