//
//  UIWebView+JCJavaScript.m
//  JCWebAndJS
//
//  Created by molin on 16/5/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIWebView+JCJavaScript.h"
#import <objc/runtime.h>

static const void *kJCJavaScript_JSContext = &kJCJavaScript_JSContext;

@implementation UIWebView (JCJavaScript)

@dynamic context;

- (void)javaScriptCallback:(NSString *)callback achieved:(void (^)(NSArray *args))block {
    self.context[callback] = ^(){
        NSArray *args = [JSContext currentArguments];
        block(args);
    };
}

- (void)javaScriptCallback:(NSString *)callback target:(nullable id)target selector:(SEL)selector {
    self.context[callback] = ^(){
        id obj;
        if (target == nil) {
            obj = self;
        }else {
            obj = target;
        }
        if ([obj respondsToSelector:selector]) {
            [obj performSelector:selector withObject:obj];
        }
    };
}

- (JSValue *)webViewEvaluateScript:(NSString *)script {
    JSValue *value = [self.context evaluateScript:script];
    return value;
}

- (JSValue *)webViewEvaluateScriptWithPath:(NSString *)path {
    if (!path.length) {
        return nil;
    }
    NSData *js_data = [NSData dataWithContentsOfFile:path];
    NSString *js_string = [[NSString alloc] initWithData:js_data encoding:NSUTF8StringEncoding];
    JSValue *value = [self.context evaluateScript:js_string];
    return value;
}



- (void)setContext:(JSContext *)context {
    objc_setAssociatedObject(self, kJCJavaScript_JSContext, context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JSContext *)context {
    JSContext *context = objc_getAssociatedObject(self, kJCJavaScript_JSContext);
    if (!context) {
        context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; // 获取web的JavaScript的环境
        self.context = context;
    }
    return context;
}

@end
