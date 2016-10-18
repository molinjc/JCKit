//
//  JCTableViewDelegateBase.h
//  56Supplier
//
//  Created by 林建川 on 16/8/26.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kCELLHEIGHT 25.0         // cell的高度
#define kCELLIDENTIFIER @"cell"  // cell标识符

@interface JCTableViewDelegateBase : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datas;

/**
 *  选中某行
 */
- (void)didSelectRowAtBlock:(void (^)(UITableView *tableView, NSIndexPath *indexPath, id data))block;

/**
 *  设置cell内容
 */
- (void)cellForRowAtIndexPath:(UITableViewCell *(^)(id cell, NSIndexPath *indexPath, id data))block;

/**
 *  设置cell高度
 */
- (void)cellHeightAtIndexPath:(CGFloat (^)(NSIndexPath *indexPath))block;

/**
 *  开始拖拉
 */
- (void)tableViewWillBeginDragging:(void (^)())block;

/**
 *  结束拖拉
 */
- (void)tableViewEndDragging:(void (^)())block;

@end
