//
//  JCRequest.h
//
//  Created by molin.JC on 2017/4/10.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define kTimeoutInterval 30.0

/**
 如果项目没有包含JCReachability文件，就用AFNetworkReachabilityManager，那么就需要先创建AFNetworkReachabilityManager(使用单例sharedManager)->[AFNetworkReachabilityManager sharedManager]
 在调用该请求类(JCRequest)之前创建。
 在无网络时，result回调会回调一个JCRequest类，用来表示此时是没有网络的。
 */


/** JCFileItem表示一个文件，带有该文件要上传的一些数据 */
@interface JCFileItem : NSObject

/** 对应的key */
@property (nonatomic, copy) NSString *key;

/** 文件名 */
@property (nonatomic, copy) NSString *name;

/** 文件数据 */
@property (nonatomic, strong) NSData *data;

/** mimeType, 图片:image/jpeg */
@property (nonatomic, copy) NSString *type;
@end

#pragma mark -

/**
 请求出错枚举
 - JCRequestErrorStatusNotNetwork: 无网络
 - JCRequestErrorStatusMimeTypeError: 请求mimeType错误(200)
 - JCRequestErrorStatusUnsupportedURL: URL错误(400)
 - JCRequestErrorStatusRequestFail: 请求失败(404)
 - JCRequestErrorStatusServerError: 服务器出错(500)
 - JCRequestErrorStatusServerDataError: 后台返回的数据有误
 - JCRequestErrorStatusRequestTimedOut: 请求超时
 - JCRequestErrorStatusNotFoundServer: 未能找到服务器
 */
typedef NS_ENUM(NSUInteger, JCRequestErrorStatus) {
    JCRequestErrorStatusNotNetwork = 0,
    JCRequestErrorStatusMimeTypeError,
    JCRequestErrorStatusUnsupportedURL,
    JCRequestErrorStatusRequestFail,
    JCRequestErrorStatusServerError,
    JCRequestErrorStatusServerDataError,
    JCRequestErrorStatusRequestTimedOut,
    JCRequestErrorStatusNotFoundServer,
};

#pragma mark -

@interface JCRequestError : NSObject
@property (nonatomic, assign, readonly) JCRequestErrorStatus errorStatus;
@property (nonatomic, copy, readonly) NSString *errorDescription;
@property (nonatomic, strong, readonly) NSDictionary *userInfo;
+ (instancetype)requestError:(NSError *)error;
@end

#pragma mark -

typedef void(^progressBlock)(NSProgress *);
typedef void (^sessionManagerBlock)(AFHTTPSessionManager *);

@interface JCRequest : NSObject

#pragma mark - post request

+ (void)requestWithURL:(NSString *)url params:(id)params result:(void (^)())result;

+ (void)requestWithURL:(NSString *)url params:(id)params progress:(progressBlock)progress result:(void (^)())result;

+ (void)requestWithURL:(NSString *)url params:(id)params files:(NSArray <JCFileItem *> *)files result:(void (^)())result;

+ (void)requestWithURL:(NSString *)url params:(id)params files:(NSArray<JCFileItem *> *)files progress:(progressBlock)progress result:(void (^)())result;

#pragma mark - post request - sessionManager

+ (void)requestWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params result:(void (^)())result;

+ (void)requestWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params progress:(progressBlock)progress result:(void (^)())result;

+ (void)requestWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params files:(NSArray <JCFileItem *> *)files result:(void (^)())result;

#pragma mark - post base

+ (void)requestWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params files:(NSArray<JCFileItem *> *)files progress:(progressBlock)progress result:(void (^)())result;

#pragma mark - get request

+ (void)requestGETWithURL:(NSString *)url result:(void (^)())resul;

+ (void)requestGETWithURL:(NSString *)url params:(id)params result:(void (^)())resul;

+ (void)requestGETWithURL:(NSString *)url params:(id)params rogress:(progressBlock)progress result:(void (^)())resul;

#pragma mark - get request - sessionManager

+ (void)requestGETWithManager:(sessionManagerBlock)manager url:(NSString *)url result:(void (^)())result;

+ (void)requestGETWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params result:(void (^)())result;

#pragma mark - get base

+ (void)requestGETWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params progress:(progressBlock)progress result:(void (^)())result;

@end

#pragma mark -

typedef void (^successBlock)(id);
typedef void (^failureBlock)(JCRequestError *);

@interface JCRequest (JCAdd)

+ (void)requestWithURL:(NSString *)url params:(id)params success:(successBlock)success failure:(failureBlock)failure;

+ (void)requestWithURL:(NSString *)url params:(id)params files:(NSArray <JCFileItem *> *)files success:(successBlock)success failure:(failureBlock)failure;

@end
