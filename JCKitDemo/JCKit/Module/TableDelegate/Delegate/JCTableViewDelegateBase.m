//
//  JCTableViewDelegateBase.m
//  56Supplier
//
//  Created by 林建川 on 16/8/26.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTableViewDelegateBase.h"

@interface JCTableViewDelegateBase ()

/**
 *  block属性
 */

@property (nonatomic, copy) void (^didSelectRowBlock)(UITableView *tableView, NSIndexPath *indexPath, id data);

@property (nonatomic, copy) UITableViewCell *(^cellForRowBlock)(id, NSIndexPath *indexPath, id data);

@property (nonatomic, copy) CGFloat (^cellHeightBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^beginDraggingBlock)();

@property (nonatomic, copy) void (^endDraggingBlock)();

@end

@implementation JCTableViewDelegateBase

#pragma mark - 外部使用（block）

/**
 *  选中某行
 */
- (void)didSelectRowAtBlock:(void (^)(UITableView *, NSIndexPath *, id data))block {
    self.didSelectRowBlock = block;
}

/**
 *  设置cell内容
 */
- (void)cellForRowAtIndexPath:(UITableViewCell *(^)(id, NSIndexPath *, id))block {
    self.cellForRowBlock = block;
}

/**
 *  设置cell高度
 */
- (void)cellHeightAtIndexPath:(CGFloat (^)(NSIndexPath *))block {
    self.cellHeightBlock = block;
}

/**
 *  开始拖拉
 */
- (void)tableViewWillBeginDragging:(void (^)())block {
    self.beginDraggingBlock = block;
}

/**
 *  结束拖拉
 */
- (void)tableViewEndDragging:(void (^)())block {
    self.endDraggingBlock = block;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.style == UITableViewStyleGrouped) {
        return self.datas.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.style == UITableViewStyleGrouped) {
        NSArray *array = self.datas[section];
        if (array) {
            return array.count;
        }
        return 0;
    }
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [tableView dequeueReusableCellWithIdentifier:kCELLIDENTIFIER];
    id data = nil;
    
    if (tableView.style == UITableViewStyleGrouped) {
        data = self.datas[indexPath.section][indexPath.row];
    }else {
        data = self.datas[indexPath.row];
    }
    
    if (self.cellForRowBlock) {
      return self.cellForRowBlock(cell,indexPath,data);
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCELLIDENTIFIER];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellHeightBlock) {
        return self.cellHeightBlock(indexPath);
    }
    return kCELLHEIGHT;
}

#pragma mark - JCTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id data = nil;
    
    if (tableView.style == UITableViewStyleGrouped) {
        data = self.datas[indexPath.section][indexPath.row];
    }else {
        data = self.datas[indexPath.row];
    }
    
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(tableView,indexPath, data);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.beginDraggingBlock) {
        self.beginDraggingBlock();
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.endDraggingBlock) {
        self.endDraggingBlock();
    }
}

#pragma mark - Set/Get

- (void)setDatas:(NSMutableArray *)datas {
    _datas = nil;
    _datas = datas.mutableCopy;
}

@end
