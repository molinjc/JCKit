//
//  JCUIKitExampleViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCUIKitExampleViewController.h"
#import "JCWebViewController.h"

#import "UIColor+JCColor.h"

@interface JCUIKitExampleViewController ()<UITableViewDelegate,
                                           UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

@end

@implementation JCUIKitExampleViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self addCell:@"UIDevice Example" class:@"JCUIDeviceExampleViewController"];
    [self addCell:@"UIFont" class:@"JCFontViewController"];
    [self addCell:@"UIImage" class:@"JCImageViewController"];
    [self addCell:@"Recognizer" class:@"JCRecognizerViewController"];
    [self addCell:@"UITextField" class:@"JCTextFieldViewController"];
    [self addCell:@"JCWebViewController" class:@"JCWebViewController"];
    [self addCell:@"MVP的V与P之间的通信" class:@"JCMVPViewController"];
    [self addCell:@"UIPasteboard" class:@"JCUIPasteboardViewController"];
    [self addCell:@"动画" class:@"JCAnimationViewController"];
    [self.view addSubview:self.tableView];
    
    NSString *j = @"12";
    int i = strcmp(@encode(__typeof__((j))), @encode(NSString));
    NSLog(@"====:%d;",i);
    
    
    UIColor *color = [UIColor redColor];
    NSLog(@"====:%@",[color stringForRGB16]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear:%@",self.navigationController.viewControllers);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear:%@",self.navigationController.viewControllers);
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

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
        
        if ([className isEqualToString:@"JCWebViewController"]) {
            JCWebViewController *ctrl = [[JCWebViewController alloc] initWithURLString:@"http://www.baidu.com"];
            ctrl.title = _titles[indexPath.row];
            [self.navigationController pushViewController:ctrl animated:YES];
        }else {
            UIViewController *ctrl = class.new;  // 也可以用[class new],把类给UIViewController
            ctrl.title = _titles[indexPath.row];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
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
