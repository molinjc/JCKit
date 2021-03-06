//
//  JCKitMacro.h
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#ifndef JCKitMacro_h
#define JCKitMacro_h

#import <sys/time.h>

#if DEBUG

/** 打印, 本质是NSLog() */
#define JCLog(string,...) NSLog(@"\n🛠 行号:%d\n🛠 类与方法:%s\n🛠 内容:%@ %@",__LINE__,__func__,[NSString stringWithFormat:(string), ##__VA_ARGS__],@"\n\n")
#define JCPLog(string, ...) printf(@"\n🛠 行号:%d\n🛠 类与方法:%s\n🛠 内容:%@ %@",__LINE__,__func__,[[NSString stringWithFormat:(string), ##__VA_ARGS__] UTF8String],@"\n\n")

#define JCLog_cmd JCLog(@"%@",NSStringFromSelector(_cmd))

/**
 断言,断言为真，则表明程序运行正常，而断言为假，则意味着它已经在代码中发现了意料之外的错误
 @param condition 判定的条件
 */
#define JCAssert(condition) NSAssert((condition), @"\n🛠 行号:%d\n🛠 类与方法:%s\n😱😱不满足条件:%@☝️☝️ %@",__LINE__,__func__, @#condition,@"\n\n")

#else
#define JCLog(string,...)
#define JCAssert(condition)
#endif

/**
 弱引用、强引用，成对用于block
 @autoreleasepool {} 加在前面，其实啥事都没干，只为了可以加@，用来显眼
 @param obj  要引用的对象
 */
#define weakify(obj) autoreleasepool {} __weak typeof(obj) weak##obj = obj;
#define strongify(obj) autoreleasepool {} __strong typeof(weak##obj) strong##obj = weak##obj;


/**
 简化CGRect创建
 Usages:
 CGRect rect = FRAME_XYWH(someView.frame);
 FRAME_XYWH(10, 10, 100, 100);
 FRAME_XYWH(CGPointMake(10, 10), 100, 100);
 FRAME_XYWH(CGPointMake(10, 10), CGSizeMake(100, 100));
 */
#define JCFRAME_XYWH(...) (CGRect){__VA_ARGS__}

#define JCSIZE_WH(...) (CGSize){__VA_ARGS__}

#define JCPOINT_XY(...) (CGPoint){__VA_ARGS__}

/** 简化stringWithFormat: */
#define JCString(...) [NSString stringWithFormat:__VA_ARGS__]

#define JCLocalizedString(key) [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]

/** 单例声明 */
#define JCSingleton_interface +(instancetype)sharedInstance;   // .h的，声明单例方法
/** 单例实现 */
#define JCSingleton_implementation                     \
static id _instance;                                   \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t once;                       \
dispatch_once(&once, ^{                            \
_instance = [super allocWithZone:zone];        \
});                                                \
return _instance;                                  \
}                                                      \
+ (instancetype)sharedInstance {                       \
static dispatch_once_t once;                       \
dispatch_once(&once, ^{                            \
_instance = [[self alloc] init];               \
});                                                \
return _instance;                                  \
}                                                      \
- (id)copyWithZone:(NSZone *)zone {                    \
return _instance;                                  \
}

/**
 *  三目运算符
 *  @param condition  条件
 *  @param valueTrue  真的值
 *  @param valueFalse 假的值
 *  @return 所要的值
 */
#define JCTernary(condition, valueTrue, valueFalse) condition ? valueTrue : valueFalse


/**
 动态给一个类的属性添加setter/getter
 @param setter      setter方法名
 @param getter      getter方法名
 @param association 持有类型：ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @param type        返回类名
 
 @Example:
     @interface NSObject (add)
     @property (nonatomic, strong) UIColor *color;
     @end
     #import <objc/runtime.h>
     @implementation NSObject (add)
     JCSynthDynamicProperty(setColor, color, RETAIN, UIColor *)
     @end
 */
#ifndef JCSynthDynamicProperty
#define JCSynthDynamicProperty(setter, getter, association, type) \
- (void)setter : (type)object { \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## association); \
} \
- (type)getter { \
    return objc_getAssociatedObject(self, @selector(setter:)); \
}
#endif

#ifdef JCSynthDynamicProperty

