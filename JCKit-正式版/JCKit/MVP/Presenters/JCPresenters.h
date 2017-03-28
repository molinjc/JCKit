//
//  JCPresenters.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/3/23.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JCSignal.h"

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

/** 登录协议 */
@protocol JCSignInProtoco <NSObject>

/**
 登录
 @param account 账号
 @param password 密码
 */
- (void)signInWithAccount:(NSString *)account password:(NSString *)password;

@end

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

@interface JCPresenters : NSObject

/** signal作为Presenters对viewController的回调类 */
@property (nonatomic, strong) JCSignal *signal;

@end

