//
//  JCProgressHUD.m
//
//  Created by molin.JC on 2017/3/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCProgressHUD.h"

#define ProgressHUDTag_Bottom 114
#define ProgressHUDTag_Custom 115
#define ProgressHUDTag_indicator 116

@interface JCProgressHUD ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** 记录showImagePicker方法的回调block */
@property (nonatomic, copy) void (^imagePickerBlock)(UIImage *image);
@end

@implementation JCProgressHUD


+ (void)showFullCustomRemindView:(UIView *)remindView {
    UIView *root = [UIApplication sharedApplication].keyWindow;
    JCProgressHUD *view = [[JCProgressHUD alloc] init];
    view.frame = [UIScreen mainScreen].bounds;
    [view addSubview:remindView];
    [root performSelectorOnMainThread:@selector(addSubview:) withObject:view waitUntilDone:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self removeFromSuperview];
}

#pragma mark -

+ (void)startActivityIndicator {
    UIView *root = [UIApplication sharedApplication].keyWindow;
    UIView *view = [root viewWithTag:ProgressHUDTag_indicator];
    if (!view) {
        view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0.174 alpha:1.000];
        view.layer.cornerRadius = 7;
        view.tag = ProgressHUDTag_indicator;
        view.frame = CGRectMake(0, 0, 50, 50);
        view.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5,
                                  [UIScreen mainScreen].bounds.size.height * 0.5);
    
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.center = CGPointMake(25, 25);
        [view addSubview:indicatorView];
        [root performSelectorOnMainThread:@selector(addSubview:) withObject:view waitUntilDone:YES];
        [indicatorView startAnimating];
    }
}

+ (void)stopActivityIndicator {
    UIView *root = [UIApplication sharedApplication].keyWindow;
    UIView *indicatorView = [root viewWithTag:ProgressHUDTag_indicator];
    if (indicatorView) {
        [(UIActivityIndicatorView *)indicatorView.subviews.lastObject stopAnimating];
        [indicatorView removeFromSuperview];
    }
}

#pragma mark -

+ (void)alertControllerWithActionTitle:(NSString *)actionTitle
                                 title:(NSString *)title
                               message:(NSString *)message
                               handler:(void (^)())handler {
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    
    [self alertControllerWithActions:@[alertAction] title:title message:message];
}

+ (void)alertControllerCancelWithTitle:(NSString *)title
                               message:(NSString *)message
                               handler:(void (^)())handler {
    
    UIAlertAction *alertAction_0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *alertAction_1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    
    [self alertControllerWithActions:@[alertAction_0, alertAction_1] title:title message:message];
}

+ (void)alertControllerWithActions:(NSArray <UIAlertAction *> *)actions
                             title:(NSString *)title
                           message:(NSString *)message {
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self alertControllerWithController:root actions:actions title:title message:message style:UIAlertControllerStyleAlert];
}

+ (void)alertControllerWithController:(UIViewController *)viewController
                              actions:(NSArray <UIAlertAction *> *)actions
                                title:(NSString *)title
                              message:(NSString *)message
                                style:(UIAlertControllerStyle)style {
    
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                              message:message
                                                                       preferredStyle:style];
    for (UIAlertAction *action in actions) {
        [alertController addAction:action];
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)showImagePicker:(void (^)(UIImage *image))block {
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self _imagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera handler:block];
    }];
    
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self _imagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary handler:block];
    }];
    
    UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self alertControllerWithController:root
                                actions:@[alertAction1, alertAction2, alertAction3]
                                  title:nil
                                message:nil
                                  style:UIAlertControllerStyleActionSheet];
}

#pragma mark -

+ (void)showCustomRemindView:(UIView *)remindView {
    [remindView removeFromSuperview];
    UIView *root = [UIApplication sharedApplication].keyWindow;
    UILabel *previousView = [root viewWithTag:ProgressHUDTag_Custom];
    [previousView removeFromSuperview];
    
    remindView.tag = ProgressHUDTag_Custom;
    [root performSelectorOnMainThread:@selector(addSubview:) withObject:remindView waitUntilDone:YES];
    [self  performSelectorOnMainThread:@selector(_stopBottomRemind:) withObject:remindView waitUntilDone:YES];
}

+ (void)showBottomRemind:(NSString *)message {
    UIView *root = [UIApplication sharedApplication].keyWindow;
    UILabel *remindView = [root viewWithTag:ProgressHUDTag_Bottom];
    
    if (!remindView) {
        remindView = [[UILabel alloc] init];
        remindView.tag = ProgressHUDTag_Bottom;
        remindView.backgroundColor = [UIColor colorWithWhite:0.174 alpha:1.000];
        remindView.layer.cornerRadius = 7;
        remindView.layer.masksToBounds = YES;
        remindView.textColor = [UIColor whiteColor];
        remindView.font=[UIFont systemFontOfSize:13];
        remindView.textAlignment=NSTextAlignmentCenter;
        remindView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.25, [UIScreen mainScreen].bounds.size.height - 104, [UIScreen mainScreen].bounds.size.width * 0.5, 40);
        [root performSelectorOnMainThread:@selector(addSubview:) withObject:remindView waitUntilDone:YES];
    }
    
    remindView.text = message;
    [self  performSelectorOnMainThread:@selector(_stopBottomRemind:) withObject:remindView waitUntilDone:YES];
}

+ (void)_stopBottomRemind:(UILabel *)remindView {
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(_dismissBottomRemind:) userInfo:remindView repeats:NO];
}

+ (void)_dismissBottomRemind:(NSTimer *)timer {
    UIView *remindView = [timer userInfo];
    [remindView removeFromSuperview];
}

#pragma mark - 私有方法

/** 选择拍照或相册 */
+ (void)_imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType handler:(void (^)(UIImage *image))block {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = sourceType;
    
    JCProgressHUD *view = [[JCProgressHUD alloc] init];
    view.hidden = YES;
    view.imagePickerBlock = [block copy];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root.view addSubview:view];
    
    imagePicker.delegate = view;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - delegate

/** UIImagePickerController的回调 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.imagePickerBlock) {
        self.imagePickerBlock([info objectForKey:UIImagePickerControllerOriginalImage]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
