//
//  JCDrawViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/16.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCDrawViewController.h"

@interface JCDrawDemo1 : UIView

@end

@implementation JCDrawDemo1

- (void)drawRect:(CGRect)rect {
    
    [self drawOrdinary:rect];
//    [self drawTransparency:rect];
    
//    float width = rect.size.width/2;
//    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
//    CGSize  myShadowOffset = CGSizeMake (10, -20);
//    
//    CGContextRef myContext = UIGraphicsGetCurrentContext();
//    //设置阴影
//    CGContextSetShadow(myContext, myShadowOffset, 10);
//    CGContextSetRGBFillColor (myContext, 0, 1, 0, 1);
//    CGContextFillEllipseInRect(myContext, CGRectMake(center.x-width/2, center.y-width/4*3, width, width));
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //进行坐标系的翻转
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGImageRef background = [UIImage imageNamed:@"banner1"].CGImage;
    CGContextSetBlendMode(contextRef, kCGBlendModeDifference);
    CGContextDrawImage(contextRef, CGRectMake(60, 25, 200, 150), background);
    
//    CGImageRef orignImage = [UIImage imageNamed:@"tabbar_mainframe"].CGImage;
//    CGContextDrawImage(contextRef, CGRectMake(60, 40, 40, 40), orignImage);
    CGImageRelease(background);
//    CGImageRelease(orignImage);
}

/**
 层聚合
 */
- (void)drawTransparency:(CGRect)rect {
    float width = rect.size.width/2;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGSize          myShadowOffset = CGSizeMake (10, -20);
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextSetShadow (myContext, myShadowOffset, 10);
    CGContextBeginTransparencyLayer (myContext, NULL);
    //开启图形聚合绘制
    //之后的绘制代码都将绘制到统一层上
    CGContextSetRGBFillColor (myContext, 0, 255/255, 0, 255/255);
    CGContextFillEllipseInRect(myContext, CGRectMake(center.x-width/2, center.y-width/4*3, width, width));
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 1);
    CGContextFillEllipseInRect(myContext, CGRectMake(center.x-width/4, center.y-width/4, width, width));
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 1);
    CGContextFillEllipseInRect(myContext, CGRectMake(center.x-width/4*3, center.y-width/4, width, width));
    //结束聚合绘制
    CGContextEndTransparencyLayer (myContext);
}

/**
 普通
 */
- (void)drawOrdinary:(CGRect)rect {
    float width = rect.size.width/2;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGSize  myShadowOffset = CGSizeMake (10, -20);
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    //设置阴影
    CGContextSetShadow (myContext, myShadowOffset, 10);
    //绘制三个圆形
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 1);
    CGContextFillEllipseInRect(myContext, CGRectMake(center.x-width/2, center.y-width/4*3, width, width*2));
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 1);
    CGContextFillEllipseInRect(myContext, CGRectMake(center.x-width/4, center.y-width/4, width, width));
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 1);
    CGContextFillEllipseInRect(myContext, CGRectMake(center.x-width/4*3, center.y-width/4, width, width));

}

@end


@interface JCDrawViewController ()

@end

@implementation JCDrawViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test1 {
    JCDrawDemo1 *demo1 = [[JCDrawDemo1 alloc] init];
    demo1.backgroundColor = [UIColor whiteColor];
    demo1.frame = self.view.bounds;
    [self.view addSubview:demo1];
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
