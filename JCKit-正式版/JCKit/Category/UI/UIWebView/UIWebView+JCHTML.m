//
//  UIWebView+JCHTML.m
//
//  Created by molin.JC on 2016/12/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIWebView+JCHTML.h"
#import "UIColor+JCColor.h"

@implementation UIWebView (JCHTML)

/** 获取当前网页的URL */
- (NSString *)currentWebURL {
    return [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
}

/** 获取当前网页的标题 */
- (NSString *)currentWebTitle {
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

/** 获取当前网页的所有图片地址 */
- (NSArray *)currentWebAllImageURL {
    NSString *allImageURL = [self stringByEvaluatingJavaScriptFromString:@"var imgArray = document.getElementsByTagName('img'); var imgstr = ''; function f(){ for(var i = 0; i < imgArray.length; i++){ imgstr += imgArray[i].src;imgstr += ';';} return imgstr; } f();"];
    NSArray *imageURLArray = [allImageURL componentsSeparatedByString:@";"];
    return imageURLArray;
}

/** 获取当前网页的图片数量 */
- (NSInteger)currentWebImageNumber {
    NSString *imageNumber = [self stringByEvaluatingJavaScriptFromString:@"var imgArray = document.getElementsByTagName('img');function f(){ var num=imgArray.length;return num;} f();"];
    return [imageNumber integerValue];
}

/** 修改网页的背景颜色 */
- (void)changeWebBackgroundColor:(UIColor *)color {
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.backgroundColor = '%@'",[color stringForRGB16]]];
    
}

@end
