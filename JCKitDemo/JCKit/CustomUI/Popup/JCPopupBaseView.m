//
//  JCPopupBaseView.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCPopupBaseView.h"

#if __has_include("AppDelegate.h")
#import "AppDelegate.h"
#endif
#define AppDelegate [[UIApplication sharedApplication] delegate]

#if __has_include("NSString+JCString.h")
#import "NSString+JCString.h"
#endif

#if __has_include("NSTimer+JCBlock.h")
#import "NSTimer+JCBlock.h"
#endif

#if __has_include("UIAlertView+JCStream.h")
#import "UIAlertView+JCStream.h"
#endif

#if __has_include("UIImagePickerController+JCStream.h")
#import "UIImagePickerController+JCStream.h"
#endif

#define kPopupScreenSize [UIScreen mainScreen].bounds.size

@interface JCPopupBaseView ()

@property (nonatomic, copy) void (^touchStateBlock)(JCPopupViewTouch state);

@end

@implementation JCPopupBaseView

#pragma mark - init(初始化)

/**
 初始化方法，将外部的View添加进来
 @param view 外部的View
 */
- (instancetype)initWithPopupView:(UIView *)view {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:((float)((0x252525 & 0xFF0000) >> 16))/255.0 green:((float)((0x252525 & 0xFF00) >> 8))/255.0 blue:((float)(0x252525 & 0xFF))/255.0 alpha:0.7];
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:view];
    }
    return self;
}

#pragma mark - System Methods(系统方法)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchStateBlock) {
        self.touchStateBlock(0);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchStateBlock) {
        self.touchStateBlock(1);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchStateBlock) {
        self.touchStateBlock(2);
    }
}

#pragma mark - Custom Methods(自定义方法，外部可调用)

/**
 *  显示该页面
 */
- (void)show {
    [AppDelegate.window addSubview:self];
}

/**
 *  页面消失
 */
- (void)disappear {
    [self removeFromSuperview];
}

/**
 延时消失
 */
- (void)delayedDisappear:(NSTimeInterval)delay {
    [self performSelector:@selector(disappear) withObject:nil afterDelay:delay];
}

/**
 触摸状态
 */
- (void)touchesState:(void (^)(JCPopupViewTouch state))block {
    self.touchStateBlock = block;
}

#pragma mark - 底部提示框

+ (void)showPopupView:(NSString *)message {
    [JCPopupBaseView showPopupView:message buttom:64];
}

+ (void)showPopupView:(NSString *)message buttom:(CGFloat)buttom {
    if (!message || message.length == 0) {
        return;
    }
    
    JCPopupBaseView *popupView = [[JCPopupBaseView alloc] init];
    popupView.backgroundColor = [UIColor colorWithWhite:0.174 alpha:1.000];
    popupView.messageLabel.textColor = [UIColor whiteColor];
    popupView.messageLabel.textAlignment = NSTextAlignmentCenter;
    popupView.messageLabel.numberOfLines = 0;
    popupView.messageLabel.font = [UIFont systemFontOfSize:13];
    popupView.messageLabel.text = message;
    
    CGSize textSize = [message sizeForFont:popupView.messageLabel.font size:CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.8 - 5, [UIScreen mainScreen].bounds.size.height * 0.8 - 5)];
    CGFloat height = textSize.height < 25.0 ? 25.0 : textSize.height;
    popupView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * .5 - (textSize.width + 5) * .5, [UIScreen mainScreen].bounds.size.height - (buttom + height + 5), textSize.width + 5, height + 5);
    popupView.messageLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    popupView.messageLabel.center = CGPointMake(popupView.frame.size.width * 0.5, popupView.frame.size.height * 0.5);
    popupView.layer.cornerRadius = popupView.frame.size.height * 0.1;
    [AppDelegate.window performSelectorOnMainThread:@selector(addSubview:) withObject:popupView waitUntilDone:YES];
    [self  performSelectorOnMainThread:@selector(stop:) withObject:popupView waitUntilDone:YES];
}

#pragma mark - 弹窗

/**
 有确定的弹窗
 @param title   标题
 @param message 详情
 */
+ (void)popupWithTitle:(NSString *)title message:(NSString *)message {
    [JCPopupBaseView popupWithTitle:title message:message actionTitle:@"确定" handler:nil];
}

+ (void)popupWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)())block {
    [JCPopupBaseView popupWithTitle:title message:message actionTitle:@"确定" handler:^{
        if (block) {
            block();
        }
    }];
}

+ (void)popupWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    [JCPopupBaseView popupWithTitle:title message:message actionTitle1:actionTitle actionTitle2:nil];
}

+ (void)popupWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle handler:(void (^)())block {
    [JCPopupBaseView popupWithTitle:title message:message actionTitle1:actionTitle actionTitle2:nil handler:^(NSInteger selectIndex) {
        if (block) {
            block();
        }
    }];
}

+ (void)popupWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 {
    [JCPopupBaseView popupWithTitle:title message:message actionTitle1:actionTitle1 actionTitle2:actionTitle2 handler:nil];
}


/**
 弹窗
 *  @param title        标题
 *  @param message      详情
 *  @param actionTitle1 第一个(左边)按钮的标题
 *  @param actionTitle2 第二个(右边)按钮的标题
 */
+ (void)popupWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 handler:(void (^)(NSInteger selectIndex))block {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (actionTitle1.length) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(0);
            }
        }];
        [alertController addAction:alertAction];
    }
    if (actionTitle2.length) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(1);
            }
        }];
        [alertController addAction:alertAction];
    }
    [AppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
#else
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:actionTitle1 otherButtonTitles:actionTitle2, nil];
    alertView.clickedButtonBlock =  ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (block) {
            block(1);
        }
    };
    [alertView show];
#endif
}

#pragma mark - 选择照片

/**
 选择照片
 */
+ (void)photoSelectPopupView:(void (^)(UIImage *image))block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //sourceType 是用来确认用户界面的样式， 选择相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.finishPickingMediaWithInfo = ^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info){
            if (block) {
                block([info objectForKey:UIImagePickerControllerOriginalImage]);
            }
        };
        //允许编辑弹框
        imagePicker.allowsEditing = NO;
        //是用相机照相来获取图片
        imagePicker.sourceType = sourceType;
        //模态推出pickViewController
        [AppDelegate.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //sourceType 是用来确认用户界面样式，选择相册
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.finishPickingMediaWithInfo = ^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info){
            if (block) {
                block([info objectForKey:UIImagePickerControllerOriginalImage]);
            }
        };
        //允许编辑弹框
        imagePicker.allowsEditing = NO;
        //是用手机相册来获取图片的
        imagePicker.sourceType = sourceType;
        //模态推出pickViewController
        [AppDelegate.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [alertController addAction:alertAction3];
    [AppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

/**
 显示菊花视图
 @return 返回JCPopupBaseView对象，让外面去关闭弹窗
 */
+ (JCPopupBaseView *)showActivityIndicatorView {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 0, 80, 80);//CGSizeMake(80, 80);
    indicator.center = CGPointMake(kPopupScreenSize.width / 2, kPopupScreenSize.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    JCPopupBaseView *popupView = [[JCPopupBaseView alloc] initWithPopupView:indicator];
    [popupView show];
    return popupView;
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

+ (void)stop:(JCPopupBaseView *)view {
    __weak typeof(view) weakView = view;
    [NSTimer scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
        [weakView disappear];
    } repeats:NO];
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)

#pragma mark - UIAlertViewDelegate


#pragma mark - Setter/Getter(懒加载)

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        [self addSubview:_messageLabel];
    }
    return _messageLabel;
}

@end
