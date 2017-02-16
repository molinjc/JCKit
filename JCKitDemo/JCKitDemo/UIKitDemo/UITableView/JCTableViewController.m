//
//  JCTableViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/20.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTableViewController.h"
#import "UITableView+JCPlaceholder.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JCTableViewController () <UITableViewDelegate, UITableViewDataSource>
{
    ALAssetsLibrary                  *  _assetsLibray;         //图片库
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation JCTableViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[].mutableCopy;
    
    [self.view addSubview:self.tableView];
    self.tableView.placeholder = @"没有数据";
    self.tableView.placeholderImage = [UIImage imageNamed:@"tabbar_mainframe"];
    __weak typeof(self) _self = self;
    self.tableView.reload = ^(){
        [_self.datas addObject:@"1"];
        [_self.datas addObject:@"2"];
        [_self.datas addObject:@"3"];
        [_self.datas addObject:@"4"];
        [_self.datas addObject:@"5"];
        [_self.tableView reloadData];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"====== %zd",indexPath.row];
    return cell;
}

#pragma mark - Setter/Getter(懒加载)

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
