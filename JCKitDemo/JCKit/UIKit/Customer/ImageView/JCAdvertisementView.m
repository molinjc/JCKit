//
//  JCAdvertisementView.m
//  56Supplier
//
//  Created by 林建川 on 16/8/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCAdvertisementView.h"
#import "UIView+JCLayout.h"
#import "UIView+JCRect.h"

@interface JCAdvertisementView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer       *rollTimer;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UIScrollView  *scrollView;

@end

@implementation JCAdvertisementView

- (void)dealloc {
    [self.rollTimer invalidate];
    self.rollTimer = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.scrollView.layoutLeft(0).layoutRight(0).layoutTop(0).layoutBottom(0);
        self.pageControl.layoutLeft(0).layoutRight(0).layoutBottom(5).layoutHeight(20);
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size dataSource:(id<JCAdvertisementViewDataSource>)dataSource {
    if (self = [self init]) {
        self.scrollView.contentSize = size;
        self.dataSource = dataSource;
    }
    return self;
}

/**
 *  重新加载
 */
- (void)reloadData {
    if (self.dataSource) {
        [self loadData];
    }
}

/**
 *  加载视图数据
 */
- (void)loadData {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGSize size = self.scrollView.size;
    _count = [self.dataSource numberOfSectionsInAdvertisementView:self];
    self.pageControl.numberOfPages = _count;
    self.scrollView.contentSize = CGSizeMake(size.width * (_count + 2), size.height);
    for (NSInteger i=0; i < _count + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(size.width * i, 0, size.width, size.height);
        NSInteger tagOrIndex;
        if (i == 0) {
            tagOrIndex = _count - 1;
        }else if (i == _count + 1) {
            tagOrIndex = 0;
        }else {
            tagOrIndex = i - 1;
        }
        imageView.tag = tagOrIndex;
        [self.dataSource advertisementView:self imageView:imageView forRowAtIndex:tagOrIndex];
        
        UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewsClicked:)];
        [imageView addGestureRecognizer:tapGestureRecongnizer];
        imageView.userInteractionEnabled = YES;
    }
    [self setRollTimeInterval:15.0];
}

/**
 *  设置定时器
 *
 *  @param ti 时间间隔
 */
- (void)setRollTimeInterval:(NSTimeInterval)ti {
    if (self.rollTimer) {
        [self.rollTimer invalidate];
        self.rollTimer = nil;
    }
    self.rollTimer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(runRollTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:self.rollTimer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 事件

- (void)runRollTimer:(NSTimer *)sender {
    NSInteger page = self.pageControl.currentPage;
    page ++;
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * (page + 1), 0) animated:YES];
}

- (void)imageViewsClicked:(UITapGestureRecognizer *)sender {
    if ([self.dataSource respondsToSelector:@selector(advertisementView:didSelectAtIndex:)]) {
        [self.dataSource advertisementView:self didSelectAtIndex:sender.view.tag];
    }
}

#pragma mark - UISc

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.rollTimer setFireDate:[NSDate distantFuture]]; // 暂停定时器
    NSInteger page = scrollView.contentOffset.x / self.frame.size.width;
    if (page == _count + 1) {
        [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        [self.pageControl setCurrentPage:0];
    }else if(scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(self.frame.size.width * _count, 0) animated:NO];
        [self.pageControl setCurrentPage:_count];
    }else {
        [self.pageControl setCurrentPage:page - 1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self.rollTimer setFireDate:[NSDate distantPast]];// 开启定时器
    NSInteger page = scrollView.contentOffset.x / self.frame.size.width;
    if (page == _count + 1) {
        [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        [self.pageControl setCurrentPage:0];
    }else if(scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(self.frame.size.width * _count, 0) animated:NO];
        [self.pageControl setCurrentPage:_count];
    }else {
        [self.pageControl setCurrentPage:page - 1];
    }
}


#pragma mark - Set/Get 

- (void)setDataSource:(id<JCAdvertisementViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self loadData];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;  //设置滚动视图是否整页翻动，能整页翻动
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}


- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.userInteractionEnabled = NO;    //设置控件是否接收用户的事件消息（用户交互），不能
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor]; //设置当前页的显示颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];         //设置未使用状态的颜色
    }
    return _pageControl;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

@end
