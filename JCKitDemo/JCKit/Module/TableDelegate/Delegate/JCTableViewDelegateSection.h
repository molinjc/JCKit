//
//  JCTableViewDelegateSection.h
//  56Supplier
//
//  Created by 林建川 on 16/8/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTableViewDelegateBase.h"

#define kSectionHeaderHeight 5.0  // 组头间距
#define KSectionFooterHeight 0.1  // 组尾间距

@interface JCTableViewDelegateSection : JCTableViewDelegateBase

/**
 *  组头间距
 */
- (void)heightForHeaderInSection:(CGFloat (^)(NSInteger section))block;

/**
 *  组尾间距
 */
- (void)heightForFooterInSection:(CGFloat (^)(NSInteger section))block;

@end
