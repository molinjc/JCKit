//
//  JCAdvertisementView.h
//  56Supplier
//
//  Created by 林建川 on 16/8/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

 /**
  滚动图片视图
  */

@class JCAdvertisementView;
@protocol JCAdvertisementViewDataSource <NSObject>

/**
 *  广告页个数
 */
- (NSInteger)numberOfSectionsInAdvertisementView:(JCAdvertisementView *)advertisementView;

/**
 *  创建广告页
 */
- (void)advertisementView:(JCAdvertisementView *)advertisementView imageView:(UIImageView *)imageView forRowAtIndex:(NSInteger)index;

@optional
/**
 *  选择某个
 */
- (void)advertisementView:(JCAdvertisementView *)advertisementView  didSelectAtIndex:(NSInteger)index;

@end

@interface JCAdvertisementView : UIView

@property (nonatomic, weak) id<JCAdvertisementViewDataSource> dataSource;

@property (nonatomic, assign) NSTimeInterval rollInterval;

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

- (instancetype)initWithDataSource:(id<JCAdvertisementViewDataSource>)dataSource;

/**
 *  重新加载
 */
- (void)reloadData;

@end
