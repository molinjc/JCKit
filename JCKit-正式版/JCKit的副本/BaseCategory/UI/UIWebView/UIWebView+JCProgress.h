//
//  UIWebView+JCProgress.h
//
//  Created by molin.JC on 2016/12/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
  注意：如果有设置progress为YES，释放WebView时，要将它置成NO，
       如果有设置delegate，释放WebView时，要将delegate置成nil
 */


@interface UIWebView (JCProgress) 

@property (nonatomic, assign) BOOL progress;

@end
