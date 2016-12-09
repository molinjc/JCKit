//
//  NSURL+JCURL.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (JCURL)
/**
 获取链接中的参数
 */
- (NSDictionary *)parameters;

@end
