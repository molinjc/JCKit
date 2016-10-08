//
//  JCFontViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/30.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCFontViewController.h"

@interface JCFontViewController ()<UITableViewDelegate,
                                   UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@end

@implementation JCFontViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    [self.view addSubview:self.tableView];
    [self getAllFont];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)getAllFont {
    NSArray *array = [UIFont familyNames];
    NSString *familyName ;
    for(familyName in array){
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        [self.titles addObjectsFromArray:names];
    }
    NSLog(@"%@",self.titles);
    [self.tableView reloadData];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:_titles[indexPath.row] size:14];
    return cell;
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
