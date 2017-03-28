//
//  UIViewController+JCDealloc.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/3/24.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JCDealloc)

/** 是否打印释放信息 */
@property (nonatomic, assign, readwrite) BOOL logDealloc;

/** 现存的对象 */
- (NSArray *)allExistingViewController;

@end

@interface UIView (JCDealloc)

/** 是否打印释放信息 */
@property (nonatomic, assign, readwrite) BOOL logDealloc;

/** 现存的对象 */
- (NSArray *)allExistingView;

@end
