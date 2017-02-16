//
//  JCPhotoBrowseView.m
//  YYPhotoBrowseView
//
//  Created by molin.JC on 2016/12/19.
//  Copyright © 2016年 DINGXU. All rights reserved.
//

#import "JCImageBrowseView.h"
#import "UIView+JCView.h"
#import "UIView+JCRect.h"

@implementation JCImageGroupItem

@end

@interface JCImageBrowseCell : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) JCImageGroupItem *item;
@property (nonatomic, assign) NSInteger page;
@end

@implementation JCImageBrowseCell

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
        self.bouncesZoom = YES;
        self.maximumZoomScale = 3;
        self.multipleTouchEnabled = YES;
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.frame = [UIScreen mainScreen].bounds;
        
        _imageView = UIImageView.new;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.center = self.center;
}

- (void)setItem:(JCImageGroupItem *)item {
    if (_item == item) {
        return;
    }
    _item = item;
    [self setZoomScale:1.0 animated:NO];
    self.maximumZoomScale = 1;
    
    if (_item.image) {
        _imageView.image = _item.image;
    }else if (_item.imageURL) {
        NSLog(@"imageURL:%@", _item.imageURL);
        // 去下载图片，有相应动画
    }
    [self resizeImageViewSize];
}

/**
 调整ImageView大小
 */
- (void)resizeImageViewSize {
    CGFloat widthScale = _imageView.image.size.width / self.frame.size.width;
    CGFloat height = _imageView.image.size.height * widthScale;
    _imageView.frame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y, self.frame.size.width, height);
}

@end

@interface JCImageBrowseView () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, assign) BOOL blurEffectBackground;
@property (nonatomic, strong) UIImageView *snapshotbackgroundView;
@property (nonatomic, strong) UIVisualEffectView *blurbackgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pager;

@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, assign) BOOL isPresented;   // 被提出了
@end

@implementation JCImageBrowseView

- (instancetype)initWithImageGroupItems:(NSArray<JCImageGroupItem *> *)imageItems {
    if (!imageItems.count) {
        return nil;
    }
    
    self = [super init];
    _imageItems = imageItems.copy;
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    _blurEffectBackground = YES;
    if (imageItems.count == 0) {
        _blurEffectBackground = NO;
    }
    
    _cells = @[].mutableCopy;
    
    // 单击，退出
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    // 双击，放大
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];
    
    // 长按，分享
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    _snapshotbackgroundView = UIImageView.new;
    _snapshotbackgroundView.frame = self.bounds;
    [self addSubview:_snapshotbackgroundView];
    
    _blurbackgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _blurbackgroundView.frame = self.bounds;
    _blurbackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_blurbackgroundView];
    
    _contentView = UIView.new;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_contentView];
    
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(-20 / 2, 0, self.frame.size.width + 20, self.frame.size.height);
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = imageItems.count > 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    [_contentView addSubview:_scrollView];
    
    _pager = [[UIPageControl alloc] init];
    _pager.hidesForSinglePage = YES;
    _pager.userInteractionEnabled = NO;
    _pager.frame = CGRectMake(0, 0, self.frame.size.width - 36, 10);
    _pager.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 18);
    _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_contentView addSubview:_pager];
    
    return self;
}

#pragma mark - 外部调用

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (!toContainer) {
        return;
    }
    _fromView = fromView;
    _toContainerView = toContainer;
    
    _snapshotbackgroundView.image = [_toContainerView snapshotImage];
    if (!_blurEffectBackground) {
        _blurbackgroundView.backgroundColor = [UIColor blackColor];
    }
    
    self.pager.alpha = 0;
    self.pager.numberOfPages = self.imageItems.count;
    [_toContainerView addSubview:self];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * self.imageItems.count,
                                         _scrollView.frame.size.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    
    [self scrollViewDidScroll:_scrollView];
    
    [UIView setAnimationsEnabled:YES];
    
    float oneTime = animated ? 0.25 : 0;
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        _blurbackgroundView.alpha = 1;
    }completion:NULL];
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _pager.alpha = 1;
        _pager.hidden = NO;
    }completion:^(BOOL finished) {
    }];
}

#pragma mark - 私有方法

- (JCImageBrowseCell *)cellForPage:(NSInteger)page {
    for (JCImageBrowseCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}

/**
 可重复使用的Cell
 */
- (JCImageBrowseCell *)dequeueReusableCell {
    JCImageBrowseCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [JCImageBrowseCell new];
    cell.frame = self.bounds;
    cell.page = -1;
    cell.item = nil;
    [_cells addObject:cell];
    return cell;
}

#pragma mark - 手势事件

/**
 退出
 */
- (void)dismiss {
    NSLog(@"dismiss");
    [self removeFromSuperview];
}

- (void)doubleTap:(id)sender {
    
}

- (void)longPress {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        if (i >= 0 && i < self.imageItems.count) {
            JCImageBrowseCell *cell = [self cellForPage:i];
            if (!cell) {
                JCImageBrowseCell *cell = [self dequeueReusableCell];
                cell.page = i;
                CGRect rect = cell.frame;
                rect.origin.x = (self.frame.size.width + 20) * i + 20 / 2;
                cell.frame = rect;
                [cell setItem:self.imageItems[i]];
                if (_isPresented) {
                    
                }
                [_scrollView addSubview:cell];
            }else {
                 cell.item = self.imageItems[i];
//                if (_isPresented && !cell.item) {
//                   
//                }
            }
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _imageItems.count ? (int)_imageItems.count - 1 : intPage;
    _pager.currentPage = intPage;
}

@end
