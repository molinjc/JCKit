//
//  UIFont+JCScale.m
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIFont+JCScale.h"
#import "UIScreen+JCScale.h"
#import "NSString+JCString.h"

@implementation UIFont (JCScale)

#pragma maek - 可调用

/// systemFontOfSize:
+ (UIFont *)scaleFontOfSize:(CGFloat)fontSize {
    fontSize *= __scale;
    return [UIFont systemFontOfSize:fontSize];
}

/// fontWithName:size:
+ (UIFont *)scaleFontWithName:(nonnull NSString *)fontName size:(CGFloat)fontSize {
    fontSize *= __scale;
    return [UIFont fontWithName:fontName size:fontSize];
}

@end
