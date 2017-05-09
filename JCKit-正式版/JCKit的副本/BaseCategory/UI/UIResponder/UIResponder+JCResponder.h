//
//  UIResponder+JCResponder.h
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (JCResponder)

/**
 获取当前第一响应者
 */
+ (id)currentFirstResponder;

@end
