//
//  JCRequest.m
//
//  Created by molin.JC on 2017/4/10.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCRequest.h"
#if __has_include("JCReachability.h")
#import "JCReachability.h"
#endif

@implementation JCFileItem
@end

@implementation JCRequestError

- (instancetype)init {
    if (self = [super init]) {
        _errorStatus = JCRequestErrorStatusNotNetwork;
        _errorDescription = @"没有网络";
    }
    return self;
}

+ (instancetype)requestError:(NSError *)error {
    JCRequestError *requestError = [[JCRequestError alloc] init];
    [requestError error:error];
    return requestError;
}

- (void)error:(NSError *)error {
    _userInfo = error.userInfo;
    switch (error.code) {
        case -1001:{
            _errorStatus = JCRequestErrorStatusServerDataError;
            _errorDescription = _userInfo[@"NSLocalizedDescription"];
        }
            break;
        case -1002: {
            _errorStatus = JCRequestErrorStatusUnsupportedURL;
            _errorDescription = _userInfo[@"NSLocalizedDescription"];
        }
            break;
        case 3840:{
            _errorStatus = JCRequestErrorStatusServerDataError;
            _errorDescription = _userInfo[@"NSDebugDescription"];
        }
            break;
        default:
            break;
    }
}

@end


/** 检查网络 */
#if __has_include("JCReachability.h")
#define InspectNetwork                                                                     \
JCReachability *reachability = [JCReachability reachability];                              \
if (!reachability.reachable) {                                                             \
    if (result) {                                                                          \
        result(JCRequestError.new);                                                        \
    }                                                                                      \
    return;                                                                                \
}
#else
#define InspectNetwork                                                                     \
AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager]; \
[reachability startMonitoring];                                                            \
if (!reachability.reachable) {                                                             \
    if (result) {                                                                          \
        result(JCRequestError.new);                                                        \
    }                                                                                      \
    return;                                                                                \
}
#endif

@implementation JCRequest

#pragma mark - post request

+ (void)requestWithURL:(NSString *)url params:(id)params result:(void (^)())result {
    [self requestWithURL:url params:params files:nil result:result];
}

+ (void)requestWithURL:(NSString *)url params:(id)params progress:(progressBlock)progress result:(void (^)())result {
    [self requestWithURL:url params:params files:nil progress:progress result:result];
}

+ (void)requestWithURL:(NSString *)url params:(id)params files:(NSArray <JCFileItem *> *)files result:(void (^)())result {
    [self requestWithURL:url params:params files:files progress:nil result:result];
}

+ (void)requestWithURL:(NSString *)url params:(id)params files:(NSArray<JCFileItem *> *)files progress:(progressBlock)progress result:(void (^)())result  {
    [self requestWithManager:nil url:url params:params files:files progress:progress result:result];
}

#pragma mark - post request - sessionManager

+ (void)requestWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params result:(void (^)())result {
    [self requestWithManager:manager url:url params:params files:nil progress:nil result:result];
}

+ (void)requestWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params progress:(progressBlock)progress result:(void (^)())result {
    [self requestWithManager:manager url:url params:params files:nil progress:progress result:result];
}

+ (void)requestWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params files:(NSArray <JCFileItem *> *)files result:(void (^)())result {
    [self requestWithManager:manager url:url params:params files:files progress:nil result:result];
}

#pragma mark - post base

+ (void)requestWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params files:(NSArray<JCFileItem *> *)files progress:(progressBlock)progress result:(void (^)())result {
    
    InspectNetwork;
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    if (manager) {
        manager(sessionManager);
    }
    
    if (!files) {
        [sessionManager POST:url parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (result) {
                result(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (result) {
                result([JCRequestError requestError:error]);
            }
        }];
    }else {
        [sessionManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (JCFileItem *item in files) {
                [formData appendPartWithFileData:item.data name:item.key fileName:item.name mimeType:item.type];
            }
        } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"responseObject: %@", dic);
            if (result) {
                result(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (result) {
                result([JCRequestError requestError:error]);
            }
        }];
    }
}

#pragma mark - get request

+ (void)requestGETWithURL:(NSString *)url result:(void (^)())resul {
    [self requestGETWithURL:url params:nil result:resul];
}

+ (void)requestGETWithURL:(NSString *)url params:(id)params result:(void (^)())resul {
    [self requestGETWithURL:url params:params rogress:nil result:resul];
}

+ (void)requestGETWithURL:(NSString *)url params:(id)params rogress:(progressBlock)progress result:(void (^)())resul {
    [self requestGETWithManager:nil url:url params:params progress:progress result:resul];
}

#pragma mark - get request - sessionManager

+ (void)requestGETWithManager:(sessionManagerBlock)manager url:(NSString *)url result:(void (^)())result {
    [self requestGETWithManager:manager url:url params:nil result:result];
}

+ (void)requestGETWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params result:(void (^)())result {
    [self requestGETWithManager:manager url:url params:params progress:nil result:result];
}

#pragma mark - get base

+ (void)requestGETWithManager:(sessionManagerBlock)manager url:(NSString *)url params:(id)params progress:(progressBlock)progress result:(void (^)())result {
    
    InspectNetwork;
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET:url parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (result) {
            result(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (result) {
            result([JCRequestError requestError:error]);
        }
    }];
}

@end


@implementation JCRequest (JCAdd)

+ (void)requestWithURL:(NSString *)url params:(id)params success:(successBlock)success failure:(failureBlock)failure {
    [self requestWithURL:url params:params result:^(id obj) {
        if ([obj isKindOfClass:[JCRequestError class]] && failure) {
            failure(obj);
        }else if (success) {
            success(obj);
        }
    }];
}

+ (void)requestWithURL:(NSString *)url params:(id)params files:(NSArray <JCFileItem *> *)files success:(successBlock)success failure:(failureBlock)failure {
    [self requestWithURL:url params:params files:files result:^(id obj) {
        if ([obj isKindOfClass:[JCRequestError class]] && failure) {
            failure(obj);
        }else if (success) {
            success(obj);
        }
    }];
}

@end
