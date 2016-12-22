//
//  UIResponder+JCResponder.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIResponder+JCResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (JCResponder)

/**
 获取当前第一响应者
 */
+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findCurrentFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findCurrentFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
