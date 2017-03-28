//
//  JCMVPViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCMVPViewController.h"
#import "JCMVPPresenter.h"
#import "UIBarButtonItem+JCBlock.h"
#import "UINavigationItem+JCLoading.h"
#import "JCKit.h"

@interface JCHexagonImageView : UIImageView

@end

@implementation JCHexagonImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [[UIImage imageNamed:@"4"] resize:JCSize(100, 100)];
        [self setHexagon];
    }
    return self;
}

// 六边形
- (void)setHexagon {
    
    // 六边形
    UIBezierPath* path = [[UIBezierPath alloc]init];
    path.CGPath = CGPathCreateWithPolygon(JCPOINT_XY(50, 50), 50, 6);
//    
//    for (int i = 1; i <= 6; i++) {
//        CGPoint point = CGPointMake(50+50*sin(2*M_PI*i/6), 50 +50*cos(2*M_PI*i/6));
//        if (i == 1) {
//            [path moveToPoint:point];
//        }else {
//            [path addLineToPoint:point];
//        }
//    }

//    CGFloat viewWidth = self.width;
//    path.lineWidth = 2;
//    [[UIColor whiteColor] setStroke];
//    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
//    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
//    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
//    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
//    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
//    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    
//    [path moveToPoint:CGPointMake(self.frame.size.width/2, 0)];
//    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/4)];
//    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/4 * 3)];
//    [path addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height)];
//    [path addLineToPoint:CGPointMake(0, self.frame.size.height/4 * 3)];
//    [path addLineToPoint:CGPointMake(0, self.frame.size.height/4)];
    
//    [path closePath];
    
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
     shapLayer.path = path.CGPath;
    shapLayer.strokeColor = [UIColor redColor].CGColor;
    shapLayer.lineWidth = 2;
    //    shapLayer.fillColor = [UIColor clearColor].CGColor;
    //    shapLayer.lineJoin = kCALineJoinMiter;
    //    shapLayer.lineCap = kCALineCapSquare;
    [self.layer addSublayer:shapLayer];
    
    // 扣除图片以外的区域
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [maskPath appendPath:[path bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = shapLayer;
    
    // 加边框
    CAShapeLayer *cshapLayer = [CAShapeLayer layer];
    cshapLayer.path = path.CGPath;
    cshapLayer.strokeColor = [UIColor redColor].CGColor;
    cshapLayer.lineWidth = 2;
    cshapLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:cshapLayer];
}

@end

@interface JCMVPViewController ()

@property (nonatomic, strong) JCMVPPresenter *mvpPresenter;

@property (nonatomic, copy) NSString *string; // 用于KVO

@end

@implementation JCMVPViewController

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)imageHexagon {
    JCHexagonImageView *imageView = [[JCHexagonImageView alloc] initWithFrame:JCFRAME_XYWH(100, 200, 100, 100)];
//    UIImage *image = [[UIImage imageNamed:@"4"] resize:JCSize(100, 100)];
//    imageView.image = image;
    
    [self.view addSubview:imageView];
//    [imageView setNeedsDisplay];
//    imageView.frame = JCFRAME_XYWH(100, 200, 100, 100);
    
//    CGRect rect = (CGRect){0.f,0.f,100, 100};
//    
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, [UIScreen mainScreen].scale);
    
//    CGMutablePathRef *pathRef = CGPathCreateWithPoints(6, CGPointMake(50, 0), CGPointMake(50, 0),)

    
    //根据矩形画带圆角的曲线
//    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
//    [self drawInRect:rect];
//    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //关闭上下文
//    UIGraphicsEndImageContext();
}

- (void)button1E:(id)sender {
    [self.mvpPresenter event1];
    
    [self.navigationItem startLoadingAnimating];
}

- (void)button2E:(id)sender {
    [self.mvpPresenter event2];
    
    [self.navigationItem stopLoadingAnimating];
}

- (void)button3E:(id)sender {
    self.string = [NSString stringWithFormat:@"%d",arc4random()/1000];
}

- (void)addButons {
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.backgroundColor = [UIColor lightGrayColor];
    [button1 addTarget:self action:@selector(button1E:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(20, 74, 100, 40);
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.backgroundColor = [UIColor grayColor];
    [button2 addTarget:self action:@selector(button2E:) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(20, 124, 100, 40);
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.backgroundColor = [UIColor grayColor];
    [button3 addTarget:self.mvpPresenter.mvpSignal action:@selector(sendSubscriptionNumber:withValue:) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(20, 174, 100, 40);
    [self.view addSubview:button3];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:button3 callback:^(UIButton *sender) {
        NSLog(@"点击了button3: %@", sender);
    }];
}

- (void)addUIBarButtonItem {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_shareUser"] style:UIBarButtonItemStyleDone actionBlock:^(id sender) {
        NSLog(@"dianjillllllll");
         NSLog(@"relativeRect:%@", NSStringFromCGRect(relativeRect(self.navigationItem.rightBarButtonItem)));
    }];
    self.navigationItem.rightBarButtonItem = button;
    self.navigationItem.rightBarButtonItem.width = 100;
    NSLog(@"relativeRect:%@", NSStringFromCGRect(relativeRect(self.navigationItem.rightBarButtonItem)));
}

- (void)sss {
    NSLog(@"dianjillllllll");
    NSLog(@"relativeRect:%@", NSStringFromCGRect(relativeRect(self.navigationItem.rightBarButtonItem)));
}

CGRect relativeRect(UIBarButtonItem *barButtonItem)
{
    UIButton *button = [barButtonItem valueForKey:@"view"];
    return [button.superview convertRect:button.frame fromView:button.superview];
}


#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.string = @"1";
    
    self.mvpPresenter = [[JCMVPPresenter alloc] init];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:@"button1" callback:^(NSString *value){
        NSLog(@"button1: %@",value);
    }];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:@"button2" callback:^(NSString *value){
        NSLog(@"button2: %@",value);
    }];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:@"stringKVO" observe:self keyPath:@"string"];
    
    [self.mvpPresenter.mvpSignal subscriptionNumber:@"stringKVO" callback:^(JCMVPViewController *vc, NSString *newS, NSString *oldS){
        NSLog(@"VC:%@; new:%@; old:%@",vc,newS,oldS);
    }];
    
    [self addButons];
    [self addUIBarButtonItem];
    NSLog(@"====ooo:%@",[(id)self.navigationItem.rightBarButtonItem view]);
    
    [self imageHexagon];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    self.navigationItem.rightBarButtonItem.badgeValue = @"12";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"View已经消失");
    self.mvpPresenter = nil;
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
