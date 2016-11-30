//
//  NSArray+JCBlock.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSArray+JCBlock.h"
#import <objc/runtime.h>

#if __has_include("NSException+JCException.h")
#import "NSException+JCException.h"
#define kLogException NSLog(@"\n1️⃣%@\n2️⃣%@\n3️⃣%@",exception.name,exception.reason,exception.mainCallStackSymbolMessage);
#else
#define kLogException \
__block NSString *mainCallStackSymbolMsg = nil;\
NSString *callStackSymbolString = [NSThread callStackSymbols][2];\
NSString *regularExpStr = @"[-\\+]\\[.+\\]";\
NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];\
[regularExp enumerateMatchesInString:callStackSymbolString options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbolString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {\
    if (result) {\
        mainCallStackSymbolMsg = [callStackSymbolString substringWithRange:result.range];\
        *stop = YES;\
    }\
}];\
NSLog(@"\n1️⃣%@\n2️⃣%@\n3️⃣%@",exception.name,exception.reason,mainCallStackSymbolMsg); \

#endif

#define kAssertBlock(block) NSParameterAssert(block != nil)

@implementation NSArray (JCBlock)

+ (void)load {
    // 类方法的交换
    Method sysMethod = class_getClassMethod([self class], @selector(arrayWithObjects:count:));
    Method cusMethod = class_getClassMethod([self class], @selector(avoidCrashArrayWithObjects:count:));
    method_exchangeImplementations(sysMethod, cusMethod);
    
    // 对象方法的交换
    Class arrayIClass = NSClassFromString(@"__NSArrayI");
    Method sysIMethod = class_getInstanceMethod(arrayIClass, @selector(objectAtIndex:));
    Method cusIMethod = class_getInstanceMethod(arrayIClass, @selector(avoidCrashObjectAtIndex:));
    method_exchangeImplementations(sysIMethod, cusIMethod);
}

/**
 遍历每个元素
 */
- (void)each:(void (^)(id))block {
    kAssertBlock(block);
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

/**
 遍历每个元素，block有下标
 */
- (void)eachIndex:(void (^)(id, NSInteger))block {
    kAssertBlock(block);
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj, idx);
    }];
}

/**
 反序遍历每个元素
 */
- (void)reverseEach:(void (^)(id))block {
    kAssertBlock(block);
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

/**
 反序遍历每个元素，block有下标
 */
- (void)reverseEachIndex:(void (^)(id, NSInteger))block {
    kAssertBlock(block);
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj, idx);
    }];
}

/**
 选择YES时前几个的元素
 */
- (NSArray *)select:(BOOL (^)(id, NSInteger))block {
    kAssertBlock(block);
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return block(obj, idx);
    }]];
}

/**
 avoidCrashArrayWithObjects:count:的替换方法
 用@[]来创建新的数值，实际就是调用avoidCrashArrayWithObjects:count:
 该方法对@[]里有nil值进行剔除
 @param objects values
 @param cnt     count
 @return 新数值
 */
+ (instancetype)avoidCrashArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self avoidCrashArrayWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        kLogException
        //以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
        NSUInteger newObjsIndex = 0;
        id _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self avoidCrashArrayWithObjects:newObjects count:newObjsIndex];
    } @finally {
        return instance;
    }
}

/**
 objectAtIndex:的替换方法
 array[index]实际用的方法就是objectAtIndex:
 该方法对index的不合理进行错误打印
 @param index 下标
 @return 下标合理，返回对应值；不合理，返回nil，并打印
 */
- (id)avoidCrashObjectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self avoidCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        kLogException
    } @finally {
        return object;
    }
}

@end

@implementation NSMutableArray (JCBlock)

+ (void)load {
    Class arrayMClass = NSClassFromString(@"__NSArrayM");
    
    Method sysMethod_1 = class_getInstanceMethod(arrayMClass, @selector(setObject:atIndex:));
    Method cusMethod_1 = class_getInstanceMethod(arrayMClass, @selector(avoidCrashSetObject:atIndex:));
    Method sysMethod_2 = class_getInstanceMethod(arrayMClass, @selector(removeObjectAtIndex:));
    Method cusMethod_2 = class_getInstanceMethod(arrayMClass, @selector(avoidCrashRemoveObjectAtIndex:));
    Method sysMethod_3 = class_getInstanceMethod(arrayMClass, @selector(insertObject:atIndex:));
    Method cusMethod_3 = class_getInstanceMethod(arrayMClass, @selector(avoidCrashInsertObject:atIndex:));
    
    method_exchangeImplementations(sysMethod_1, cusMethod_1);
    method_exchangeImplementations(sysMethod_2, cusMethod_2);
    method_exchangeImplementations(sysMethod_3, cusMethod_3);
}

/**
 setObject:atIndex:的替换方法
 array[index] = value 实际用的方法就是setObject:atIndex:
 @param object 新的值
 @param idx    下标
 */
- (void)avoidCrashSetObject:(id)object atIndex:(NSUInteger)index {
    @try {
        [self avoidCrashSetObject:object atIndex:index];
    } @catch (NSException *exception) {
        kLogException
    } @finally {
        
    }
}

/**
 removeObjectAtIndex:的替换方法
 @param index 要删除的下标
 */
- (void)avoidCrashRemoveObjectAtIndex:(NSUInteger)index {
    @try {
        [self avoidCrashRemoveObjectAtIndex:index];
    } @catch (NSException *exception) {
        kLogException
    } @finally {
        
    }
}

/**
 insertObject:atIndex:的替换方法
 @param anObject 要插入的值
 @param index    要插入的位置
 */
- (void)avoidCrashInsertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self avoidCrashInsertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        kLogException
    } @finally {
        
    }
}

@end
