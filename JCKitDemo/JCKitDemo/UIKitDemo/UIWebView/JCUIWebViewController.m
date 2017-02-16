//
//  JCUIWebViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCUIWebViewController.h"
#import "UIWebView+JCProgress.h"

@interface JCUIWebViewController () <UIWebViewDelegate>
{
    CGFloat _loadingCount;
    NSUInteger _maxLoadCount;
    NSURL *_currentURL;
    BOOL _interactive;
}
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation JCUIWebViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)_initWebView {
    
    _maxLoadCount = _loadingCount = 0;
    
    _webView = UIWebView.new;
    _webView.frame = self.view.bounds;
    [self.view addSubview:_webView];
//    _webView.delegate = self;
    [_webView setProgress:YES];
}

- (void)_initProgressView {
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:_progressView];
    _progressView.frame = CGRectMake(0, 65, self.view.frame.size.width, 5);
}

- (void)animate {
    [UIView animateWithDuration:0.2 animations:^{
        _loadingCount += 0.1;
       [ _progressView setProgress:_loadingCount animated:NO];
        NSLog(@"====== %f", _loadingCount);
    } completion:^(BOOL finished) {
        if (_loadingCount <= 1) {
            [self animate];
        }
    }];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initWebView];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://baidu.com"]];
    [_webView loadRequest:req];
    
//    [self _initProgressView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _webView.progress = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - System Delegate(系统类的代理)

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - Setter/Getter(懒加载)

@end
