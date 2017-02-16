//
//  NSObject+JCRunTime.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/2/14.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JCRunTime)

- (void)setAssociatedNonatomicRetainKey:(const void *)key value:(id)value;

- (void)setAssociatedNonatomicCopyKey:(const void *)key value:(id) value;

- (void)setAssociatedNonatomicAssigeKey:(const void *)key value:(id) value;

- (id)getAssociatedKey:(const void *)key;

@end
