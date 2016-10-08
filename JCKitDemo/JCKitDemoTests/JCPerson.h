//
//  JCPerson.h
//  JCRunTimeTest
//
//  Created by molin on 16/4/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JCPersonDelegate <NSObject>

- (void)logPerson;

@end

@interface JCPerson : NSObject

@property (nonatomic, assign) int a;

@property (nonatomic, assign) BOOL f;

@property (nonatomic, assign) float b;

@property (nonatomic, assign) double c;

@property (nonatomic, assign) NSInteger d;

@property (nonatomic, assign) CGFloat flo;

@property (nonatomic, assign) char ch;

@property (nonatomic, copy) void (^bl)();

@property (nonatomic, assign) CGSize size;

@property (nonatomic, weak) id<JCPersonDelegate> delegate;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *sex;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) JCPerson *ppp;

@property (nonatomic, assign) float height;

@property (nonatomic, strong) NSString *job;

@property (nonatomic, strong) NSString *native;

@property (nonatomic, strong) NSString *education;

- (void)eat;

- (void)sleep;

- (void)work;

@end
