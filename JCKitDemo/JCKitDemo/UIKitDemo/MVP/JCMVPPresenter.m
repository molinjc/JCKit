//
//  JCMVPPresenter.m
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCMVPPresenter.h"

@implementation JCMVPPresenter

- (instancetype)init {
    if (self = [super init]) {
        self.mvpSignal = [JCSignal signal];
    }
    return self;
}

- (void)event1 {
    [self.mvpSignal sendSubscriptionNumber:@"button1" withValue:@"按钮1"];
}

- (void)event2 {
    [self.mvpSignal sendSubscriptionNumber:@"button2" withValue:@"按钮2"];
}

- (void)event3 {
    
    [self.mvpSignal sendSubscriptionNumber:@"button2" withValue:@"按钮2"];
}

@end
