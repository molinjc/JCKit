//
//  JCPhotoLibrary.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCPhotoLibrary.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JCPhotoAsset ()
- (instancetype)initWithAsset:(ALAsset *)asset;
@end
@implementation JCPhotoAsset
{
    ALAsset * _asset;
    ALAssetRepresentation * _assetRepresentation;
}

- (instancetype)initWithAsset:(ALAsset *)asset {
    if (self = [super init]) {
        _asset = asset;
        _assetRepresentation = [_asset defaultRepresentation];
    }
    return self;
}

/**
 照片创建时间
 */
- (NSDate *)createDate {
    return [_asset valueForProperty:ALAssetPropertyDate];
}

/**
 照片拍摄位置
 */
- (id)location {
    return [_asset valueForProperty:ALAssetPropertyLocation];
}

/**
 播放时长（照片返回ALErorInvalidProperty)
 */
- (double)duation {
    return [[_asset valueForProperty:ALAssetPropertyDuration] doubleValue];
}

- (UIImage *)thumbnail {
    return [UIImage imageWithCGImage:_asset.thumbnail];
}

- (UIImage *)aspectRatioThumbnail {
    return [UIImage imageWithCGImage:_asset.aspectRatioThumbnail];
}

/**
 全尺寸图片
 */
- (UIImage *)fullResolutionImage {
    return [UIImage imageWithCGImage:_assetRepresentation.fullResolutionImage];
}

/**
 全屏图片
 系统”相册”程序显示的图片是 fullScreenImage ，而不是 fullResolutionImage ，fullResolutionImage尺寸太大，在手机端显示推荐用fullScreenImage。
 fullScreenImage已被调整过方向，可直接使用
 */
- (UIImage *)fullScreenImage {
    return [UIImage imageWithCGImage:_assetRepresentation.fullScreenImage];
}

/**
 图片方向
 */
- (UIImageOrientation)orientation {
    switch (_assetRepresentation.orientation) {
        case ALAssetOrientationUp:
            return UIImageOrientationUp;
        case ALAssetOrientationDown:
            return UIImageOrientationDown;
        case ALAssetOrientationLeft:
            return UIImageOrientationLeft;
        case ALAssetOrientationRight:
            return UIImageOrientationRight;
        case ALAssetOrientationUpMirrored:
            return UIImageOrientationUpMirrored;
        case ALAssetOrientationDownMirrored:
            return UIImageOrientationDownMirrored;
        case ALAssetOrientationLeftMirrored:
            return UIImageOrientationLeftMirrored;
        case ALAssetOrientationRightMirrored:
            return UIImageOrientationRightMirrored;
        default:
            break;
    }
}

/**
 尺寸
 */
- (CGSize)dimensions {
    return _assetRepresentation.dimensions;
}

/**
 缩放倍数
 */
- (float)scale {
    return _assetRepresentation.scale;
}

/**
 资源图片url地址，该地址和ALAsset通过ALAssetPropertyAssetURL获取的url地址是一样的
 */
- (NSURL *)url {
    return _assetRepresentation.url;
}

/**
 图片资源原数据
 */
- (NSDictionary *)metadata {
    return _assetRepresentation.metadata;
}

- (NSString *)fileName {
    return _assetRepresentation.filename;
}

/**
 图片资源容量大小
 */
- (long long)size {
    return _assetRepresentation.size;
}

/**
 资源图片uti，唯一标示符
 */
- (NSString *)UTI {
    return _assetRepresentation.UTI;
}

@end

#pragma mark -

@interface JCPhotoGroup ()
- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup;
@end

@implementation JCPhotoGroup
{
    ALAssetsGroup * _assetsGroup;
}

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup {
    if (self = [super init]) {
        _assetsGroup = assetsGroup;
    }
    return self;
}

/**
 通过相册组获取里面的图片：
 */
