//
//  UIImagePickerController+JCStream.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIImagePickerController+JCStream.h"
#import "JCStream.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface UIImagePickerController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation UIImagePickerController (JCStream)

- (JCStream *)addStream {
    JCStream *stream = objc_getAssociatedObject(self, _cmd);
    if (!stream) {
        self.delegate = self;
        stream = [[JCStream alloc] initWithDelegate:self.delegate];
        objc_setAssociatedObject(self, _cmd, stream, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [stream addDelegateMethod:@selector(imagePickerController:didFinishPickingMediaWithInfo:) exchangeIMP:(IMP)delegateExchangeIMP_didFinishPickingMediaWithInfo];
    }
    return stream;
}

- (void)setFinishPickingMediaWithInfo:(void (^)(UIImagePickerController *, NSDictionary<NSString *,id> *))finishPickingMediaWithInfo {
    [self.addStream addDelegateMethod:@selector(imagePickerController:didFinishPickingMediaWithInfo:) block:finishPickingMediaWithInfo];
}

- (void (^)(UIImagePickerController *, NSDictionary<NSString *,id> *))finishPickingMediaWithInfo {
    return [self.addStream blockWithMethod:@selector(imagePickerController:didFinishPickingMediaWithInfo:)];
}

void delegateExchangeIMP_didFinishPickingMediaWithInfo(id self,SEL _cmd, UIImagePickerController *picker, NSDictionary<NSString *,id> *info) {
    void (^block)(UIImagePickerController *picker, NSDictionary<NSString *,id> *info) = [picker.addStream blockWithMethod:@selector(imagePickerController:didFinishPickingMediaWithInfo:)];
    if (block) {
        block(picker, info);
    }
    ((void (*)(id, SEL, UIImagePickerController *, NSDictionary *))objc_msgSend)(self,delegateExchangeMethodName(_cmd),picker,info);
}

@end
