//
//  ViewController.m
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "ViewController.h"
#import "JCKitMacro.h"
#import "NSObject+JCObserverKVO.h"

@interface ViewController ()<UITableViewDelegate,
                             UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation ViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JCKit Example";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self addCell:@"Foundation Example" class:@"JCFoundationExampleViewController"];
    [self addCell:@"UIKit Example" class:@"JCUIKitExampleViewController"];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
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


#pragma mark - Test Methods(测试方法)

/**
 *  测试数组遍历
 */
- (void)test_Array {
    NSArray *array = @[@1,@2,@3,@4,@5];
    
    // NSEnumerationConcurrent：各个Block是同时开始执行的。这样遍历的完成顺序是不确定的
    // NSEnumerationReverse：以反序方式遍历。
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    }];
    
    // 一个个遍历
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        JCLog(@"%zd --%@",idx,obj);
    }];
    
    NSUInteger index = [array indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JCLog(@"%zd --%@",idx,obj);
        if (idx == 3) {
            return YES;
        }
        return NO;
    }];
    
    JCLog(@"%zd",index);
}

@end
