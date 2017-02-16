//
//  JCNSInvocationViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCNSInvocationViewController.h"
#import "NSInvocation+JCInvocation.h"

@interface JCNSInvocationViewController ()

@end

@implementation JCNSInvocationViewController

#pragma mark - Custom Methods(自定义方法，外部可调用)

#pragma mark - Private Methods(自定义方法，只有自己调用)

- (void)test1 {
    NSMethodSignature  *signature = [JCNSInvocationViewController instanceMethodSignatureForSelector:@selector(run:b:c:d:)];
    NSInvocation *invocation0 = [NSInvocation invocationWithMethodSignature:signature];
    invocation0.target = self;
    invocation0.selector = @selector(run:b:c:d:);
    [invocation0 arguments:@"1",@"2",nil,@"4" ];
    [invocation0 invoke];
}

- (void)run:(id)a b:(id)b c:(id)c d:(id)d {
    NSLog(@"test1:%@-%@-%@-%@",a,b,c,d);
}

- (void)test2 {
    void (^block)(NSString *ss, id, id) = ^(NSString *ss,id a, id b) {
        NSLog(@"block打印:%@-%@-%@",ss,a,b);
    };
    NSString *way = @"byCar";
    NSInvocation *invocation = [NSInvocation invocationWithBlockAndArguments:block, way, way, way];
    [invocation invoke];
}

- (void)test3 {
    NSMethodSignature  *signature = [JCNSInvocationViewController instanceMethodSignatureForSelector:@selector(run:b:c:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    NSLog(@"invocation:%@",invocation);
}

#pragma mark - ViewController Life Cycle(Viewcontroller的生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    [self test2];
    [self test3];
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
