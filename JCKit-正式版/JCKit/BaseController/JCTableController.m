//
//  JCTableController.m
//
//  Created by molin.JC on 2017/3/17.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCTableController.h"

@interface JCTableController ()

@end

@implementation JCTableController

#pragma mark - Custom Methods(自定义方法，外部可调用)

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)hiddenTableViewCellSeparator {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)hiddenTableViewCellFooter {
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)clickTableView {}

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)_jc_tableViewInit {
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;  // UIScrollView拖动的时候键盘消失
    [self.view addSubview:_tableView];
    _tableView.frame = self.view.bounds;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTableView)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = @[].mutableCopy;
    [self _jc_tableViewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

#pragma mark - Setter/Getter(懒加载)

@end
