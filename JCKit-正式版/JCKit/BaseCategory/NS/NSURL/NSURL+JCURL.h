//
//  NSURL+JCURL.h
//
//  Created by molin.JC on 2016/12/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (JCURL)

@property (nonatomic, readonly) NSString * MIMEType;

/** 获取链接中的参数 */
- (NSDictionary *)parameters;

/** 对链接里的中文进行编码 */
+ (instancetype)URLEncodeWithString:(NSString *)string;

@end
