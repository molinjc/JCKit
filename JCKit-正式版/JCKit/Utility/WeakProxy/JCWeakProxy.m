//
//  JCWeakProxy.m
//
//  Created by 林建川 on 16/10/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCWeakProxy.h"

@implementation JCWeakProxy

- (instancetype)initWithStream:(id)stream {
    _stream = stream;
    return self;
}

+ (instancetype)proxyWithStream:(id)stream {
    return [[JCWeakProxy alloc] initWithStream:stream];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_stream respondsToSelector:aSelector];
}

@end
