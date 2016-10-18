//
//  JCTableViewDelegateHeaderHeight.m
//  56Supplier
//
//  Created by 林建川 on 16/8/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTableViewDelegateHeaderHeight.h"

@interface JCTableViewDelegateHeaderHeight ()

@property (nonatomic, copy) CGFloat (^heightForHeaderBlock)(NSInteger section);

@end

@implementation JCTableViewDelegateHeaderHeight

- (void)heightForHeaderInBlock:(CGFloat (^)(NSInteger section))block {
    self.heightForHeaderBlock = block;
}

#pragma mark - delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.heightForHeaderBlock) {
        return self.heightForHeaderBlock(section);
    }
    return kHeaderHeight;
}

/**
 *  设置组头的颜色
 */
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = tableView.backgroundColor;
}


@end
