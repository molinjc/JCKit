//
//  JCTableView.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/3/1.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCTableView.h"

@implementation JCTableViewItem

- (CGFloat)height {
    if (_height <= 0) {
        return 20;
    }
    return _height;
}

@end

@implementation JCTableViewCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    return self;
}

- (void)setDatas:(id)data {
    
}

@end

@interface JCTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation JCTableView

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)_initView {
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCell"];
    }
    return cell;
}

@end
