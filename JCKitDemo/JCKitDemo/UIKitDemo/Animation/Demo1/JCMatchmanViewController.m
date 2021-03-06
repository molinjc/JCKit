//
//  JCMatchmanViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/5.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCMatchmanViewController.h"
#import "UIBezierPath+JCBezierPath.h"

@interface JCMatchmanViewController () <UIPopoverPresentationControllerDelegate>

@end

@implementation JCMatchmanViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

/**
 火柴人
 */
- (void)matchman {
    UIBezierPath *path = UIBezierPath.newPath.moveTo(CGPointMake(175, 100)).addArcWith(CGPointMake(150, 100), 25, 0, 2*M_PI, YES).moveTo(CGPointMake(150, 125)).addLineTo(CGPointMake(150, 175)).addLineTo(CGPointMake(125, 225)).moveTo(CGPointMake(150, 175)).addLineTo(CGPointMake(175, 225)).moveTo(CGPointMake(100, 150)).addLineTo(CGPointMake(200, 150));
    /*
    [path moveToPoint:CGPointMake(175, 100)];
    
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    */
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor colorWithRed:147/255.0 green:231/255.0 blue:182/255.0 alpha:1].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    //add it to our view
    [self.view.layer addSublayer:shapeLayer];
}

// 平移动画
- (void)baseTranslationAnimation {
    UIView *springView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, 50, 50)];
    [self.view addSubview:springView];
    springView.layer.borderColor = [UIColor greenColor].CGColor;
    springView.layer.borderWidth = 2;
    springView.backgroundColor = [UIColor redColor];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    animation.duration = 2;
    
    CGFloat width = self.view.frame.size.width;
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(width - 50, 0)];
    
    // 指定动画重复多少圈是累加的
    animation.cumulative = YES;
    // 动画完成是不自动很危险
    animation.removedOnCompletion = NO;
    // 设置移动的效果为快入快出
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 设置无限循环动画
    animation.repeatCount = HUGE_VALF;
    // 设置动画完成时，自动以动画回到原点
    animation.autoreverses = YES;
    // 设置动画完成时，返回到原点
    animation.fillMode = kCAFillModeForwards;
    
    [springView.layer addAnimation:animation forKey:@"transform.translation"];
}

// 缩放动画
- (void)baseScaleAnimation {
    UIView *springView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 50, 50)];
    [self.view addSubview:springView];
    springView.layer.borderColor = [UIColor greenColor].CGColor;
    springView.layer.borderWidth = 2;
    springView.backgroundColor = [UIColor redColor];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 2;
    animation.fromValue = @(1);
    animation.toValue = @(0);
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [springView.layer addAnimation:animation forKey:@"transform.scale"];
}

// 闪烁动画
- (void)baseSpringAnimation {
    UIView *springView = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 50, 50)];
    [self.view addSubview:springView];
    springView.layer.borderColor = [UIColor greenColor].CGColor;
    springView.layer.borderWidth = 2;
    springView.backgroundColor = [UIColor redColor];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 5;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [springView.layer addAnimation:animation forKey:@"opacity"];
}

// 路径动画
- (void)baseAnimation {
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    animationView.layer.borderWidth = 2;
    animationView.layer.borderColor = [UIColor redColor].CGColor;
    animationView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:animationView];
    
    // 添加动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 起点，这个值是指position，也就是layer的中心值
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, 50)];
    // 终点，这个值是指position，也就是layer的中心值
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width - 50,
                                                              self.view.bounds.size.height - 100)];
    // byValue与toValue的区别：byValue是指x方向再移动到指定的宽然后y方向移动指定的高
    // 而toValue是整体移动到指定的点
    //  animation.byValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width - 50 - 50,
    //                                                            self.view.bounds.size.height - 50 - 50 - 50)];
    // 线性动画
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    
    // 设定开始值到结束值花费的时间，也就是动画时长，单位为秒
    animation.duration = 2;
    
    // 播放速率，默认为1，表示常速
    // 设置为2则以2倍的速度播放，同样设置为N则以N倍速度播放
    // 如果值小于1，自然就是慢放
    animation.speed = 0.5;
    
    // 开始播放动画的时间，默认为0.0，通常是在组合动画中使用
    animation.beginTime = 0.0;
    
    // 播放动画的次数，默认为0，表示只播放一次
    // 设置为3表示播放3次
    // 设置为HUGE_VALF表示无限动画次数
    animation.repeatCount = HUGE_VALF;
    
    // 默认为NO，设置为YES后，在动画达到toValue点时，就会以动画由toValue返回到fromValue点。
    // 如果不设置或设置为NO，在动画到达toValue时，就会突然马上返回到fromValue点
    animation.autoreverses = YES;
    
    // 当autoreverses设置为NO时，最终会留在toValue处
    animation.fillMode = kCAFillModeForwards;
    // 将动画添加到层中
    [animationView.layer addAnimation:animation forKey:@"position"];
}

- (void)popover {
    UIViewController *popC = [[UIViewController alloc] init];
    popC.modalPresentationStyle = UIModalPresentationPopover;
    
    // 设置依附的按钮
    popC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    // 指示小箭头颜色
    popC.popoverPresentationController.backgroundColor = [UIColor blueColor];
    
    // content尺寸
    popC.preferredContentSize = CGSizeMake(300, 200);
    
    // 箭头方向
    popC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popC.popoverPresentationController.delegate = self;
    
    popC.view.backgroundColor = [UIColor grayColor];
    
    [self presentViewController:popC animated:YES completion:nil];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self matchman];
    
//    [self baseTranslationAnimation];
    
//    [self baseScaleAnimation];
    [self baseSpringAnimation];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStyleDone target:self action:@selector(popover)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

//代理方法 ,点击即可dismiss掉每次init产生的PopViewController
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

#pragma mark - Setter/Getter(懒加载)

@end
