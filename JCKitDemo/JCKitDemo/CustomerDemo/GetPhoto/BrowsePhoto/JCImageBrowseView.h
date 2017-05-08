//
//  JCPhotoBrowseView.h
//  YYPhotoBrowseView
//
//  Created by molin.JC on 2016/12/19.
//  Copyright © 2016年 DINGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

__attribute__((objc_runtime_name("molin1")))
@interface JCImageGroupItem : NSObject 
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;
@end



@interface JCImageBrowseView : UIView

@property (nonatomic, readonly) NSArray <JCImageGroupItem *> *imageItems;

- (instancetype)initWithImageGroupItems:(NSArray <JCImageGroupItem *> *)imageItems;

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

@end
