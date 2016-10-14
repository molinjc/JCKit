//
//  JCStream.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/5.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCStream.h"
#import <objc/runtime.h>
#import "NSObject+JCObserverKVO.h"

/**
 Base
 */
@interface JCStream ()

@property (nonatomic, copy) void (^target_actionBlock)(id sender);

/**
 KVO的block
 */
@property (nonatomic, copy) JCObserverBlock observerBlock;

@property (nonatomic, copy) JCNotificationBlock notificationBlock;

/**
 持有该JCStream对象的类对象
 */
@property (nonatomic, weak) id hold;

@end

@implementation JCStream
{
    NSMutableArray *_observerKeyPaths;
    NSMutableArray *_notificationNames;
    NSMutableDictionary *_delegateBlockDic;
}

- (instancetype)initWithHold:(id)hold {
    if (self = [super init]) {
        self.hold = hold;
    }
    return self;
}

@end

/**
 KVO
 */
@implementation JCStream (JCObserver)

- (JCStream *)addKeyPath:(NSString *)keyPath {
    if (!_observerKeyPaths) {
        _observerKeyPaths = @[].mutableCopy;
    }
    if ([_observerKeyPaths containsObject:keyPath]) {
        return self;
    }
    [_observerKeyPaths addObject:keyPath];
    [self.hold addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    return self;
}

- (JCStream *)removeKeyPath:(NSString *)keyPath {
    [self.hold removeObserver:self forKeyPath:keyPath];
    [_observerKeyPaths removeObject:keyPath];
    return self;
}

- (JCStream *)removeAllKeyPath {
    [_observerKeyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeKeyPath:keyPath];
    }];
    [_observerKeyPaths removeAllObjects];
    return self;
}

- (JCStream *)observeValueForBlock:(JCObserverBlock)block {
    self.observerBlock = block;
    return self;
}

/**
 KVO回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    BOOL prior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    //只接受值改变时的消息
    if (prior) {
        return;
    }
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (changeKind != NSKeyValueChangeSetting) {
        return;
    }
    if (self.observerBlock) {
        self.observerBlock(object, keyPath, newVal, oldVal);
    };
}

@end

/**
 通知
 */
@implementation JCStream (JCNotification)


- (JCStream *)notificationForName:(NSString *)name {
    if (!_notificationNames) {
        _notificationNames = @[].mutableCopy;
    }
    if ([_notificationNames containsObject:name]) {
        return self;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCallback:) name:name object:nil];
    return self;
}

- (JCStream *)removeNotificationForName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [_notificationNames removeObject:name];
    return self;
}

- (JCStream *)removeAllNotificationName {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_notificationNames removeAllObjects];
    return self;
}

- (JCStream *)notificationBlock:(JCNotificationBlock)block {
    self.notificationBlock = block;
    return self;
}


/**
 通知的回调
 */
- (void)notificationCallback:(NSNotification *)notification {
    if (self.notificationBlock) {
        self.notificationBlock(notification);
    }
}

@end

/**
 add-Target
 */
@implementation JCStream (JCTarget)

- (instancetype)initWithControl:(UIControl *)contol {
    if (self = [super init]) {
        self.control = contol;
    }
    return self;
}

+ (instancetype)streamWithControl:(UIControl *)control {
    return [[JCStream alloc] initWithControl:control];
}

- (JCStream *)streamControlEvents:(UIControlEvents)controlEvents {
    [self.control addTarget:self action:@selector(streamActionCallback:) forControlEvents:controlEvents];
    return self;
}

// target_action回调block
- (JCStream *)streamActionBlock:(void (^)(id))block {
    self.target_actionBlock = block;
    return self;
}

// target_action调用的方法
- (void)streamActionCallback:(id)sender {
    if (self.target_actionBlock) {
        self.target_actionBlock(sender);
    }
}

@end

/**
 Delegate
 */
@implementation JCStream (JCDelegate)

- (instancetype)initWithDelegate:(id)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        _delegateBlockDic = @{}.mutableCopy;
    }
    return self;
}

- (JCStream *)addDelegateMethod:(SEL)selector block:(id)block {
    _delegateBlockDic[NSStringFromSelector(selector)] = [block copy];
    return self;
}

- (id)blockWithMethod:(SEL)selector {
    return _delegateBlockDic[NSStringFromSelector(selector)];
}

static void *const kDelegateMethodKey = @"DelegateMethodKey";

// 添加自己的方法，与selector交换
- (JCStream *)addDelegateMethod:(SEL)selector exchangeIMP:(IMP)exchangeIMP {
    NSMutableDictionary *methodDicM = objc_getAssociatedObject(self, kDelegateMethodKey);
    if (!methodDicM) {
        methodDicM = [NSMutableDictionary new];
        objc_setAssociatedObject(self, kDelegateMethodKey, methodDicM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSString *originallyName = NSStringFromSelector(selector);
    NSString *exchangeName = methodDicM[originallyName];
    
    // 存在了
    if (exchangeName) {
        return self;
    }
    exchangeName = [NSString stringWithFormat:@"jc_exchange_%@",originallyName];  // 新的方法名，也就是要添加的方法
    methodDicM[originallyName] = exchangeName;
    Method originallyM = class_getInstanceMethod([self.delegate class], selector);
    
    if (!originallyM) {  // 判断方法是否没实现，没有实现就添加方法进去，然后再次获取
        class_addMethod([self.delegate class], NSSelectorFromString(originallyName), (IMP)delegateMethodReality, "v@:");
        originallyM = class_getInstanceMethod([self.delegate class], selector);
    }
    
    // 添加要交换的方法，返回YES就两个交换
    if (class_addMethod([self.delegate class], NSSelectorFromString(exchangeName), exchangeIMP, method_getTypeEncoding(originallyM))) {
        Method exchangeM = class_getInstanceMethod([self.delegate class], NSSelectorFromString(exchangeName));
        method_exchangeImplementations(originallyM,exchangeM);
    };
    return self;
}

// 代理方法没实现，这个用来指定代理方法要实现的函数地址
void delegateMethodReality(id self, SEL _cmd) {
}

// 更改为自己设定的替换代理方法的方法
SEL delegateExchangeMethodName(SEL _cmd) {
    NSString *methodName = [NSString stringWithFormat:@"jc_exchange_%@",NSStringFromSelector(_cmd)];
    return NSSelectorFromString(methodName);
}

@end
