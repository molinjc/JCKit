//
//  UIVisualEffectView+JCVisualEffect.m
//  BlurEffectWithMenu
//
//  Created by molin.JC on 2016/12/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "UIVisualEffectView+JCVisualEffect.h"

@implementation UIVisualEffectView (JCVisualEffect)

+ (UIVisualEffectView *)visualEffectWithEffectStyle:(UIBlurEffectStyle)style {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    return [[UIVisualEffectView alloc] initWithEffect:blurEffect];
}

@end
