//
//  JCStream.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/5.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIControl.h>

typedef void(^JCObserverBlock)(__weak id obj, NSString *keyPath, id oldValue, id newValue);
typedef void(^JCNotificationBlock)(NSNotification *notification);
typedef void(^JCTargetBlock)(id sender);

/**
 Base
 */
@interface JCStream : NSObject

@property (nonatomic, weak) UIControl *control;

- (instancetype)initWithHold:(id)hold;

@end

/**
 KVO
 */
@interface JCStream (JCObserver)

- (JCStream *)addKeyPath:(NSString *)keyPath;
- (JCStream *)removeKeyPath:(NSString *)keyPath;
- (JCStream *)removeAllKeyPath;
- (JCStream *)observeValueForBlock:(JCObserverBlock)block;

@end

/**
 通知
 */
@interface JCStream (JCNotification)

- (JCStream *)notificationForName:(NSString *)name;
- (JCStream *)removeNotificationForName:(NSString *)name;
- (JCStream *)removeAllNotificationName;
- (JCStream *)notificationBlock:(JCNotificationBlock)block;

@end

/**
 add-Target
 */
@interface JCStream (JCTarget)

- (instancetype)initWithControl:(UIControl *)contol;

+ (instancetype)streamWithControl:(UIControl *)control;

- (JCStream *)streamControlEvents:(UIControlEvents)controlEvents;

// target_action回调block
- (JCStream *)streamActionBlock:(void (^)(id))block;

// target_action调用的方法
- (void)streamActionCallback:(id)sender;

@end


/**
 Delegate
 */
@interface JCStream (JCDelegate)

@end
