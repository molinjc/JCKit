//
//  JCKeyboardManager.h
//  JCKeyboardTest
//
//  Created by 林建川 on 16/10/11.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCKeyboardManager : NSObject

+ (instancetype)shareManager;

/**
 是否要键盘弹出时调整视图
 */
@property (nonatomic, assign) BOOL enable;

/**
 YES: 附加自定义的UIToolbar，NO: 不附加
 */
@property (nonatomic, assign) BOOL accompanyToolbar;

@end
