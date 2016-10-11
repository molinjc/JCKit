//
//  UIImagePickerController+JCStream.h
//  JCKitDemo
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (JCStream)

@property (nonatomic, copy) void (^finishPickingMediaWithInfo)(UIImagePickerController *picker, NSDictionary<NSString *,id> *info);

@end
