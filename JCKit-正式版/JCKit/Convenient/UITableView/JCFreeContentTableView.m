//
//  JCFreeContentTableView.m
//
//  Created by molin.JC on 2017/4/29.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCFreeContentTableView.h"

@implementation JCFreeContentTableView

- (UIView *)freeContentViewAtIndexPath:(NSIndexPath *)indexPath {
    JCFreeContentTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    return cell.contentView.subviews.firstObject;
}

@end

@implementation JCFreeContentTableViewCell {
    dispatch_semaphore_t _lock;
}

- (instancetype)initWithDelegate:(id<JCFreeContentTableDelegate>)delegate reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [self initWithReuseIdentifier:reuseIdentifier]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *freeContentView = self.contentView.subviews.firstObject;
    if (freeContentView.frame.size.height == 0) {
        freeContentView.frame = self.contentView.bounds;
    }else {
        CGRect rect = self.frame;
        rect.size.height = freeContentView.frame.size.height;
        self.frame = rect;
    }
}

- (void)setLayoutWithData:(id)data {
    if (!self.delegate) {
        return;
    }
    
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    UIView *freeContentView = self.contentView.subviews.firstObject;
    if (freeContentView) {
        if ([self.delegate respondsToSelector:@selector(replaceFreeContentViewWithData:)]) {
            if ([self.delegate replaceFreeContentViewWithData:data]) {
                if ([self _creatFreeContentViewWithData:data]) {
                    freeContentView = self.contentView.subviews.firstObject;
                }
            }
        }
        [self _freeContentView:freeContentView setContentWithData:data];
        [self _freeContentView:freeContentView setLayoutWithData:data];
    }else {
        if ([self _creatFreeContentViewWithData:data]) {
            freeContentView = self.contentView.subviews.firstObject;
            [self _freeContentView:freeContentView setContentWithData:data];
            [self _freeContentView:freeContentView setLayoutWithData:data];
        }
    }
    dispatch_semaphore_signal(_lock);
}

- (BOOL)_creatFreeContentViewWithData:(id)data {
    if ([self.delegate respondsToSelector:@selector(freeContentViewForData:)]) {
        UIView *freeContentView = [self.delegate freeContentViewForData:data];
        if (!freeContentView) {
            return NO;
        }
        [self.contentView addSubview:freeContentView];
        return YES;
    }
    return NO;
}

/** 让代理去设置内容视图上的内容数据 */
- (void)_freeContentView:(UIView *)freeContentView setContentWithData:(id)data {
    if ([self.delegate respondsToSelector:@selector(freeContentView:setContentWithData:)]) {
        [self.delegate freeContentView:freeContentView setContentWithData:data];
    }
}

/** 让代理去设置内容视图的大小 */
- (void)_freeContentView:(UIView *)freeContentView setLayoutWithData:(id)data {
    if ([self.delegate respondsToSelector:@selector(freeContentLayoutForData:)]) {
        [self.delegate freeContentLayoutForData:data];
    }else if ([self.delegate respondsToSelector:@selector(freeContentFrameForData:)]) {
        CGRect rect = [self.delegate freeContentFrameForData:data];
        freeContentView.frame = rect;
    }
}

@end
