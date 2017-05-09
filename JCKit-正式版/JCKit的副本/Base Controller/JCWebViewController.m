//
//  JCWebViewController.m
//
//  Created by molin.JC on 2017/3/29.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCWebViewController.h"

@interface JCWebViewController ()

@end

@implementation JCWebViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

- (void)loadURLWithString:(NSString *)string {
    [self loadURL:[NSURL URLWithString:string]];
}

- (void)loadURL:(NSURL *)url {
    [self loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

- (void)loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string {
    [self.webView loadHTMLString:string baseURL:nil];
}

- (void)loadForResource:(NSString *)resource {
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:nil];
    [self loadURL:url];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate

/** 当网页视图已经开始加载一个请求后，得到通知 */
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/** 当网页视图结束加载一个请求之后，得到通知 */
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 设置标题
    BOOL showWebTitle = !self.title.length ? (!self.tabBarItem.title.length ? YES:NO) : NO;
    if (showWebTitle) {
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

/** 当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {}

#pragma mark - Setter/Getter(懒加载)

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
    }
    return _webView;
}

@end
