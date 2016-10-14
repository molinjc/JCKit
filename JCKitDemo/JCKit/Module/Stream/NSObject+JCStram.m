//
//  NSObject+JCStramKVO.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/7.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSObject+JCStram.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (JCStram)

- (JCStream *)addStream {
    JCStream *stream = objc_getAssociatedObject(self, _cmd);
    if (!stream) {
        stream = [[JCStream alloc] initWithHold:self];
        objc_setAssociatedObject(self, _cmd, stream, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self swizzleDealloc];
    }
    return stream;
}

- (void)swizzleDealloc {
    //我们给每个类绑定上一个值来判断dealloc方法是否被调剂过，如果调剂过了就无需再次调剂了
    BOOL swizzled = [objc_getAssociatedObject(self.class, _cmd) boolValue];
    
    //如果调剂过则直接返回
    if (swizzled) {
        return;
    }
    
    //开始调剂
    Class swizzleClass = self.class;
    @synchronized(swizzleClass) {
        //获取原有的dealloc方法
        SEL deallocSelector = sel_registerName("dealloc");
        //初始化一个函数指针用于保存原有的dealloc方法
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        //实现我们自己的dealloc方法，通过block的方式
        id newDealloc = ^(__unsafe_unretained id objSelf){
            //在这里我们移除所有的KVO
            [self.addStream removeAllKeyPath];
            [self.addStream removeAllNotificationName];
            //根据原有的dealloc方法是否存在进行判断
            if (originalDealloc == NULL) {//如果不存在，说明本类没有实现dealloc方法，则需要向父类发送dealloc消息(objc_msgSendSuper)
                //构造objc_msgSendSuper所需要的参数，.receiver为方法的实际调用者，即为类本身，.super_class指向其父类
                struct objc_super superInfo = {
                    .receiver = objSelf,
                    .super_class = class_getSuperclass(swizzleClass)
                };
                //构建objc_msgSendSuper函数
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                //向super发送dealloc消息
                msgSend(&superInfo, deallocSelector);
            }else{//如果存在，表明该类实现了dealloc方法，则直接调用即可
                //调用原有的dealloc方法
                originalDealloc(objSelf, deallocSelector);
            }
        };
        //根据block构建新的dealloc实现IMP
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        //尝试添加新的dealloc方法，如果该类已经复写的dealloc方法则不能添加成功，反之则能够添加成功
        if (!class_addMethod(swizzleClass, deallocSelector, newDeallocIMP, "v@:")) {
            //如果没有添加成功则保存原有的dealloc方法，用于新的dealloc方法中
            Method deallocMethod = class_getInstanceMethod(swizzleClass, deallocSelector);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        //标记该类已经调剂过了
        objc_setAssociatedObject(self.class, _cmd, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


@end
