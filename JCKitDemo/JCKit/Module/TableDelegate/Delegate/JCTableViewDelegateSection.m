//
//  JCTableViewDelegateSection.m
//  56Supplier
//
//  Created by 林建川 on 16/8/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTableViewDelegateSection.h"

@interface JCTableViewDelegateSection ()

@property (nonatomic, copy) CGFloat (^heightForHeaderAtBlock)(NSInteger);

@property (nonatomic, copy) CGFloat (^heightForFooterAtBlock)(NSInteger);

@end

@implementation JCTableViewDelegateSection

- (void)heightForHeaderInSection:(CGFloat (^)(NSInteger))block {
    self.heightForHeaderAtBlock = block;
}

- (void)heightForFooterInSection:(CGFloat (^)(NSInteger))block {
    self.heightForFooterAtBlock = block;
}

#pragma amrk - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.heightForHeaderAtBlock) {
        return self.heightForHeaderAtBlock(section);
    }
    return kSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.heightForFooterAtBlock) {
        return self.heightForFooterAtBlock(section);
    }
    return KSectionFooterHeight;
}

@end
