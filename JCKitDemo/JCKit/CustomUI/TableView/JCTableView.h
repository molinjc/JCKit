//
//  JCTableView.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/3/1.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCTableViewItem : NSObject
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat height;
@end

@interface JCTableViewCell1 : UITableViewCell

- (void)setDatas:(JCTableViewItem *)data;

@end

@interface JCTableView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@end
