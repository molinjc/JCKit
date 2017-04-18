//
//  NSDictionary+JCBlock.m
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSDictionary+JCBlock.h"
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
NSLog(@"\n1️⃣%@\n2️⃣%@\n3️⃣%@",exception.name,exception.reason,mainCallStackSymbolMsg);\

#endif

#define kAssertBlock(block) NSParameterAssert(block != nil)

@implementation NSDictionary (JCBlock)

+ (void)load {
    Method sysMethod = class_getClassMethod([self class], @selector(dictionaryWithObjects:forKeys:count:));
    Method cusMethod = class_getClassMethod([self class], @selector(avoidCrashDictionaryWithObjects:forKeys:count:));
    method_exchangeImplementations(sysMethod, cusMethod);
}

/**
 遍历每个元素
 */
- (void)each:(void (^)(id, id))block {
    kAssertBlock(block);
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key, obj);
    }];
}

/**
 反序遍历每个元素
 */
- (void)reverseEach:(void (^)(id, id))block {
    kAssertBlock(block);
    [self enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key, obj);
    }];
}

/**
 选择条件满足前的元素
 */
- (NSDictionary *)select:(BOOL (^)(id, id))block {
    kAssertBlock(block);
    NSArray *keys = [[self keysOfEntriesPassingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        return block(key, obj);
    }] allObjects];
    NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

/**
 dictionaryWithObjects:forKeys:count:的替换方法
 @{}创建的字典实际调用的就是这个dictionaryWithObjects:forKeys:count:方法
 @param objects value
 @param keys    key
 @param cnt     count
 @return Dictionary
 */
+ (instancetype)avoidCrashDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self avoidCrashDictionaryWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        kLogException
        //处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self avoidCrashDictionaryWithObjects:newObjects forKeys:newkeys count:index];
    } @finally {
        return instance;
    }
}

//#pragma mark - getObject
//
#define kNSDictionarySimplifyJudgeCode(v) \
id value = [self objectForKey:key];\
if (!value || value == [NSNull null]) { \
return v; \
}

- (NSInteger)integerForKey:(id)key {
    NSNumber *number = [self numberForKey:key];
    if (!number) {
        return 0;
    }
    return [number integerValue];
}

- (int)intForKey:(id)key {
    NSNumber *number = [self numberForKey:key];
    if (!number) {
        return 0;
    }
    return [number intValue];
}

- (float)floatForKey:(id)key {
    NSNumber *number = [self numberForKey:key];
    if (!number) {
        return NO;
    }
    return [number boolValue];
}

- (double)doubleForKey:(id)key {
    NSNumber *number = [self numberForKey:key];
    if (!number) {
        return 0;
    }
    return [number doubleValue];
}

- (BOOL)boolForKey:(id)key {
    NSNumber *number = [self numberForKey:key];
    if (!number) {
        return 0;
    }
    return [number floatValue];
}

- (char)charForKey:(id)key {
    NSNumber *number = [self numberForKey:key];
    if (!number) {
        return 0;
    }
    return [number charValue];
}

- (CGFloat)CGFloatForKey:(id)key {
    CGFloat f = [self[key] doubleValue];
    return f;
}

- (CGSize)CGSizeForKey:(id)key {
    CGSize size = CGSizeFromString(self[key]);
    return size;
}

- (CGPoint)CGPointForKey:(id)key {
    CGPoint point = CGPointFromString(self[key]);
    return point;
}

- (CGRect)CGRectForKey:(id)key {
    CGRect rect = CGRectFromString(self[key]);
    return rect;
}

- (NSString *)stringForKey:(id)key {
    kNSDictionarySimplifyJudgeCode(nil)
    
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value stringValue];
    }
    return nil;
}

- (NSNumber *)numberForKey:(id)key {
    kNSDictionarySimplifyJudgeCode(nil)
    
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterNoStyle];
        return [f numberFromString:(NSString*)value];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    return nil;
}

- (NSArray *)arrayForKey:(id)key {
    kNSDictionarySimplifyJudgeCode(nil)
    
    if ([value isKindOfClass:[NSArray class]]) {
        return (NSArray *)value;
    }
    
    if ([value isKindOfClass:[NSMutableArray class]]) {
        return (NSMutableArray *)value;
    }
    return nil;
}

- (NSMutableArray *)mutableArrayForKey:(id)key {
    kNSDictionarySimplifyJudgeCode(nil)
    
    if ([value isKindOfClass:[NSArray class]]) {
        return (NSMutableArray *)value;
    }
    
    if ([value isKindOfClass:[NSMutableArray class]]) {
        return (NSMutableArray *)value;
    }
    return nil;
}

- (NSDictionary *)dictionaryForKey:(id)key {
    kNSDictionarySimplifyJudgeCode(nil)
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)value;
    }
    
    if ([value isKindOfClass:[NSMutableArray class]]) {
        return value;
    }
    return nil;
}

- (NSMutableDictionary *)mutableDictionaryForKey:(id)key {
    kNSDictionarySimplifyJudgeCode(nil)
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        return (NSMutableDictionary *)value;
    }
    
    if ([value isKindOfClass:[NSMutableArray class]]) {
        return value;
    }
    return nil;
}

/**
 两个字典合并
 */
- (NSDictionary *)merging:(NSDictionary *)dic {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![dic objectForKey:key]) {
            [result setObject:obj forKey:key];
        }
    }];
    return result;
}

@end

@implementation NSMutableDictionary (JCBlock)

+ (void)load {
    Class dictionaryMClass = NSClassFromString(@"__NSDictionaryM");
    Method sysMethod_1 = class_getInstanceMethod(dictionaryMClass, @selector(setObject:forKey:));
    Method cusMethod_1 = class_getInstanceMethod(dictionaryMClass, @selector(avoidCrashSetObject:forKey:));
    Method sysMethod_2 = class_getInstanceMethod(dictionaryMClass, @selector(removeObjectForKey:));
    Method cusMethod_2 = class_getInstanceMethod(dictionaryMClass, @selector(avoidCrashRemoveObjectForKey:));
    method_exchangeImplementations(sysMethod_1, cusMethod_1);
    method_exchangeImplementations(sysMethod_2, cusMethod_2);
}

/**
 setObject:forKey:的替换方法
 dic[key] = value 实际调用的是setObject:forKey:
 @param anObject value
 @param aKey     key
 */
- (void)avoidCrashSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self avoidCrashSetObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        kLogException
    } @finally {
        
    }
}

/**
 removeObjectForKey:的替换方法
 */
- (void)avoidCrashRemoveObjectForKey:(id)aKey {
    @try {
        [self avoidCrashRemoveObjectForKey:aKey];
    } @catch (NSException *exception) {
        kLogException
    } @finally {
        
    }
}

@end
