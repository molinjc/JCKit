//
//  ViewController.m
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "ViewController.h"
#import "JCKitMacro.h"

#import "UIImage+JCImage.h"
#import "NSObject+JCObject.h"

#import "NSObject+JCStram.h"

#if __has_include("NSObject+JCObserverKVO.h")
#define kSCALE 2.0
#else
#define kSCALE 1.0
#endif

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JCKit Example";
    [self addCell:@"Foundation Example" class:@"JCFoundationExampleViewController"];
    [self addCell:@"UIKit Example" class:@"JCUIKitExampleViewController"];
    [self addCell:@"CustomerUI Example" class:@"JCCustomerDemoViewController"];
    [self.view addSubview:self.imageView];
    self.imageView.frame = CGRectMake(0, 0, 200, 150);
    self.imageView.center = self.view.center;
    
    [[self.imageView.addStream addKeyPath:@"image"] observeValueForBlock:^(__weak id obj, NSString *keyPath, id oldValue, id newValue) {
        NSLog(@"keyPath:%@",keyPath);
    }];
    JCLog(@"%f",kSCALE);
    [self test_Array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageView.image = [UIImage imageNamed:@"banner1"];
    
    /*
     UIImageOrientationUp: 正常
     UIImageOrientationDown: 180度倒
     UIImageOrientationLeft: 顺时针旋转270度，向左
     UIImageOrientationRight: 顺时针旋转90度，向右
     UIImageOrientationUpMirrored: 翻转，像照镜子里的样子
     UIImageOrientationDownMirrored: 180度倒 翻转
     UIImageOrientationLeftMirrored: 顺时针旋转270度，向左翻转
     UIImageOrientationRightMirrored: 顺时针旋转90度，向右翻转
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)
#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - Test Methods(测试方法)

- (void)test_String {
    NSString *string = @"   Lorem    Ipsum dolar  12345  sit  amet.     ";
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    string = [components componentsJoinedByString:@" "];
    JCLog(@"string:%@",string);
    
    NSString *v = @"1.9.3";
    NSString *v1 = @"0.a.0";
//    vstring characterAtIndex:0];
    int sum = 0;
    int sum1 = 0;
    for (int i=0; i<v.length; i++) {
        int s = [v characterAtIndex:i];
        int s1 = [v1 characterAtIndex:i];
        JCLog(@"%d -- %d",s,s1);
        sum += s;
        sum1 += s1;
    }
    JCLog(@"sum:%d--%d",sum,sum1);
    if (sum1 > sum) {
        JCLog(@"%@",v1);
    }else {
        JCLog(@"%@",v);
    }
}

/**
 *  测试数组遍历
 */
- (void)test_Array {
    NSArray *array = @[@1,@2,@3,@4,@5];
    
    // NSEnumerationConcurrent：各个Block是同时开始执行的。这样遍历的完成顺序是不确定的
    // NSEnumerationReverse：以反序方式遍历。
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    }];
    
    // 一个个遍历
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        JCLog(@"%zd --%@",idx,obj);
    }];
    
    NSUInteger index = [array indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JCLog(@"%zd --%@",idx,obj);
        if (idx == 3) {
            return YES;
        }
        return NO;
    }];
    
    //indexesOfObjectsPassingTest
    
    JCLog(@"%zd",index);
}

@end
