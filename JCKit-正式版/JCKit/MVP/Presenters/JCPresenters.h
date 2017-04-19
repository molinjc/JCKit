//
//  JCPresenters.h
//
//  Created by molin.JC on 2017/3/23.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSignal.h"

#pragma mark - 网络请求

/** 网络请求 */
@protocol JCRequestProtocol <NSObject>
@optional

/** 请求, 无回调 */
- (void)requestNotCallback;

/** 请求某订阅号, 可以调用requestWithSubscriptionNumber:params:callback:, params传nil */
- (void)requestWithSubscriptionNumber:(NSString *)subscriptionNumber callback:(callbackBlock)block;

/** 请求某订阅号, 在方法里要先用signal调用subscriptionNumber: callback:, 结果回来再调用sendSubscriptionNumber: */
- (void)requestWithSubscriptionNumber:(NSString *)subscriptionNumber params:(id)params callback:(callbackBlock)block;

/** 请求某接口, 可以调用requestWithInterface:params:callback:, params传nil */
- (void)requestWithInterface:(NSString *)interface callback:(callbackBlock)block;

/** 请求某接口, 先拼接请求接口, 以interface做订阅号, 在方法里要先用signal调用subscriptionNumber: callback:, 结果回来再调用sendSubscriptionNumber: */
- (void)requestWithInterface:(NSString *)interface params:(id)params callback:(callbackBlock)block;

/** 请求失败, 都回调这个, 那么就要先设定失败的订阅号, 请求失败signal就发送这个失败订阅号 */
- (void)signalWithRequestFail:(callbackBlock)block;

/** 请求某类型, type由子类判断, 符合某个就去请求某个接口, 可能要跟以上几个方法配合使用 */
- (void)requestWithType:(NSInteger)type params:(id)params callback:(callbackBlock)block;

@end

#pragma mark - 表格界面的常用方法与属性

/** 表格界面的常用方法与属性 */
@protocol JCTableDatasProtocol <NSObject>

/** 表格数据 */
@property (nonatomic, strong) NSMutableArray *tableDatas;

/** 页数 */
@property (nonatomic, assign) NSInteger tablePage;

/** 重新加载表格数据 */
- (void)reloadTableData;

/** 加载下一页表格数据 */
- (void)loadNextTableData;

@end

#pragma mark - 九宫格界面的常用方法与属性

/** 九宫格界面的常用方法与属性 */
@protocol JCCollectionDatasProtocol <NSObject>

/** 九宫格数据 */
@property (nonatomic, strong) NSMutableArray *collectionDatas;

/** 页数 */
@property (nonatomic, assign) NSInteger collectionPage;

/** 重新加载九宫格数据 */
- (void)reloadCollectionData;

/** 加载下一页九宫格数据 */
- (void)loadNextCollectionData;

@end

#pragma mark - 与ViewController交互

/** 与ViewController交互 */
@protocol JCViewControllerProtocol <NSObject>

/** 引用控制器 */
@property (nonatomic, weak) UIViewController *viewController;

/** 用于跳转的控制器 */
@property (nonatomic, weak) UINavigationController *pushController;

/**
 push(跳转)ViewController, 需设置某些数据
 @param model 对应的model
 */
- (void)pushViewControllerWithModel:(id)model;

/**
 根据类名push(跳转)ViewController,
 @param name 类名
 */
- (void)pushViewControllerWithClassName:(NSString *)name;

@end

#pragma mark - 登录协议

/** 登录协议 */
@protocol JCSignInProtoco <NSObject>

/**
 登录
 @param account 账号
 @param password 密码
 */
- (void)signInWithAccount:(NSString *)account password:(NSString *)password;

@end

#pragma mark - 注册协议

/** 注册协议 */
@protocol JCSignUpProtoco <NSObject>

/**
 注册
 @param data 用户的数据
 */
- (void)signUpWithUserData:(NSDictionary *)data;

@optional

/**
 注册时的手机验证码
 @param phone 手机号
 */
- (void)signUpVerificationCodeWithPhone:(NSString *)phone;

@end

#pragma mark - 忘记密码

/** 忘记密码 */
@protocol JCforgetPasswordProtocol <NSObject>

/**
 忘记密码
 @param data 用户的数据
 */
- (void)forgetPasswordWithUserData:(NSDictionary *)data;

@optional

/**
 忘记密码时的手机验证码
 @param phone 手机号
 */
- (void)forgetPasswordVerificationCodeWithPhone:(NSString *)phone;

@end

#pragma mark - JCPresenters

@interface JCPresenters : NSObject

/** signal作为Presenters对viewController的回调类 */
@property (nonatomic, strong) JCSignal *signal;

/** 创建 */
+ (instancetype)presenters;

@end

#pragma mark - JCViewControllerPresenters

/** 实现与ViewController交互的基类 */
@interface JCViewControllerPresenters : JCPresenters <JCViewControllerProtocol>

/** 创建 */
+ (instancetype)presentersWithViewController:(UIViewController *)viewController;

@end
