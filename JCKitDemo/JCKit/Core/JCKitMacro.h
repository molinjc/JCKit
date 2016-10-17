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
 */
#define weakify(obj) autoreleasepool {} __weak typeof(obj) weak##obj = obj;
#define strongify(obj) autoreleasepool {} __strong typeof(weak##obj) obj = weak##obj;

/**
 *  断言
 *  断言为真，则表明程序运行正常，而断言为假，则意味着它已经在代码中发现了意料之外的错误
 *  @param condition 判定的条件
 */
#define JCAssert(condition) NSAssert((condition), @"🛠 行号:%d,🛠 类与方法:%s,😱😱不满足条件:%@☝️☝️ ",__LINE__,__func__, @#condition)

/**
 *  三目运算符
 *  @param condition  条件
 *  @param valueTrue  真的值
 *  @param valueFalse 假的值
 *  @return 所要的值
 */
#define JCTernary(condition, valueTrue, valueFalse) condition ? valueTrue : valueFalse

#endif /* JCKitMacro_h */
