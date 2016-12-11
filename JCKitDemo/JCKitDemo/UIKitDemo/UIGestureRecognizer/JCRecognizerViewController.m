//
//  JCRecognizerViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCRecognizerViewController.h"
#import "JCKitMacro.h"
@interface JCRecognizerViewController ()

@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UIView *view2;

@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) UIView *view4;

@end

@implementation JCRecognizerViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
    [self.view addSubview:self.view3];
    [self.view addSubview:self.view4];
    
    [self test1];
//    [self test2];
    [self test3];
    [self test4];
    [self test5];
    [self test6];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test1 {
    
    /* 拖动手势 */
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(test1_action:)];
    [self.view1 addGestureRecognizer:recognizer];
}

- (void)test2 {
    
    /* 捏合手势 */
    UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(test2_action:)];
    [self.view2 addGestureRecognizer:recognizer];
}

- (void)test3 {
    
    /* 旋转手势 */
    UIRotationGestureRecognizer *reconizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(test3_action:)];
    [self.view2 addGestureRecognizer:reconizer];
}

- (void)test4 {
    
    /* 点按手势 */
    UITapGestureRecognizer *reconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test4_action:)];
    //使用一根手指双击时，才触发点按手势识别器
    reconizer.numberOfTapsRequired = 2;
    reconizer.numberOfTouchesRequired = 1;
    [self.view4 addGestureRecognizer:reconizer];
}

- (void)test5 {
    
    /* 长按手势 */
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(test5_action:)];
    recognizer.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
    [self.view1 addGestureRecognizer:recognizer];
}

- (void)test6 {
    
    /* 轻扫手势 */
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(test6_action:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view2 addGestureRecognizer:recognizer];
}

#pragma mark - action

- (void)test1_action:(UIPanGestureRecognizer *)sender {
    JCLog(@"test1_action");
    
    // 视图前置操作
    [sender.view.superview bringSubviewToFront:sender.view];
    CGPoint center = sender.view.center;
         CGFloat cornerRadius = sender.view.frame.size.width / 2;
         CGPoint translation = [sender translationInView:self.view];
         //NSLog(@"%@", NSStringFromCGPoint(translation));
         sender.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
         [sender setTranslation:CGPointZero inView:self.view];
    
         if (sender.state == UIGestureRecognizerStateEnded) {
                 //计算速度向量的长度，当他小于200时，滑行会很短
                 CGPoint velocity = [sender velocityInView:self.view];
                 CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
                 CGFloat slideMult = magnitude / 200;
                 //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
        
                 //基于速度和速度因素计算一个终点
                 float slideFactor = 0.1 * slideMult;
                CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                                                                                              center.y + (velocity.y * slideFactor));
                 //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
                 finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                                                                  self.view.bounds.size.width - cornerRadius);
                 finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                                                                  self.view.bounds.size.height - cornerRadius);
        
                 //使用 UIView 动画使 view 滑行到终点
                [UIView animateWithDuration:slideFactor*2
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                             animations:^{
                                                      sender.view.center = finalPoint;
                                              }
                                        completion:nil];
          }
}

- (void)test2_action:(UIPinchGestureRecognizer *)sender {
    JCLog(@"test2_action");
    CGFloat scale = sender.scale;
    sender.view.transform = CGAffineTransformScale(sender.view.transform, scale, scale); //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
    sender.scale = 1.0;
}

- (void)test3_action:(UIRotationGestureRecognizer *)sender {
    JCLog(@"test3_action");
    sender.view.transform = CGAffineTransformRotate(sender.view.transform, sender.rotation);
    sender.rotation = 0.0;
}

- (void)test4_action:(UITapGestureRecognizer *)sender {
    JCLog(@"test4_action");
    UIView *view = sender.view;
    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    view.transform = CGAffineTransformMakeRotation(0.0);
    view.alpha = 1.0;
}

- (void)test5_action:(UILongPressGestureRecognizer *)sender {
    JCLog(@"test5_action");
    sender.view.alpha = 0.7;
}

- (void)test6_action:(UISwipeGestureRecognizer *)sender {
    JCLog(@"test6_action");
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

- (UIView *)view1 {
    if (!_view1) {
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor grayColor];
        _view1.frame = CGRectMake(10, 64, 100, 100);
    }
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        _view2 = [[UIView alloc] init];
        _view2.backgroundColor = [UIColor greenColor];
        _view2.frame = CGRectMake(10, 174, 300, 300);
    }
    return _view2;
}

- (UIView *)view3 {
    if (!_view3) {
        _view3 = [[UIView alloc] init];
        _view3.backgroundColor = [UIColor darkGrayColor];
        _view3.frame = CGRectMake(10, 484, 100, 100);
    }
    return _view3;
}

- (UIView *)view4 {
    if (!_view4) {
        _view4 = [[UIView alloc] init];
        _view4.backgroundColor = [UIColor lightGrayColor];
        _view4.frame = CGRectMake(10, 594, 100, 100);
    }
    return _view4;
}

@end
