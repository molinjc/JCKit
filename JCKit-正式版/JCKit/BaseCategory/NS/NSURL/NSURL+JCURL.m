//
//  NSURL+JCURL.m
//
//  Created by molin.JC on 2016/12/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSURL+JCURL.h"

@implementation NSURL (JCURL)

/** 获取链接中的参数 */
- (NSDictionary *)parameters {
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionary];
    NSArray * queryComponents = [self.query componentsSeparatedByString:@"&"];
    for (NSString * queryComponent in queryComponents) {
        NSString * key = [queryComponent componentsSeparatedByString:@"="].firstObject;
        NSString * value = [queryComponent substringFromIndex:(key.length + 1)];
        [parametersDictionary setObject:value forKey:key];
    }
    return parametersDictionary;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (instancetype)URLEncodeWithString:(NSString *)string {
    CFTypeRef X = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *url = (NSString *)CFBridgingRelease(X);
    return [NSURL URLWithString:url];
}

- (NSString *)MIMEType {
    NSURLRequest *request = [NSURLRequest requestWithURL:self];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}
#pragma clang diagnostic pop
@end
