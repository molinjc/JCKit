//
//  NSObject+JCObject.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,JCAttributeType) {
    JCAttributeTypeUnknown     = 0,    // unknown
    JCAttributeTypeVoid        = 1,    // void
    JCAttributeTypeBOOL        = 2,    // BOOL
    JCAttributeTypeInt         = 3,    // int
    JCAttributeTypeInteger     = 4,    // NSInteger
    JCAttributeTypeFloat       = 5,    // float
    JCAttributeTypeDouble      = 6,    // double
    JCAttributeTypeChat        = 7,    // chat
    JCAttributeTypeObject      = 8,    // 对象
};

JCAttributeType JCGetObjectAttributeType(const char *attribute);

@interface NSObject (JCObject)

- (id)jc_performSelector:(SEL)sel;

- (NSArray *)allPropertys;

/**
 获取该类下的所有子类
 */
- (NSArray *)allSubClasses;

@end
