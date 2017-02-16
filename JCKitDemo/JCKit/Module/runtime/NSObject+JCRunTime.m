//
//  NSObject+JCRunTime.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/2/14.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "NSObject+JCRunTime.h"
#import <objc/runtime.h>
@implementation NSObject (JCRunTime)

- (void)setAssociatedNonatomicRetainKey:(const void *)key value:(id)value {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssociatedNonatomicCopyKey:(const void *)key value:(id) value {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setAssociatedNonatomicAssigeKey:(const void *)key value:(id) value {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)getAssociatedKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

- (NSArray *)allProperty {
    unsigned int count;
    NSMutableArray *mArray = [NSMutableArray new];
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = propertys[i];
        [mArray addObject:(__bridge id _Nonnull)(property)];
    }
    free(propertys);
    return mArray.copy;
}

@end
