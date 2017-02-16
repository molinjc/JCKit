//
//  JCImageBrowseView1.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCImageGroupItem1 : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIView *thumbView;  /// 原本显示图片的view
@end

@interface JCImageBrowseView1 : UIView
@property (nonatomic, readonly) NSArray<JCImageGroupItem1 *> *groupItems;

- (instancetype)initWithImageGroupItems:(NSArray <JCImageGroupItem1 *> *)imageItems;

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

@end
