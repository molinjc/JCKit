//
//  JCPopupViewController.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCPopupViewController.h"

#import "JCPopupBaseView.h"

@interface JCPopupViewController ()<UITableViewDelegate,
                                    UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *sels;

@end

@implementation JCPopupViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[].mutableCopy;
    self.sels = @[].mutableCopy;
    [self addCell:@"测试showPopupView" sel:@"test_showPopupView"];
    [self addCell:@"popupWithTitle:message:" sel:@"test_popupWithTitle_message"];
    [self addCell:@"popupWithTitle:message:actionTitle1:actionTitle2:" sel:@"test_popupWithTitle_message_2"];
    [self addCell:@"showActivityIndicatorView" sel:@"test_showActivityIndicatorView"];
    [self addCell:@"networkActivityIndicatorVisible" sel:@"test_networkActivityIndicatorVisible"];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)addCell:(NSString *)title sel:(NSString *)selString {
    [self.datas addObject:title];
    [self.sels addObject:selString];
}

- (void)test_showPopupView {
    [JCPopupBaseView showPopupView:@"测试showPopupView"];
}

- (void)test_popupWithTitle_message {
    [JCPopupBaseView popupWithTitle:@"提示" message:@"提示详情"];
}

- (void)test_popupWithTitle_message_2 {
    [JCPopupBaseView popupWithTitle:@"提示" message:@"提示详情" actionTitle1:@"确定" actionTitle2:@"取消"];
}

- (void)test_showActivityIndicatorView {
    JCPopupBaseView *popupView = [JCPopupBaseView showActivityIndicatorView];
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC, 0.00001 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [popupView disappear];
        NSLog(@"dispatch_source_set_event_handler");
    });
    dispatch_resume(timer);
}

- (void)test_networkActivityIndicatorVisible {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;  // 开启菊花转
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL sel = NSSelectorFromString(self.sels[indexPath.row]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:sel];
#pragma clang diagnostic pop
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
