//
//  UITableView+JCPlaceholder.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/20.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UITableView+JCPlaceholder.h"
#import <objc/runtime.h>

@interface _JCTableViewDefaultPlaceholder : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) void (^tableViewReloadBlock)();
@end

@implementation _JCTableViewDefaultPlaceholder

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        self.alpha = 1;
        
        _contentView = UIView.new;
        [self addSubview:_contentView];
        
        _imageView = UIImageView.new;
        _imageView.backgroundColor = [UIColor redColor];
        [_contentView addSubview:_imageView];
        
        _label = UILabel.new;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        [_contentView addSubview:_label];
        
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewReload)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    
    if (!_imageView.image) {
        _imageView.hidden = YES;
    }
    _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
    _imageView.center = CGPointMake(_contentView.center.x, _contentView.center.y - _imageView.image.size.height / 2 - 15);
    
    if (!(_label.text && _label.text.length)) {
        _label.hidden = YES;
    }
    
    CGSize textSize = [_label.text boundingRectWithSize:CGSizeMake(_contentView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_label.font} context:nil].size;
    _label.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    _label.center = CGPointMake(_contentView.center.x, _contentView.center.y);
}

- (void)tableViewReload {
    NSLog(@"tableViewReload");
    if (self.tableViewReloadBlock) {
        self.tableViewReloadBlock();
    }
}

@end




@interface UITableView ()
@property (nonatomic, strong) _JCTableViewDefaultPlaceholder *placeholderView;
@end

@implementation UITableView (JCPlaceholder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cla = [self class];
        Method sysMethod = class_getInstanceMethod(cla, @selector(reloadData));
        Method cusMethod = class_getInstanceMethod(cla, @selector(jc_reloadData));
        method_exchangeImplementations(sysMethod, cusMethod);
    });
}

/**
 reloadData
 */
- (void)jc_reloadData {
    [self checkEmpty];
    [self jc_reloadData];
}

/**
 检查数据是否为空
 */
- (void)checkEmpty {
    BOOL isEmpty = YES;  //flag标示
    
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;//默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1;//获取当前TableView组数
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i];//获取当前TableView各组行数
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
        }
    }
    
    if (!self.customPlaceholderView) {
        [self insideWithEmpty:isEmpty];
    }else {
        [self externalWithEmpty:isEmpty];
    }
}

/**
 内部
 */
- (void)insideWithEmpty:(BOOL)isEmpty {
    if (isEmpty) {    //若为空，加载占位图
        if (!self.placeholderView) {
            [self makeDefaultPlaceholder];
        }
        self.placeholderView.hidden = NO;
        self.scrollEnabled = NO;
    }else { //不为空，移除占位图
        self.placeholderView.hidden = YES;
        self.scrollEnabled = YES;
    }
}

/**
 外部 --- 自定义
 */
- (void)externalWithEmpty:(BOOL)isEmpty {
    if (isEmpty) {
        
        if (![self.subviews containsObject:self.customPlaceholderView]) {
            [self addSubview:self.customPlaceholderView];
        }
        self.customPlaceholderView.hidden = NO;
        self.scrollEnabled = NO;
    }else {
        self.customPlaceholderView.hidden = YES;
        self.scrollEnabled = YES;
    }
}

- (void)makeDefaultPlaceholder {
    _JCTableViewDefaultPlaceholder *placeholderView = [[_JCTableViewDefaultPlaceholder alloc] init];
    placeholderView.frame = self.bounds;
    placeholderView.imageView.image = self.placeholderImage;
    placeholderView.label.text = self.placeholder;
    placeholderView.tableViewReloadBlock = self.reload;
    self.placeholderView = placeholderView;
    [self addSubview:self.placeholderView];
}

#pragma mark - Set/Get

- (void)setCustomPlaceholderView:(UIView *)customPlaceholderView {
    objc_setAssociatedObject(self, @selector(customPlaceholderView), customPlaceholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)customPlaceholderView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholderView:(_JCTableViewDefaultPlaceholder *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_JCTableViewDefaultPlaceholder *)placeholderView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    objc_setAssociatedObject(self, @selector(placeholderImage), placeholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)placeholderImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setReload:(void (^)())reload {
    objc_setAssociatedObject(self, @selector(reload), reload, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())reload {
    return objc_getAssociatedObject(self, _cmd);
}

@end


@implementation UITableView (JCTableView)

- (void)updateWithBlock:(void (^)(UITableView *tableView))block {
    [self beginUpdates];
    if (block) {
        block(self);
    }
    [self endUpdates];
}

- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toInsert = [NSIndexPath indexPathForRow:row inSection:section];
    [self insertRowAtIndexPath:toInsert withRowAnimation:animation];
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toReload = [NSIndexPath indexPathForRow:row inSection:section];
    [self reloadRowAtIndexPath:toReload withRowAnimation:animation];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toDelete = [NSIndexPath indexPathForRow:row inSection:section];
    [self deleteRowAtIndexPath:toDelete withRowAnimation:animation];
}

- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self insertSections:sections withRowAnimation:animation];
}

- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self deleteSections:sections withRowAnimation:animation];
}

- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self reloadSections:indexSet withRowAnimation:animation];
}

- (void)clearSelectedRowsAnimated:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath* path, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:path animated:animated];
    }];
}

@end
