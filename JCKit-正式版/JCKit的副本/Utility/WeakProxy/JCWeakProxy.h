//
//  JCWeakProxy.h
//
//  Created by 林建川 on 16/10/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id stream;

- (instancetype)initWithStream:(id)stream;

+ (instancetype)proxyWithStream:(id)stream;

@end
