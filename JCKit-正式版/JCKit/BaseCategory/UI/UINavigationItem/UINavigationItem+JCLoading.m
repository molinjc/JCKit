//
//  UINavigationItem+JCLoading.m
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UINavigationItem+JCLoading.h"
#import <objc/runtime.h>

static void *kLoading = &kLoading;

@implementation UINavigationItem (JCLoading)

- (void)startLoadingAnimating {
    [self stopLoadingAnimating];
    objc_setAssociatedObject(self, kLoading, self.titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIActivityIndicatorView* loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.titleView = loader;
    [loader startAnimating];
}

- (void)stopLoadingAnimating {
    id componentToRestore = objc_getAssociatedObject(self, kLoading);
    self.titleView = componentToRestore;
    objc_setAssociatedObject(self, kLoading, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
