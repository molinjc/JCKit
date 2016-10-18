//
//  JCTableViewDelegateHeaderHeight.h
//  56Supplier
//
//  Created by 林建川 on 16/8/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTableViewDelegateBase.h"

#define kHeaderHeight 5.0  // 组头间距

@interface JCTableViewDelegateHeaderHeight : JCTableViewDelegateBase

/**
 *  设置组头高度
 */
- (void)heightForHeaderInBlock:(CGFloat (^)(NSInteger section))block;

@end
