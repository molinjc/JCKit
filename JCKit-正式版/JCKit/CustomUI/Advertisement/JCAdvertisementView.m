//
//  JCAdvertisementView.m
//  Created by 林建川 on 16/8/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCAdvertisementView.h"

@interface JCAdvertisementView ()<UIScrollViewDelegate>
{
    dispatch_source_t _source;
}
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIScrollView  *scrollView;
@end

@implementation JCAdvertisementView

- (void)dealloc {
    dispatch_source_cancel(_source);
    _source = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.rollInterval = 15.0;
    }
    return self;
}

- (instancetype)initWithDataSource:(id<JCAdvertisementViewDataSource>)dataSource {
    if (self = [self init]) {
        _dataSource = dataSource;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.bounds.size.height - 25, self.bounds.size.width, 20);
    [self _loadData];
}

/** 重新加载 */
- (void)reloadData {
    if (self.dataSource) {
        [self _loadData];
    }
}

/** 加载视图数据 */
- (void)_loadData {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _count = [self.dataSource numberOfSectionsInAdvertisementView:self];
    CGSize size = self.scrollView.frame.size;
    self.pageControl.numberOfPages = _count;
    self.scrollView.contentSize = CGSizeMake(size.width * (_count + 2), size.height * 0.5);
    for (NSInteger i=0; i < _count + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
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
    [self.scrollView setContentOffset:CGPointMake(size.width, 0)];
    [self.pageControl setCurrentPage:0];
    [self setRollTimeInterval:self.rollInterval];
}

/**
 设置定时器
 @param ti 时间间隔
 */
- (void)setRollTimeInterval:(NSTimeInterval)ti {
    if (_source) {
        dispatch_source_cancel(_source);
        _source = nil;
    }
    
    __weak typeof(self) _self = self;
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_source, dispatch_time(DISPATCH_TIME_NOW, (0 * NSEC_PER_SEC)), (15 * NSEC_PER_SEC), 0);
    dispatch_source_set_event_handler(_source, ^{
        [_self runRollTimer];
    });
    dispatch_resume(_source);
}

#pragma mark - 事件

- (void)runRollTimer {
    NSInteger page = self.pageControl.currentPage;
    page ++;
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * (page + 1), 0) animated:YES];
}

- (void)imageViewsClicked:(UITapGestureRecognizer *)sender {
    if ([self.dataSource respondsToSelector:@selector(advertisementView:didSelectAtIndex:)]) {
        [self.dataSource advertisementView:self didSelectAtIndex:sender.view.tag];
    }
}

#pragma mark - UISscrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    dispatch_suspend(_source);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    dispatch_resume(_source);
}

#pragma mark - Set/Get 

- (void)setDataSource:(id<JCAdvertisementViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self _loadData];
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

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    _pageIndicatorTintColor = pageIndicatorTintColor;
}

@end
