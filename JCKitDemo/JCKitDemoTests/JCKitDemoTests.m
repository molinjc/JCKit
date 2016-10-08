//
//  JCKitDemoTests.m
//  JCKitDemoTests
//
//  Created by 林建川 on 16/9/30.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+JCJSON.h"
#import "JCPerson.h"
#import "NSString+JCString.h"


@interface JCKitDemoTests : XCTestCase

@property (nonatomic, strong) JCPerson *person;

@property (nonatomic, copy) NSString *text;

@end

@implementation JCKitDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // 初始化的代码，在测试方法调用之前调用
//    NSDictionary *dic = @{@"name":@"nnnn",
//                          @"sex":[NSNull null],
//                          @"age":@12,
//                          };
//    self.person = [JCPerson modelWithJSON:dic];
    
    self.person = [JCPerson new];
    self.person.sex = @"111";
    self.person.name = @"2222";
    self.person.age = 1222;
    
    self.text = @"123456789.78";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    // 释放测试用例的资源代码，这个方法会每个测试用例执行后调用
    self.person = nil;
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // 测试用例的例子，注意测试用例一定要test开头
}

- (void)testPreson {
    
    NSDictionary *dic = [self.person togetherIntoDictionary];
    NSString *ss = [NSString numberFormatter:NSNumberFormatterCurrencyAccountingStyle number:[NSNumber numberWithInteger:123456]];
    NSLog(@"?????:%@",ss);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle  = NSNumberFormatterSpellOutStyle;
    NSNumber *num = [formatter numberFromString:@"十二万三千四百五十六元"];
    NSLog(@"!!!!%@",num);

//    XCTAssertEqualObjects(dic, nil, @"😂😂不行！！");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    // 测试性能例子
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        // 需要测试性能的代码
    }];
}

@end
