//
//  JCAnimationViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/5.
//  Copyright © 2016年 molin. All rights reserved.
//

/**
 UIBezierPath:
 使用UIBezierPath类可以创建基于矢量的路径，它是Core Graphics框架关于CGPathRef类型数据的封装，利用它创建直线或者曲线来构建我们想要的形状，每一个直线段或者曲线段的结束位置就是下一个线段开始的地方。这些连接的直线或者曲线的集合成为subpath。一个UIBezierPath对象的完整路径包括一个或者多个subpath。
 创建一个完整的UIBezierPath对象的完整步骤如下：
     创建一个Bezier Path对象。
     使用方法moveToPoint:去设置初始线段的起点。
     添加line或者curve去定义一个或者多个subpath。
     修改UIBezierPath对象跟绘图相关的属性
 
 CAShapeLayer
 CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类。CAShapeLayer可以用来绘制所有通过CGPath来表示的形状，上面讲到了可以用UIBezierPath来创建任何你想要的路径，使用CAShapeLayer的属性path配合UIBezierPath创建的路径，就可以呈现出我们想要的形状。
 这个形状不一定要闭合，图层路径也不一定是连续不断的，你可以在CAShapeLayer的图层上绘制好几个不同的形状，但是你只有一次机会去设置它的path、lineWith、lineCap等属性，如果你想同时设置几个不同颜色的多个形状，你就需要为每个形状准备一个图层。
 
 mask
 CALayer有一个属性叫做mask，通常被称为蒙版图层，这个属性本身也是CALayer类型，有和其他图层一样的绘制和布局属性。它类似于一个子视图，相对于父图层（即拥有该属性的图层）布局，但是它却不是一个普通的子视图。不同于一般的subLayer，mask定义了父图层的可见区域，简单点说就是最终父视图显示的形态是父视图自身和它的属性mask的交集部分。
 mask图层的color属性是无关紧要的，真正重要的是它的轮廓，mask属性就像一个切割机，父视图被mask切割，相交的部分会留下，其他的部分则被丢弃。
 CALayer的蒙版图层真正厉害的地方在于蒙版图层不局限于静态图，任何有图层构成的都可以作为mask属性，这意味着蒙版可以通过代码甚至是动画实时生成。这也为我们实现示例中波浪的变化提供了支持。
 */
#import "JCAnimationViewController.h"
#import "JCKitMacro.h"

@interface JCAnimationViewController ()

@end

@implementation JCAnimationViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

#define MASBoxValue(value) JCBoxValue(@encode(__typeof__((value))), (value))

- (void)test {
    CGPoint point = CGPointMake(12, 12);
    JCLog(@"%@",_JCBoxValue(@encode(__typeof__((point))),point));
    NSValue *value = _JCBoxValue(@encode(__typeof__((point))),point);
    CGPoint point1 ;
    [value getValue:&point1];
    JCLog(@"%@",NSStringFromCGPoint(point1));
    
    NSObject *obj1 = [NSObject new];
    NSObject *obj2 = [NSObject new];
    NSObject *obj3 = [NSObject new];
    NSDictionary *dic = NSDictionaryOfVariableBindings(obj1,obj2,obj3);
#define kGETName(value) [NSString stringWithFormat:@"%@",@"" # value]
    
    JCLog(@"%@\n%@",dic,kGETName(con));
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCell:@"火柴人" class:@"JCMatchmanViewController"];
    [self addCell:@"波浪" class:@"JCWaveViewController"];
    [self addCell:@"CoreGraphics 层聚合" class:@"JCDrawViewController"];
    
    [self test];
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
