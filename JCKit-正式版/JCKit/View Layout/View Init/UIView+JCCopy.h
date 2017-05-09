//
//  NSObject+JCCopy.h
//  JCMVPDemo
//
//  Created by molin.JC on 2017/4/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (JCCopy)

- (instancetype)copyObject;

- (instancetype)copyObjectWithKeys:(NSArray <NSString *> *)keys;

@end

/**
 这里声明分类
 @param class 类名(不要带前缀)
 */
#define _CopyObject(class) _CopyObject_Prefix(UI, class)
#define _CopyObject_Prefix(prefix,class) \
@interface prefix ## class (JCCopy)  \
- (instancetype)copy##class;\
@end

_CopyObject(View);
_CopyObject(ImageView)
_CopyObject(Label);
