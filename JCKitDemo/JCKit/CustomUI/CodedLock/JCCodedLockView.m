//
//  JCCodedLockView.m
//  密码锁
//
//  Created by Molin on 15-6-27.
//  Copyright (c) 2015年 Molin. All rights reserved.
//

#import "JCCodedLockView.h"

CGFloat const btnCount = 9;

int const columnCount = 3;

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface JCCodedLockView()

@property (nonatomic, strong) NSMutableArray *selectedBtns;

@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation JCCodedLockView

//创建数组
- (NSMutableArray *)selectedBtns{
    
    if (_selectedBtns == nil) {
        
        _selectedBtns = [NSMutableArray array];
    }
    
    return _selectedBtns;
}

- (id)initWithFrame:(CGRect)frame andWithButtonStateNormalImage:(UIImage *)image_1 orButtonStateSelectedImage:(UIImage *)image_2
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.btnH = 74;
        
        self.btnW = 74;
        
        [self addButtonAndWithButtonStateNormalImage:image_1 orButtonStateSelectedImage:image_2];
        
        
    }
    return self;
}
#pragma mark 布局按钮
//九宫格
- (void)addButtonAndWithButtonStateNormalImage:(UIImage *)image_1 orButtonStateSelectedImage:(UIImage *)image_2{
    
    for (int i = 0; i< btnCount; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.userInteractionEnabled = NO;
        
        btn.tag = i;
        
        //设置默认的图片
        [btn setBackgroundImage:image_1 forState:UIControlStateNormal];
        
        //设置选中的图片
        [btn setBackgroundImage:image_2 forState:UIControlStateSelected];
        
        int row = i / columnCount;//行
        
        int column = i % columnCount;//列
        
        CGFloat margin = (self.frame.size.width - columnCount * self.btnW) / (columnCount + 1) ;//边距
        
        CGFloat btnX = margin + column * (self.btnW + margin);//x轴
        
        CGFloat btnY = row * (self.btnW + margin);//y轴
        
        btn.frame = CGRectMake(btnX, btnY, self.btnW, self.btnH);
        
        [self addSubview:btn];
    }
}

- (CGPoint)pointWithTouch:(NSSet *)touches{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    return point;
}

- (UIButton *)buttonWithPoint:(CGPoint)point{
    
    for (UIButton *btn in self.subviews) {
        
        if (CGRectContainsPoint(btn.frame, point)) {
            
            return btn;
        }
    }
    
    return nil;
}

#pragma mark 触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.selectedBtns removeAllObjects];
    //获取触摸点
    CGPoint point = [self pointWithTouch:touches];
    //获取触摸到的按钮
    UIButton *btn = [self buttonWithPoint:point];
    
    //设置按钮状态
    if (btn && btn.selected == NO) {
        
        btn.selected = YES;
        //将按钮加入数组
        [self.selectedBtns addObject:btn];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [self pointWithTouch:touches];
    
    UIButton *btn = [self buttonWithPoint:point];
    
    //设置按钮状态
    if (btn && btn.selected == NO) {
        
        btn.selected = YES;
        
        [self.selectedBtns addObject:btn];
        
    }else{
        //设置最后的一个点
        self.currentPoint = point;
    }
    
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
//    if ([self.delegate respondsToSelector:@selector(codedLockView:didFinishPath:)]) {
    
        NSMutableString *path = [NSMutableString string];
        
        for (UIButton *btn in self.selectedBtns) {
            
            [path appendFormat:@"%ld",(long)btn.tag];
        }
        
        [self.delegate codedLockView:self didFinishPath:path];
//    }

    //清空状态
    [self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    
    [self.selectedBtns removeAllObjects];
    
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self touchesEnded:touches withEvent:event];
    
}

#pragma mark 连线


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    
    if (self.selectedBtns.count == 0) {
        
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    path.lineWidth = 8;
    
    path.lineJoinStyle = kCGLineJoinRound;
    
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    
    for (int i = 0; i< self.selectedBtns.count; i++) {
        
        UIButton *button = self.selectedBtns[i];
        
        if (i == 0) {//设置起点
            
            [path moveToPoint:button.center];
            
        }else{//连线
            
            [path addLineToPoint:button.center];
        }
    }
    
    [path addLineToPoint:self.currentPoint];
    
    [path stroke];

}


@end
