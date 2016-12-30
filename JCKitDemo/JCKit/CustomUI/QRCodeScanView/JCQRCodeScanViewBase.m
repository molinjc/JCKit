//
//  JCQRCodeScanView.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCQRCodeScanViewBase.h"
#import <AVFoundation/AVFoundation.h>

@interface JCQRCodeScanViewBase () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice  *device;
@end

@implementation JCQRCodeScanViewBase

- (instancetype)init {
    if (self = [super init]) {
        [self setApplicationNotification];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setApplicationNotification];
    }
    return self;
    
}

/**
 设置通知
 */
- (void)setApplicationNotification {
    //获取摄像设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)startScan {
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    if (!input) {
        if (self.deviceError) {
            self.deviceError();
        }
    }else {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        output.rectOfInterest = CGRectMake(0.1, 0, 0.9, 1);
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.layer.bounds;
        [self.layer insertSublayer:layer atIndex:0];
        //开始捕获
        [_session startRunning];
    }
}

- (void)stopScan {
    [self.session stopRunning];
}

/**
 关闭手电筒🔦
 */
- (void)torchOff {
    [_device lockForConfiguration:nil];
    [_device setTorchMode:AVCaptureTorchModeOff];
    [_device unlockForConfiguration];
}

/**
 打开手电筒🔦
 */
- (void)torchOn {
    [_device lockForConfiguration:nil];
    [_device setTorchMode:AVCaptureTorchModeOn];
    [_device unlockForConfiguration];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (self.QRCodeContext) {
            self.QRCodeContext(obj.stringValue);
        }
    }
}

#pragma mark - NSNotification

- (void)_applicationWillEnterForeground:(id)sender {
    [self.session  startRunning];
}

- (void)_applicationDidEnterBackground:(id)sender {
    [self.session stopRunning];
}


@end
