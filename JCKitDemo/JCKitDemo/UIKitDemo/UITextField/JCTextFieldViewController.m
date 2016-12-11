//
//  JCTextFieldViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCTextFieldViewController.h"
#import "UITextField+JCTextField.h"

@interface JCTextFieldViewController ()

@property (nonatomic, strong) UITextField *textField1;

@end

@implementation JCTextFieldViewController

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textField1];
    [self test1];
    [self test2];
    [self testButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test1 {
    [self.textField1 addPredicate:@"\\d{11}$" action:^(BOOL isP) {
        NSLog(@"isP: %d",isP);
    }];
}

- (void)test2 {
    [self.textField1 addPredicate:@"\\d{10}" notificationName:@"testP"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textWithNotification:) name:@"testP" object:nil];
}

- (void)textWithNotification:(NSNotification *)sender {
    NSLog(@"%@",sender);
}


- (void)testButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"下载" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    button.frame = CGRectMake(10, 300, 100, 50);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonEvent:(UIButton *)sender {
    sender.titleLabel.hidden = YES;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = sender.bounds;
//    indicator.center = CGPointMake(sender.frame.size.width / 2, sender.frame.size.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
//    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [sender addSubview:indicator];
}

#pragma mark - Custom Methods(自定义方法，外部可调用)
#pragma mark - Custom Delegate(自定义的代理)
#pragma mark - System Delegate(系统类的代理)
#pragma mark - Setter/Getter(懒加载)

- (UITextField *)textField1 {
    if (!_textField1) {
        _textField1 = [[UITextField alloc] init];
        _textField1.backgroundColor = [UIColor grayColor];
        _textField1.frame = CGRectMake(10, 64, self.view.frame.size.width - 20, 40);
        _textField1.placeholder = @"ssssssss";
    }
    return _textField1;
}

@end
