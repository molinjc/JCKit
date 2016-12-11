//
//  JCRunTime.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface JCRunTime : NSObject

void setAssociatedNonatomicRetainObject(id object, const void *key, id value);

void setAssociatedNonatomicCopyObject(id object, const void *key, id value);

void setAssociatedNonatomicAssigeObject(id object, const void *key, id value);

id getAssociatedObject(id object, const void *key);

void propertyList(Class cla , void (^block)(objc_property_t property));

NSArray<NSString *> * copyPropertyNameList(Class cla);

void methodList(Class cla, void (^block)(Method method));

NSArray<NSString *> *copyMethodList(Class cla);

@end
