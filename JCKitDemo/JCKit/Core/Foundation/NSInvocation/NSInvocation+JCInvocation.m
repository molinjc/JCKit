//
//  NSInvocation+JCInvocation.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/12/23.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSInvocation+JCInvocation.h"
#import <objc/runtime.h>

struct Block_literal_1 {
    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor_1 {
        unsigned long int reserved;     // NULL
        unsigned long int size;         // sizeof(struct Block_literal_1)
        // optional helper functions
        // void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
        // void (*dispose_helper)(void *src);             // IFF (1<<25)
        // required ABI.2010.3.16
        // const char *signature;                         // IFF (1<<30)
        void* rest[1];
    } *descriptor;
    // imported variables
};

enum {
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_HAS_STRET =         (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE =     (1 << 30),
};

static const char *__BlockSignature__(id blockObj) {
    struct Block_literal_1 *block = (__bridge void *)blockObj;
    struct Block_descriptor_1 *descriptor = block->descriptor;
    assert(block->flags & BLOCK_HAS_SIGNATURE);
    int offset = 0;
    if(block->flags & BLOCK_HAS_COPY_DISPOSE)
        offset += 2;
    return (char*)(descriptor->rest[offset]);
}

@implementation NSInvocation (JCInvocation)

+ (void)load {
    Method sysMethod = class_getClassMethod([self class], @selector(invocationWithMethodSignature:));
    Method cusMethod = class_getClassMethod([self class], @selector(avoidCrashInvocationWithMethodSignature:));
    method_exchangeImplementations(sysMethod, cusMethod);
}

/**
 会先检查sig是否空的初始化方法，为空会抛出异常
 */
+ (instancetype)avoidCrashInvocationWithMethodSignature:(NSMethodSignature *)sig {
    NSInvocation *invocation;
    @try {
        invocation = [NSInvocation avoidCrashInvocationWithMethodSignature:sig];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return invocation;
}

+ (instancetype)invocationWithBlock:(id)block {
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:__BlockSignature__(block)]];
    invocation.target = block;
    return invocation;
}

+ (instancetype)invocationWithBlockAndArguments:(id)block, ... {
    NSInvocation* invocation = [NSInvocation invocationWithBlock:block];
    NSUInteger argsCount = invocation.methodSignature.numberOfArguments - 1;
    va_list args;
    va_start(args, block);
    JCSetInvocationArguments(invocation, argsCount, 1, args);
    return invocation;
}

- (void)arguments:(id)argumentLocation, ... {
    NSUInteger argsCount = self.methodSignature.numberOfArguments - 2;
    va_list args;
    va_start(args, argumentLocation);
    [self setArgument:&argumentLocation atIndex:2];
    JCSetInvocationArguments(self, argsCount,2, args);
}


#define ARG_SET(type, index) do { type val = 0; val = va_arg(args,type); [invocation setArgument:&val atIndex:index + i];} while (0)

static inline void JCSetInvocationArguments(NSInvocation* invocation, NSUInteger argsCount , NSInteger index, va_list args) {
    
    for(NSUInteger i = index - 1; i < argsCount ; ++i) {
        NSLog(@"%zd",i);
        const char* argType = [invocation.methodSignature getArgumentTypeAtIndex:i + index];
        
        if (argType[0] == _C_CONST) {
            argType++;
        }
        
        if (argType[0] == '@') {
            ARG_SET(id, index);
        }else if (strcmp(argType, @encode(Class)) == 0 ) {
            ARG_SET(Class, index);
        }else if (strcmp(argType, @encode(IMP)) == 0 ) {
            ARG_SET(IMP, index);
        }else if (strcmp(argType, @encode(SEL)) == 0) {         //SEL
            ARG_SET(SEL, index);
        }else if (strcmp(argType, @encode(double)) == 0){       //
            ARG_SET(double, index);
        }else if (strcmp(argType, @encode(float)) == 0){
            float val = 0;
            val = (float)va_arg(args,double);
            [invocation setArgument:&val atIndex:index + i];
        }else if (argType[0] == '^'){                           //pointer ( andconst pointer)
            ARG_SET(void *, index);
        }else if (strcmp(argType, @encode(char *)) == 0) {      //char* (and const char*)
            ARG_SET(char *, index);
        }else if (strcmp(argType, @encode(unsigned long)) == 0) {
            ARG_SET(unsigned long, index);
        }else if (strcmp(argType, @encode(unsigned long long)) == 0) {
            ARG_SET(unsigned long long, index);
        }else if (strcmp(argType, @encode(long)) == 0) {
            ARG_SET(long, index);
        }else if (strcmp(argType, @encode(long long)) == 0) {
            ARG_SET(long long, index);
        }else if (strcmp(argType, @encode(int)) == 0) {
            ARG_SET(int, index);
        }else if (strcmp(argType, @encode(unsigned int)) == 0) {
            ARG_SET(unsigned int, index);
        }else if (strcmp(argType, @encode(BOOL)) == 0 || strcmp(argType, @encode(bool)) == 0
                  || strcmp(argType, @encode(char)) == 0 || strcmp(argType, @encode(unsigned char)) == 0
                  || strcmp(argType, @encode(short)) == 0 || strcmp(argType, @encode(unsigned short)) == 0) {
            ARG_SET(int, index);
        }else{                  //struct union and array
            assert(false && "struct union array unsupported!");
        }
    }
    va_end(args);
}

@end
