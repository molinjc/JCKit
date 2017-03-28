//
//  JCPhotoLibrary.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/25.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JCPhotoGroup;
@class JCPhotoAsset;

@interface JCPhotoLibrary : NSObject

- (void)photoGroup:(void (^)(NSArray <JCPhotoGroup *> *, NSError *))block;

/**
 新建相册
 @param name 相册名
 @param block 回调，获取最新相册组
 */
- (void)addAlbumWithName:(NSString *)name photoGroup:(void (^)(NSArray <JCPhotoGroup *> *, NSError *))block;

/** 保存一张图片到相册 */
- (void)savedImageToPhotosAlbum:(UIImage *)image error:(void (^)(NSError *))block;

/**
 保存视频
 @param path 视频的路径
 @param block 保存后的回调
 */
- (void)savedVideoToPhotosAlbum:(NSString *)path error:(void (^)(NSError *))block;

@end


@interface JCPhotoGroup : NSObject

/** 相册名 */
@property (nonatomic, readonly) NSString *groupName;

/** 照片个数 */
@property (nonatomic, readonly) NSInteger count;

/** ALAssetsGroupType */
@property (nonatomic, readonly) NSInteger groupPropertyType;

/** 相册封面图片 */
@property (nonatomic, readonly) UIImage *posterImage;

/** 通过相册组获取里面的图片： */
- (void)scanPhotos:(void (^)(NSArray <JCPhotoAsset *> *))block;

/** 设置过滤器，显示全部 */
- (void)setAssetsFilter;

/** 设置过滤器，显示全部照片 */
- (void)setPhotosFilter;

/** 设置过滤器，显示全部视频 */
- (void)setVideosFilter;

@end

@interface JCPhotoAsset : NSObject

/** 缩略图 */
@property (nonatomic, readonly) UIImage *thumbnail;

/** 缩略图 */
@property (nonatomic, readonly) UIImage *aspectRatioThumbnail;

/** 全尺寸图片 */
@property (nonatomic, readonly) UIImage *fullResolutionImage;

/** 全屏图片 */
@property (nonatomic, readonly) UIImage *fullScreenImage;

/** 图片方向 */
@property (nonatomic, readonly) UIImageOrientation orientation;

/** 照片创建时间 */
@property (nonatomic, readonly) NSDate *createDate;

/** 照片拍摄位置 */
@property (nonatomic, readonly) id location;

/** 照片名 */
@property (nonatomic, readonly) NSString *fileName;

/** 尺寸 */
@property (nonatomic, readonly) CGSize dimensions;

/** 缩放倍数 */
@property (nonatomic, readonly) float scale;

/** 资源图片url地址，该地址和ALAsset通过ALAssetPropertyAssetURL获取的url地址是一样的 */
@property (nonatomic, readonly) NSURL *url;

/** 图片资源原数据 */
@property (nonatomic, readonly) NSDictionary *metadata;

/** 图片资源容量大小 */
@property (nonatomic, assign) long long size;

/** 资源图片uti，唯一标示符 */
@property (nonatomic, readonly) NSString *UTI;

@end
