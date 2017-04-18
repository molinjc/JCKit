//
//  UITableView+JCPlaceholder.h
//
//  Created by molin.JC on 2016/12/20.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JCPlaceholder)

//**********************************
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) void (^reload)();
//**********************************

/// 使用外部自定义占位View，那上面三个属性就不能用了
@property (nonatomic, strong) UIView *customPlaceholderView;

@end

@interface UITableView (JCTableView)

- (void)updateWithBlock:(void (^)(UITableView *tableView))block;

@end
