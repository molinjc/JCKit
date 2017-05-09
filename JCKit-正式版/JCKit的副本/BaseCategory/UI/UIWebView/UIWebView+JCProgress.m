//
//  UIWebView+JCProgress.m
//
//  Created by molin.JC on 2016/12/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIWebView+JCProgress.h"
#import "UIView+JCView.h"
#import <objc/runtime.h>

@class _JCWebViewProgressView;

static void *kProgress                = &kProgress;
const float kInitialProgressValue     = 0.1f;
const float kInteractiveProgressValue = 0.5f;
const float kFinalProgressValue       = 0.9f;
NSString *kCompleteRPCURLPath         = @"/jcwebviewprogressproxy/complete";

@interface _JCWebViewProgressView : UIView
@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

@implementation _JCWebViewProgressView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureViews];
}

-(void)configureViews {
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]; // iOS7 Safari bar color
    if ([UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(setTintColor:)] && UIApplication.sharedApplication.delegate.window.tintColor) {
        tintColor = UIApplication.sharedApplication.delegate.window.tintColor;
    }
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

-(void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        _progressBarView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = _progressBarView.frame;
            frame.size.width = 0;
            _progressBarView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

@end

@interface _JCWebViewProgress : NSObject <UIWebViewDelegate>
@property (nonatomic, weak) id<UIWebViewDelegate> webViewProxyDelegate;
@property (nonatomic, readonly) float progress;  // 0.0..1.0
@property (nonatomic, copy) void (^progressBlock)(float);
@end

@implementation _JCWebViewProgress
{
    NSUInteger _loadingCount;
    NSUInteger _maxLoadCount;
    NSURL *_currentURL;
    BOOL _interactive;
}

- (instancetype)init {
    if (self = [super init]) {
        _maxLoadCount = _loadingCount = 0;
        _interactive = NO;
    }
    return self;
}

- (void)startProgress {
    if (_progress < kInitialProgressValue) {
        [self setProgress:kInitialProgressValue];
    }
}

- (void)setProgress:(float)progress {
    if (progress > _progress || progress == 0) {
        _progress = progress;
        if (_progressBlock) {
            _progressBlock(_progress);
        }
    }
}

- (void)incrementProgress {
    float progress = self.progress;
    float maxProgress = _interactive ? kFinalProgressValue : kInteractiveProgressValue;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress {
    [self setProgress:1.0];
}

- (void)reset {
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.path isEqualToString:kCompleteRPCURLPath]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL ret = YES;
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTPOrLocalFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    if (ret && !isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        _currentURL = request.URL;
        [self reset];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewProxyDelegate webViewDidStartLoad:webView];
    }
    
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self startProgress];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, kCompleteRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, kCompleteRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if ((complete && isNotRedirect) || error) {
        [self completeProgress];
    }
}

@end

@implementation UIWebView (JCProgress)

+ (void)load {
    @autoreleasepool {// 对象方法的交换
        Method sysIMethod = class_getInstanceMethod(self, @selector(setDelegate:));
        Method cusIMethod = class_getInstanceMethod(self, @selector(_setDelegate:));
        method_exchangeImplementations(sysIMethod, cusIMethod);
    }
}

- (void)addProgressView {
    CGFloat progressBarHeight = 2.f;
    UIViewController *viewControlller = [self viewController];
    CGRect navigationBarBounds = viewControlller.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    
    _JCWebViewProgressView *_progressView = [[_JCWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [viewControlller.navigationController.navigationBar addSubview:_progressView];
    
    objc_setAssociatedObject(self, _cmd, _progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    _JCWebViewProgress *_webViewProgress = objc_getAssociatedObject(self, kProgress);
    
    __weak typeof(_progressView) __progressView = _progressView;
    _webViewProgress.progressBlock = ^(float progress) {
        [__progressView setProgress:progress animated:YES];
    };
}

- (void)setProgress:(BOOL)progress {
    NSNumber *number = [NSNumber numberWithBool:progress];
    objc_setAssociatedObject(self, @selector(progress), number, OBJC_ASSOCIATION_ASSIGN);
    
    if (progress) {
        _JCWebViewProgress *_webViewProgress = [[_JCWebViewProgress alloc] init];
        objc_setAssociatedObject(self, kProgress, _webViewProgress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self _setDelegate:_webViewProgress];
        [self addProgressView];
    }else {
        _JCWebViewProgressView *_progressView = objc_getAssociatedObject(self, @selector(addProgressView));
        if (_progressView) {
            [_progressView removeFromSuperview];
            objc_setAssociatedObject(self, @selector(addProgressView), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [self _setDelegate:nil];
    }
}

- (BOOL)progress {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)_setDelegate:(id<UIWebViewDelegate>)delegate {
    _JCWebViewProgress *_webViewProgress = objc_getAssociatedObject(self, kProgress);
    if (_webViewProgress) {
        if (delegate) {
            _webViewProgress.webViewProxyDelegate = delegate;
            [self _setDelegate:_webViewProgress];
        }else {
            _webViewProgress = nil;
            objc_setAssociatedObject(self, kProgress, _webViewProgress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self _setDelegate:nil];
        }
    }else {
        [self _setDelegate:delegate];
    }
}

@end
