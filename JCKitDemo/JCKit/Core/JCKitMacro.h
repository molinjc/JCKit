//
//  JCKitMacro.h
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#ifndef JCKitMacro_h
#define JCKitMacro_h

/**
 *  打印
 *  本质是NSLog()
 */
#define JCLog(string,...) NSLog(@"🛠 行号:%d,🛠 类与方法:%s,🛠内容:%@ \n",__LINE__,__func__,[NSString stringWithFormat:(string), ##__VA_ARGS__]);

/**
 *  弱引用、强引用，成对用于block
 *  @autoreleasepool {} 加在前面，其实啥事都没干，只为了可以加@，用来显眼
 *  @param obj 要引用的对象
     Example:
             @weakify(self)
             [self doSomething^{
                 @strongify(self)
             }];
 */
#define weakify(obj) autoreleasepool {} __weak typeof(obj) weak##obj = obj;
#define strongify(obj) autoreleasepool {} __strong typeof(obj) obj = weak##obj;

/**
 *  断言
 *  断言为真，则表明程序运行正常，而断言为假，则意味着它已经在代码中发现了意料之外的错误
 *  @param condition 判定的条件
 */
#define JCAssert(condition) NSAssert((condition), @"🛠 行号:%d,🛠 类与方法:%s,😱😱不满足条件:%@☝️☝️ ",__LINE__,__func__, @#condition)

/**
 获取编译的时间
 @return NSDate
 */
static inline NSDate * JCCompileTime() {
    NSString *timeString = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeString];
}

#import <sys/time.h>

/**
 测试一段代码的运行时间
 @param ^block 要测试的代码
 @param ^complete 该段代码的运行时间
     Example:
         JCBenchmark(^{
             // code
         }, ^(double ms) {
             NSLog("time cost: %.2f ms",ms);
         });
 */
static inline void JCBenchmark(void (^block)(void), void (^complete)(double ms)) {
    struct timeval t0,t1;
    gettimeofday(&t0, NULL);
    if (block) {
        block();
    }
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    if (complete) {
        complete(ms);
    }
}

#endif /* JCKitMacro_h */
