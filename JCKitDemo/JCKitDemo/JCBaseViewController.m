//
//  JCBaseViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCBaseViewController.h"

@interface JCBaseViewController ()<UITableViewDelegate,
                                   UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;


@end

@implementation JCBaseViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

#pragma mark - UITableViewDataSource or UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className); // 根据给定的类名创建一个类
    if (class) {
        UIViewController *ctrl = class.new;  // 也可以用[class new],把类给UIViewController
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setter/Getter(懒加载)

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
