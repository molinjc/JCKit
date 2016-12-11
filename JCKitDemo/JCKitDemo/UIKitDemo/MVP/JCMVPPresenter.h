//
//  JCMVPPresenter.h
//  JCKitDemo
//
//  Created by molin.JC on 2016/11/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCSignal.h"

@interface JCMVPPresenter : NSObject

@property (nonatomic, strong) JCSignal *mvpSignal;

- (void)event1;

- (void)event2;

- (void)event3;

@end
