//
//  UIWebView+JCJavaScript.h
//  JCWebAndJS
//
//  Created by molin on 16/5/24.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface UIWebView (JCJavaScript)

@property (nonatomic, strong) JSContext *context;

/**
 *  JavaScript回调，实现OC的方法
 *
 *  @param callback JavaScript中的函数名
 *  @param block    OC要实现的代码
 */
- (void)javaScriptCallback:(NSString *)callback achieved:(void (^)(NSArray *args))block;

/**
 *  JavaScript回调，实现OC的方法
 *
 *  @param callback avaScript中的函数名
 *  @param target   调用者
 *  @param selector 调用者的方法
 */
- (void)javaScriptCallback:(NSString *)callback target:(id)target selector:(SEL)selector;

/**
 *  向JS添加JS代码
 *
 *  @param script JS代码
 *
 *  @return JSValue
 */
- (JSValue *)webViewEvaluateScript:(NSString *)script;

/**
 *  向JS添加JS代码
 *
 *  @param path 路劲
 *
 *  @return JSValue
 */
- (JSValue *)webViewEvaluateScriptWithPath:(NSString *)path;



@end
