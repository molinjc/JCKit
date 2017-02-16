//
//  JCImageBrowseView1.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCImageBrowseView1.h"
#import "UIView+JCRect.h"
#import "UIView+JCView.h"
#import "UIImage+JCImage.h"

@interface JCImageGroupItem1 ()
@property (nonatomic, readonly) UIImage *thumbImage;
@end

@implementation JCImageGroupItem1

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

@end

@interface JCImageBrowseView1 () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *backgroundView;  /// 背景图（屏幕截图）
@property (nonatomic, strong) UIVisualEffectView *blurbackgroundView; /// 背景模糊
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect oldRect;
@end

@implementation JCImageBrowseView1

- (instancetype)initWithImageGroupItems:(NSArray <JCImageGroupItem1 *> *)imageItems
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _groupItems = imageItems.copy;
        
        _backgroundView = UIImageView.new;
        _backgroundView.frame = self.bounds;
        [self addSubview:_backgroundView];
        
        _blurbackgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurbackgroundView.frame = self.bounds;
        [self addSubview:_blurbackgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (!container) {
        return;
    }
    
    NSInteger page = -1;
    for (JCImageGroupItem1 *item in _groupItems) {
        page ++;
        if ([fromView isEqual:item.thumbView]) {
            NSLog(@"=== %zd", page);
            return;
        }
    }
    
    CGRect rect = [fromView convertRect:fromView.bounds toView:self];
    _oldRect = rect;
    if (_oldRect.origin.y > self.height) {
        _oldRect.origin.y = _oldRect.origin.y - (_oldRect.origin.y - self.height - _oldRect.size.height);
    }else {
        _oldRect.origin.y = _oldRect.origin.y + 64;
    }
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = ((UIImageView *)fromView).image;
    _imageView.frame = rect;
    [self addSubview:_imageView];
    
    NSLog(@"----------------------------------- \n %@", NSStringFromCGRect(rect));
    
    _backgroundView.image = [container snapshotImage];
    [container addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.size = CGSizeMake(self.width, 500);
        _imageView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 退出
 */
- (void)dismiss {
    _blurbackgroundView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.frame = _oldRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
