//
//  JCQRCodeScanView.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 做为扫描二维码的视图基类，动画，视图样式由子类去完成，扫描功能基类完成
 */
@interface JCQRCodeScanViewBase : UIView

@property (nonatomic, copy) void (^deviceError)();              // 无法访问相机
@property (nonatomic, copy) void (^QRCodeContext)(NSString *);  // 扫描到二维码内容

- (void)startScan;

- (void)stopScan;

@end
