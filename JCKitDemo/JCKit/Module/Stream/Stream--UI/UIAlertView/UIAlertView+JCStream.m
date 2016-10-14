//
//  UIAlertView+JCStream.m
//  JCKitDemo
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIAlertView+JCStream.h"
#import "JCStream.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIAlertView () <UIAlertViewDelegate>

@end

@implementation UIAlertView (JCStream)

- (JCStream *)addStream {
    JCStream *stream = objc_getAssociatedObject(self, _cmd);
    if (!stream) {
        self.delegate = self;
        stream = [[JCStream alloc] initWithDelegate:self.delegate];
        objc_setAssociatedObject(self, _cmd, stream, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [stream addDelegateMethod:@selector(alertView:clickedButtonAtIndex:) exchangeIMP:(IMP)delegateExchangeIMP_AlertView];
    }
    return stream;
}

- (void)setClickedButtonBlock:(void (^)(UIAlertView *, NSInteger))clickedButtonBlock {
    [self.addStream addDelegateMethod:@selector(alertView:clickedButtonAtIndex:) block:clickedButtonBlock];
}

- (void (^)(UIAlertView *, NSInteger))clickedButtonBlock {
    return [self.addStream blockWithMethod:@selector(alertView:clickedButtonAtIndex:)];
}

void delegateExchangeIMP_AlertView(id self,SEL _cmd, UIAlertView *alertView, NSInteger buttonIndex) {
    void (^block)(UIAlertView *, NSInteger) = [alertView.addStream blockWithMethod:@selector(alertView:clickedButtonAtIndex:)];
    if (block) {
        block(alertView, buttonIndex);
    }
    ((void (*)(id, SEL, UIAlertView *, NSInteger))objc_msgSend)(self,delegateExchangeMethodName(_cmd),alertView,buttonIndex);
}

@end
