//
//  JCUIDeviceExampleViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCUIDeviceExampleViewController.h"
#import "UIDevice+JCDevice.h"
#import "NSDate+JCDate.h"

@interface JCUIDeviceExampleViewController ()<UITableViewDelegate,
                                              UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *values;
@end

@implementation JCUIDeviceExampleViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.values = @[].mutableCopy;
    [self.view addSubview:self.tableView];
    [self deviveData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)addCell:(NSString *)title value:(NSString *)className {
    [self.titles addObject:title];
    if (!className) {
        className = @"数据为空";
    }
    [self.values addObject:className];
}

- (void)deviveData {
    UIDevice *device = [UIDevice currentDevice];
    [self addCell:@"系统版本" value:[NSString stringWithFormat:@"%f",[UIDevice systemVersion]]];
    [self addCell:@"iPad设备" value:[NSString stringWithFormat:@"%d",device.isPad]];
    [self addCell:@"模拟器" value:[NSString stringWithFormat:@"%d",device.isSimulator]];
    [self addCell:@"越狱" value:[NSString stringWithFormat:@"%d",device.isJailbroken]];
    [self addCell:@"能打电话" value:[NSString stringWithFormat:@"%d",device.canMakePhoneCalls]];
    [self addCell:@"设备号" value:device.machineModel];
    [self addCell:@"设备名" value:device.machineModelName];
    [self addCell:@"系统启动时间" value:device.systemUptime.string];
    [self addCell:@"WIFI的IP地址" value:device.ipAddressWIFI];
    [self addCell:@"WWAN的IP地址" value:device.ipAddressCell];
    [self addCell:@"磁盘总空间" value:device.sizeString(device.diskSpace)];
    [self addCell:@"空闲的磁盘空间" value:device.sizeString(device.diskSpaceFree)];
    [self addCell:@"使用的磁盘空间" value:device.sizeString(device.diskSpaceUsed)];
    [self addCell:@"总内存" value:device.sizeString(device.memoryTotal)];
    [self addCell:@"使用的内存" value:device.sizeString(device.memoryUsed)];
    [self addCell:@"空闲内存" value:device.sizeString(device.memoryFree)];
    [self addCell:@"使用中内存" value:device.sizeString(device.memoryActive)];
    [self addCell:@"没有被使用的内存" value:device.sizeString(device.memoryInactive)];
    [self addCell:@"系统核心占用的内存" value:device.sizeString(device.memoryWired)];
    [self addCell:@"便携式存储器" value:device.sizeString(device.memoryPurgable)];
    [self.tableView reloadData];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.detailTextLabel.text = _values[indexPath.row];
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
