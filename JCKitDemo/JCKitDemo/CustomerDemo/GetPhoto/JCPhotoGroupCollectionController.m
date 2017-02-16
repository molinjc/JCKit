//
//  JCPhotoGroupCollectionController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCPhotoGroupCollectionController.h"
#import "JCPhotoLibrary.h"
#import "JCImageBrowseView.h"
#import "JCImageBrowseView1.h"

@interface _JCPhotoGroupCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation _JCPhotoGroupCollectionCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
        [self addSubview:_imageView];
        self.backgroundColor = [UIColor grayColor];
    }
    return _imageView;
}

@end

static NSString *_reuseId = @"_JCPhotoGroupCell";


@interface JCPhotoGroupCollectionController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) JCPhotoGroup *photoGroup;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation JCPhotoGroupCollectionController
- (instancetype)initWithPhotoGroup:(JCPhotoGroup *)photoGroup {
    if (self = [super init]) {
        _photoGroup = photoGroup;
        self.title = photoGroup.groupName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[_JCPhotoGroupCollectionCell class] forCellWithReuseIdentifier:_reuseId];
    
    [_photoGroup scanPhotos:^(NSArray<JCPhotoAsset *> *datas) {
        NSLog(@"_datas:%@", datas);
        _datas = datas;
        [_collectionView reloadData];
    }];
}

- (UICollectionViewFlowLayout *)flowLayout {
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 1;  // 竖的间距
    flowLayout.minimumInteritemSpacing = 1; // 横的间距
    flowLayout.itemSize = CGSizeMake(175, 125);
    return flowLayout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _JCPhotoGroupCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseId forIndexPath:indexPath];
    if (!_datas || _datas.count == 0) {
        return cell;
    }
    NSLog(@"==s------");
    
    JCPhotoAsset *asset = _datas[indexPath.row];
    cell.imageView.image = asset.thumbnail;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray *items = [NSMutableArray new];
//    for (JCPhotoAsset *asset in _datas) {
//        JCImageGroupItem1 *item = [JCImageGroupItem1 new];
//        item.image = asset.fullScreenImage;
//        [items addObject:item];
//    }
    
      _JCPhotoGroupCollectionCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /*
    JCImageBrowseView *imageBrowseView = [[JCImageBrowseView alloc] initWithImageGroupItems:items];
    [imageBrowseView presentFromImageView:cell.imageView toContainer:self.navigationController.view animated:YES completion:nil];
     */
    
    JCImageBrowseView1 *view1 = [[JCImageBrowseView1 alloc] initWithImageGroupItems:nil];
//    [view1 presentFromImageView:cell.imageView toContainer:self.navigationController.view animated:YES completion:nil];
    cell.imageView.image = ((JCPhotoAsset *)_datas[indexPath.row]).fullScreenImage;
    [view1 presentFromImageView:cell.imageView toContainer:self.navigationController.view animated:YES completion:^{
        cell.imageView.image = ((JCPhotoAsset *)_datas[indexPath.row]).thumbnail;
    }];
}

@end