- (void)scanPhotos:(void (^)(NSArray <JCPhotoAsset *> *))block {
    __block NSMutableArray *assets = [NSMutableArray new];
    [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            JCPhotoAsset *asset = [[JCPhotoAsset alloc] initWithAsset:result];
            [assets addObject:asset];
        }
    }];
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (block) {
            block(assets.copy);
        }
    });
}

/**
 设置过滤器，显示全部
 */
- (void)setAssetsFilter {
    [_assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
}

/**
 设置过滤器，显示全部照片
 */
- (void)setPhotosFilter {
    [_assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
}

/**
 设置过滤器，显示全部视频
 */
- (void)setVideosFilter {
    [_assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
}

/**
 相册封面图片
 */
- (UIImage *)posterImage {
    return [UIImage imageWithCGImage:_assetsGroup.posterImage];
}

- (NSString *)groupName {
    return [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
}

- (NSInteger)count {
    return [_assetsGroup numberOfAssets];
}

- (NSInteger)groupPropertyType {
    return [[_assetsGroup valueForProperty:ALAssetsGroupPropertyType] integerValue];
}

@end

#pragma mark -

@implementation JCPhotoLibrary
{
    ALAssetsLibrary *_assetsLibray;    //图片库
}

- (instancetype)init {
    if (self = [super init]) {
        _assetsLibray = [ALAssetsLibrary new];
    }
    return self;
}

- (void)photoGroup:(void (^)(NSArray <JCPhotoGroup *> *, NSError *))block {
    __block NSMutableArray *_assetsGroup = [NSMutableArray new];
    dispatch_async(dispatch_get_main_queue(), ^{
        void  (^assetGroupEnumerator)(ALAssetsGroup  * ,BOOL * ) = ^(ALAssetsGroup * group,BOOL * stop){
            if(group){
                JCPhotoGroup *_photoGroup = [[JCPhotoGroup alloc] initWithAssetsGroup:group];
                NSUInteger  groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
                
                if([[_photoGroup.groupName  lowercaseString] isEqualToString:@"camera roll"] &&
                   groupType == ALAssetsGroupSavedPhotos){
                    [_assetsGroup insertObject:_photoGroup atIndex:0];
                }else{
                    [_assetsGroup addObject:_photoGroup];
                }
                
                if (block) {
                    block(_assetsGroup.copy, nil);
                }
            }
        };
        void  (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError * err){
            if (block) {
                block(nil, err);
            }
        };
        [_assetsLibray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
    });
}

/**
 新建相册
 */
- (void)addAlbumWithName:(NSString *)name photoGroup:(void (^)(NSArray <JCPhotoGroup *> *, NSError *))block {
    __weak typeof(self) _self = self;
    [_assetsLibray addAssetsGroupAlbumWithName:name resultBlock:^(ALAssetsGroup *group) {
        [_self photoGroup:block];
    } failureBlock:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

/**
 保存一张图片到相册
 */
- (void)savedImageToPhotosAlbum:(UIImage *)image error:(void (^)(NSError *))block {
    [_assetsLibray writeImageToSavedPhotosAlbum:image.CGImage orientation:[JCPhotoLibrary imageRefOrientation:image] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

/**
 保存视频
 */
- (void)savedVideoToPhotosAlbum:(NSString *)path error:(void (^)(NSError *))block {
    [_assetsLibray writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:path] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

#pragma mark -

+ (ALAssetOrientation)imageRefOrientation:(UIImage *)image {
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            return ALAssetOrientationUp;
        case UIImageOrientationDown:
            return ALAssetOrientationDown;
        case UIImageOrientationLeft:
            return ALAssetOrientationLeft;
        case UIImageOrientationRight:
            return ALAssetOrientationRight;
        case UIImageOrientationUpMirrored:
            return ALAssetOrientationUpMirrored;
        case UIImageOrientationDownMirrored:
            return ALAssetOrientationDownMirrored;
        case UIImageOrientationLeftMirrored:
            return ALAssetOrientationLeftMirrored;
        case UIImageOrientationRightMirrored:
            return ALAssetOrientationRightMirrored;
        default:
            break;
    }
}

@end

