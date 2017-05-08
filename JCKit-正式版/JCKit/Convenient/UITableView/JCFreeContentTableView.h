//
//  JCFreeContentTableView.h
//
//  Created by molin.JC on 2017/4/29.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 自由内容的表格视图, 注意: cell上最好只有一个子view, 其他元素添加到子view */

@protocol JCFreeContentTableDelegate <NSObject>
/** 设置cell的内容视图(创建) */
- (__kindof UIView *)freeContentViewForData:(id)data;
/** 是否要替换cell的内容视图 */
- (BOOL)replaceFreeContentViewWithData:(id)data;

@optional
/** 设置内容视图上的内容数据 */
- (void)freeContentView:(UIView *)freeContentView setContentWithData:(id)data;
/** 设置内容视图的大小, 两个方法二选一, 优先freeContentLayoutForData:, 其次freeContentFrameForData:, 都没有就默认cell的bounds */
- (CGRect)freeContentFrameForData:(id)data;
/** 设置内容视图的约束 */
- (void)freeContentLayoutForData:(id)data;

@end

@interface JCFreeContentTableView : UITableView
/** 获取在indexPath上的内容视图 */
- (__kindof UIView *)freeContentViewAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface JCFreeContentTableViewCell : UITableViewCell
@property (nonatomic, weak) id<JCFreeContentTableDelegate> delegate;
/** 初始化方法, 该方法会清空掉contentView所有的子视图, 默认UITableViewCellStyleDefault */
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithDelegate:(id<JCFreeContentTableDelegate>)delegate reuseIdentifier:(NSString *)reuseIdentifier;
/** 设置内容视图, 这里会调用代理方法 */
- (void)setLayoutWithData:(id)data;
@end
