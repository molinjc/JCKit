//
//  JCUIPasteboardViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/30.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCUIPasteboardViewController.h"
#import "UIImage+JCImage.h"

@interface _JCCopyView : UIView
{
    __weak id _copyview;
}
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@end

@implementation _JCCopyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView1];
        [self addSubview:self.imageView2];
        [self addSubview:self.label1];
        [self addSubview:self.label2];
    }
    return self;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    NSArray* methodNameArr = @[@"copy:",@"cut:",@"select:",@"selectAll:",@"paste:"];
    if ([methodNameArr containsObject:NSStringFromSelector(action)]) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)copy:(id)sender{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
//    [pasteboard setImage:self.imageView1.image];
//    [pasteboard setString:self.label1.text];
    
    if ([_copyview isKindOfClass:[UILabel class]]) {
        UILabel *_label = _copyview;
        [pasteboard setString:_label.text];
    }else if ([_copyview isKindOfClass:[UIImageView class]]) {
        UIImageView *_imageView = _copyview;
        [pasteboard setImage:_imageView.image];
    }
    
}

-(void)paste:(id)sender{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    /*
    if (pasteboard) {  // 这里要做判断，为空会崩溃
        self.imageView2.image = [pasteboard image];
        self.label2.text = [pasteboard string];
    } */
    
    if (!pasteboard) {
        return;
    }
    
    if ([_copyview isKindOfClass:[UILabel class]]) {
        UILabel *_label = _copyview;
        _label.text = [pasteboard string];
    }else if ([_copyview isKindOfClass:[UIImageView class]]) {
        UIImageView *_imageView = _copyview;
        _imageView.image = [pasteboard image];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    UIMenuController* menuController = [UIMenuController sharedMenuController];
    BOOL is = YES;
    for (UIView *_sub in self.subviews) {
        if (CGRectContainsPoint(_sub.frame, point)) {
            _copyview = _sub;
            [menuController setTargetRect:_sub.frame inView:self];
            is = NO;
        }
    }
    
    if (is) {
        [menuController setMenuVisible:NO animated:YES];
    }else {
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.frame = CGRectMake(10, 74, self.frame.size.width-20, 200);
//        _imageView1.image = [UIImage imageNamed:@"1"];
        _imageView1.image = [UIImage animatedGIFNamed:@"waiting"];
    }
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.frame = CGRectMake(10, 284, self.frame.size.width-20, 200);
        _imageView2.backgroundColor = [UIColor lightGrayColor];
    }
    return _imageView2;
}

- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.frame = CGRectMake(10, 495, self.frame.size.width-20, 20);
        _label1.backgroundColor = [UIColor lightGrayColor];
        _label1.text = @"3456789fghjk";
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.frame = CGRectMake(10, 525, self.frame.size.width-20, 20);
        _label2.backgroundColor = [UIColor lightGrayColor];
    }
    return _label2;
}

@end


@interface JCUIPasteboardViewController ()

@end

@implementation JCUIPasteboardViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _JCCopyView *copyView = [[_JCCopyView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:copyView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Private Methods(自定义方法，只有自己调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)
@end
