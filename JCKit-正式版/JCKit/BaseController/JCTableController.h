//
//  JCTableController.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/3/17.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/** TableView的实现，代理方法可由子类去实现 */
@interface JCTableController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

/** tableView的数据 */
@property (nonatomic, strong) NSMutableArray *datas;

/** 重新加载 */
- (void)reloadData;

/** 隐藏cell的分割线 */
- (void)hiddenTableViewCellSeparator;

/** 隐藏tableView尾部视图(包括cell的分割线) */
- (void)hiddenTableViewCellFooter;

/** 点击了TableView，由子类去实现 */
- (void)clickTableView;

@end
