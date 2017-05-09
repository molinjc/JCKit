//
//  UIWebView+JCHTML.h
//
//  Created by molin.JC on 2016/12/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JCHTML)

/** 获取当前网页的URL */
- (NSString *)currentWebURL;

/** 获取当前网页的标题 */
- (NSString *)currentWebTitle;

/** 获取当前网页的所有图片地址 */
- (NSArray *)currentWebAllImageURL;

/** 获取当前网页的图片数量 */
- (NSInteger)currentWebImageNumber;

/** 修改网页的背景颜色 */
- (void)changeWebBackgroundColor:(UIColor *)color;

@end
