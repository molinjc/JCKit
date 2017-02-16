//
//  JCGetPhotoViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCGetPhotoViewController.h"
#import "JCPhotoLibrary.h"
#import "JCPhotoGroupCollectionController.h"


@interface JCGetPhotoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) JCPhotoLibrary *photoLibrary;

@end

@implementation JCGetPhotoViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (instancetype)init {
    if (self = [super init]) {
        _photoLibrary = [[JCPhotoLibrary alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_photoLibrary photoGroup:^(NSArray<JCPhotoGroup *> *photos, NSError * error) {
        if (error) {
            NSLog(@"未授权");
        }else {
            _datas = photos.mutableCopy;
            [_tableView reloadData];
        }
    }];
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
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    if (!_datas || _datas.count == 0) {
        return cell;
    }
    
    JCPhotoGroup *photoGroup = _datas[indexPath.row];
    cell.imageView.image = photoGroup.posterImage;
    cell.textLabel.text = photoGroup.groupName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JCPhotoGroup *photoGroup = _datas[indexPath.row];
    JCPhotoGroupCollectionController *photoGroupCollectionController = [[JCPhotoGroupCollectionController alloc] initWithPhotoGroup:photoGroup];
    [self.navigationController pushViewController:photoGroupCollectionController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark - Setter/Getter(懒加载)

@end

