//
//  JCKeyboardManager.m
//  JCKeyboardTest
//
//  Created by 林建川 on 16/10/11.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCKeyboardManager.h"
#import <UIKit/UIKit.h>
#import "UIView+JCView.h"

@interface JCKeyboardManager ()
{
    __weak UIView *_textFieldView;
    CGFloat        _animationDuration;
    CGFloat        _keyboardHeight;
    CGRect         _oldRect;
    BOOL           _animationDown;
}

@end

@implementation JCKeyboardManager

#pragma mark - init(初始化)

+ (instancetype)shareManager {
    static JCKeyboardManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.enable = YES;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        });
    }
    return self;
}

#pragma mark - System Methods(系统方法)

- (void)dealloc {
    self.enable = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)

/**
 UITextViewTextDidBeginEditingNotification/UITextFieldTextDidBeginEditingNotification的通知回调方法
 得到_textFieldView，根据条件是否要添加toolbar
 UITextView和UITextField的通知机制是不一样的，
 UITextField：会先调textFieldViewDidBeginEditing方法再调keyboardWillShow
 UITextView：会先调keyboardWillShow方法再调textFieldViewDidBeginEditing
 */
- (void)textFieldViewDidBeginEditing:(NSNotification *)notification {
    _textFieldView = notification.object;
    if ([_textFieldView isKindOfClass:[UITextField class]] && self.accompanyToolbar) {
        UITextField *textF = (UITextField *)_textFieldView;
        [textF setInputAccessoryView:self.toolbar];
    }else if ([_textFieldView isKindOfClass:[UITextView class]]) {
        if (self.accompanyToolbar) {
            UITextView *textView = (UITextView *)_textFieldView;
            [textView setInputAccessoryView:self.toolbar];
        }
        _animationDuration = _animationDuration * 2;
        [self adjustFrame];
    }
}

-(void)textFieldViewDidEndEditing:(NSNotification*)notification {
    _textFieldView = nil;
}

/**
 UIKeyboardWillShowNotification的通知回调方法
 键盘即将显示
 拿到键盘高度
 */
- (void)keyboardWillShow:(NSNotification *)notification {
    _animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_animationDuration == 0.0) {
        _animationDuration = 0.25;
    }
    _keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (_textFieldView && [_textFieldView isKindOfClass:[UITextField class]]) {
        [self adjustFrame];
    }
}

/**
 UIKeyboardWillHideNotification的通知回调方法
 键盘即将没掉
 恢复视图位置
 */
- (void)keyboardWillHide:(NSNotification *)notification {
    if (_animationDown) {
        _animationDown = NO;
        [UIView animateWithDuration:_animationDuration animations:^{
            UIViewController *viewController = _textFieldView.viewController;
            viewController.view.frame = _oldRect;
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 UIBarButtonItem的事件回调方法，这里实现回收键盘
 */
- (void)down {
    if ([_textFieldView isKindOfClass:[UITextField class]]) {
        UITextField *textF = (UITextField *)_textFieldView;
        [textF resignFirstResponder];
    }else if ([_textFieldView isKindOfClass:[UITextView class]]) {
        UITextView *textV = (UITextView *)_textFieldView;
        [textV resignFirstResponder];
    }
}

/**
 调整视图位置
 将textField/textView所在的viewController的view上移到键盘之上
 */
- (void)adjustFrame {
    if (!self.enable) {
        return;
    }
    UIViewController *viewController = _textFieldView.viewController;
    CGRect textFieldViewRect = [[_textFieldView superview] convertRect:_textFieldView.frame toView:viewController.view];
    CGFloat textViewBottom = [UIScreen mainScreen].bounds.size.height - (textFieldViewRect.size.height + textFieldViewRect.origin.y);
    if (textViewBottom < _keyboardHeight) {
        _animationDown = YES;
        [UIView animateWithDuration:_animationDuration animations:^{
            UIViewController *viewController = _textFieldView.viewController;
            CGRect rect = viewController.view.frame;
            _oldRect = rect;
            rect.origin.y = -(_keyboardHeight - textViewBottom) - 10;
            viewController.view.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }else if (viewController.view.frame.origin.y < 0) {
        [UIView animateWithDuration:_animationDuration animations:^{
            UIViewController *viewController = _textFieldView.viewController;
            CGRect rect = viewController.view.frame;
            _oldRect = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
            rect.origin.y = rect.origin.y + (textViewBottom - _keyboardHeight);
            if (rect.origin.y > 0) {
                rect.origin.y = 0;
            }
            viewController.view.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 创建UIToolbar对象
 */
- (UIToolbar *)toolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
//    [toolbar setTintColor:[UIColor whiteColor]];
    [toolbar setBarTintColor:[UIColor whiteColor]];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *down = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(down)];
    toolbar.items = @[down].mutableCopy;
    return toolbar;
}

#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

@end
