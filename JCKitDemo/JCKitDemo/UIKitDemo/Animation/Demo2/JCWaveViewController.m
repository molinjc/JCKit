//
//  JCWaveViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/15.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCWaveViewController.h"
#import "JCGraphicsUtilities.h"

@interface JCWaveViewController ()

@property (nonatomic, strong) CAShapeLayer *waveLayer2;

@property (nonatomic, strong) UIImageView *headView;

@property (nonatomic, strong) CADisplayLink *wavesDisplayLink;

@end

@implementation JCWaveViewController
{
    CGFloat _waveA;//水纹振幅
    CGFloat _waveW;//水纹周期
    CGFloat _drift; //位移
    CGFloat _wavesSpeed;//水纹速度
    CGSize  _waveSize;
}
#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)wave1 {
    CAShapeLayer *waveLayer = [CAShapeLayer layer];
    waveLayer.fillColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1].CGColor;
    waveLayer.frame = CGRectMake(0, 64, self.view.frame.size.width, 220);
    JCWaveShapeLayer(waveLayer, 12, 0.5/30.0, 0.02, CGSizeMake(self.view.frame.size.width, 110));
    [self.view.layer addSublayer:waveLayer];
}

- (void)wave2 {
    _waveA = 12;
    _waveW = 0.5/30.0;
    _drift = 0.02;
    _wavesSpeed = 0.04;
    _waveSize = CGSizeMake(self.view.frame.size.width, 110);
    
    self.waveLayer2 = [CAShapeLayer layer];
    self.waveLayer2.fillColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1].CGColor;
    self.waveLayer2.frame = CGRectMake(0, 284, self.view.frame.size.width, 220);
    JCWaveShapeLayer(self.waveLayer2, _waveA, _waveW, _drift, _waveSize);
    [self.view.layer addSublayer:self.waveLayer2];

    
    _wavesDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave:)];
    [_wavesDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)wave3 {
    [self wave2];
    
    _headView = [[UIImageView alloc] init];
    _headView.image = [UIImage imageNamed:@"banner1"];
    
    CGFloat centX = self.view.frame.size.width / 2;
    CGFloat CentY = _waveA * sin(_waveW * centX + _drift) + 344;
    
    _headView.frame = CGRectMake(self.view.frame.size.width * 0.5 - 25, CentY, 50, 50);
    [self.view addSubview:_headView];
}

- (void)updateWave:(CADisplayLink *)displayLink {
    _drift += _wavesSpeed;
    JCWaveShapeLayer(self.waveLayer2, _waveA, _waveW, _drift, _waveSize);
    
    CGFloat centX = self.view.frame.size.width / 2;
    CGFloat CentY = _waveA * sin(_waveW * centX + _drift) + 344;
    _headView.frame = CGRectMake(self.view.frame.size.width * 0.5 - 25, CentY, 50, 50);
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self wave1];
//    [self wave2];
    [self wave3];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_wavesDisplayLink invalidate];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