/**
 JCSynthDynamicPropertyStrong 动态给一个类的强引用属性添加setter/getter
 JCSynthDynamicPropertyCopy 动态给一个类的copy属性添加setter/getter
 @param type   不用再'*'号
 JCSynthDynamicPropertyAssign 动态给一个类的assign属性添加setter/getter
 
 @Example:
     @interface NSObject (add)
     @property (nonatomic, strong) UIColor *color;
     @property (nonatomic, copy) NSString *string;
     @property (nonatomic, assign) NSInteger age;
     @end
     #import <objc/runtime.h>
     @implementation NSObject (add)
     JCSynthDynamicPropertyStrong(setColor, color, UIColor)
     JCSynthDynamicPropertyCopy(setString, string, NSString)
     JCSynthDynamicPropertyAssign(setAge, age, NSInteger)
 @end
 */
#define JCSynthDynamicPropertyStrong(setter, getter, type) JCSynthDynamicProperty(setter, getter, RETAIN_NONATOMIC, type *)

#define JCSynthDynamicPropertyCopy(setter, getter, type) JCSynthDynamicProperty(setter, getter, COPY_NONATOMIC, type *)

#define JCSynthDynamicPropertyAssign(setter, getter, type) JCSynthDynamicProperty(setter, getter, ASSIGN, type)

#endif

/**
 获取变量的名字
 @param variable 变量
 @return 变量名（字符串）
 */
#define JCGetVariableName(variable) [NSString stringWithFormat:@"%@",@"" # variable]

/**
 计算参数的个数
 @Example:
     int count = JCParamsCount(1, 2, 3, 4, 5);
     count => 5
 @end
 */
#define JCParamsCount(...) _paramsCount_at(__VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
#define _paramsCount_at(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) _paramsCount_head(__VA_ARGS__)
#define _paramsCount_head(FIRST, ...) FIRST

/** 获取编译的时间 */
static inline NSDate *JCCompileTime() {
    NSString *timeStr = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}

/**
 运行时间差
 @param block 所要得知时间差的代码
 @param complete 时间差(double)
     Usage:
         YYBenchmark(^{
             // code
         }, ^(double ms) {
             NSLog("time cost: %.2f ms",ms);
         });
 */
static inline void JCBenchmark(void (^block)(void), void (^complete)(double ms)) {
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

/**
 上取整
 ceil()：取不小于给定实数的最小整数
 */
static inline CGRect CGRectCeli(CGRect rect) {
    return CGRectMake(ceil(rect.origin.x), ceil(rect.origin.y), ceil(rect.size.width), ceil(rect.size.height));
}

static inline CGSize CGSizeCeli(CGSize size) {
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

static inline CGPoint CGPointCeli(CGPoint origin) {
    return CGPointMake(ceil(origin.x), ceil(origin.y));
}

/**
 下取整
 floor(): 取不大于给定实数的最大整数
 */
static inline CGRect CGRectFloor(CGRect rect) {
    return CGRectMake(floor(rect.origin.x), floor(rect.origin.y), floor(rect.size.width), floor(rect.size.height));
}

static inline CGSize CGSizeFloor(CGSize size) {
    return CGSizeMake(floor(size.width), floor(size.height));
}

static inline CGPoint CGPointFloor(CGPoint origin) {
    return CGPointMake(floor(origin.x), floor(origin.y));
}

/** 将origin和size合成CGRect */
static inline CGRect CGRectSynth(CGPoint origin, CGSize size) {
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

/** 获取rect里的中心 */
static inline CGPoint CGRectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/** 获取size里最大的那个数 */
static inline CGFloat CGSizeMax(CGSize size) {
    return MAX(size.width, size.height);
}

/** 获取size里最小的那个数 */
static inline CGFloat CGSizeMin(CGSize size) {
    return MIN(size.width, size.height);
}

/** 点转换成像素 */
static inline CGFloat CGFloatToPixel(CGFloat value) {
    return value * [UIScreen mainScreen].scale;
}

/** 像素转换成点 */
static inline CGFloat CGFloatFromPixel(CGFloat value) {
    return value / [UIScreen mainScreen].scale;
}

/** 由角度转换弧度 */
static inline CGFloat JCDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/** 由弧度转换角度 */
static inline CGFloat JCRadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

/**
 给定一个数据，转换成NSValue/NSNumber
 @param value 数据类型
 @return NSValue/NSNumber
 */
#define JCBoxValue(value) _JCBoxValue(@encode(__typeof__((value))), (value))
static inline id _JCBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    }
    return obj;
}

#endif /* JCKitMacro_h */
