//
//  JCSystemManager.m
//  XHVersionExample
//
//  Created by molin.JC on 2016/11/24.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import "JCSystemManager.h"
#import <AVFoundation/AVFoundation.h>

typedef void (^RequestSucess) (NSDictionary * responseDict);
typedef void (^RequestFailure) (NSError *error);

@implementation JCSystemManager

/**
 检查版本
 @param block 回调值BOOL， NO:无新版本；YES:有新版本
 */
+ (void)inspectVersion:(void (^)(BOOL))block {
    if (!block) return;

    [JCSystemManager appInfoRequestSuccess:^(NSDictionary *responseDict) {
        NSInteger resultCount = [responseDict[@"resultCount"] integerValue];
        
        if (resultCount == 1) {
            NSArray *resultArray = responseDict[@"results"];
            NSDictionary *result = resultArray.firstObject;
            JCAppInfo *appInfo = [[JCAppInfo alloc] initWithResult:result];
        
            if ([JCSystemManager compareWithExternalVersion:appInfo.version]) {
                block(YES);
            }else {
                block(NO);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 APP的版本与外部传进来的版本比较
 @param version 外部传进来的版本
 @return NO：APP的版本最大，也就是最新的版本  ; YES：外部版本比较大，有新版本
 */
+ (BOOL)compareWithExternalVersion:(NSString *)version {
    if ([[JCSystemManager appVersionString] compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

/**
 APP的版本
 @return 字符串
 */
+ (NSString *)appVersionString {
    NSString * version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    return version;
}

/**
 请求APP的信息
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)appInfoRequestSuccess:(RequestSucess)success failure:(RequestFailure)failure{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = infoDict[@"CFBundleIdentifier"];
    
    NSURL *URL = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@",bundleId]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(!error) {
                    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    if(success) success(responseDict);
                } else {
                    
                    if(failure) failure(error);
                }
            });
        }];
        [dataTask resume];
    });
}

@end


@implementation JCSystemManager (JCAuthority)

- (BOOL)audioSession {
    AVAudioSession *audioSession = [[AVAudioSession alloc] init];
    switch ([audioSession recordPermission]) {
        case AVAudioSessionRecordPermissionUndetermined:
            
            break;
        case AVAudioSessionRecordPermissionDenied:
            break;
        case AVAudioSessionRecordPermissionGranted:
            break;
        default:
            break;
    }
    
    return NO;
}

@end

@implementation JCAppInfo

- (instancetype)initWithResult:(NSDictionary *)result {
    
    self = [super init];
    if (self) {
        
        self.version = result[@"version"];
        self.releaseNotes = result[@"releaseNotes"];
        self.currentVersionReleaseDate = result[@"currentVersionReleaseDate"];
        self.trackId = result[@"trackId"];
        self.bundleId = result[@"bundleId"];
        self.trackViewUrl = result[@"trackViewUrl"];
        self.appDescription = result[@"appDescription"];
        self.sellerName = result[@"sellerName"];
        self.fileSizeBytes = result[@"fileSizeBytes"];
        self.screenshotUrls = result[@"screenshotUrls"];
    }
    return self;
}
@end
