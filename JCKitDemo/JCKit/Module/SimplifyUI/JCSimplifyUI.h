//
//  JCSimplifyUI.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/2/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FocusUI_Init_H(className) \
@interface className (JCFocus)\
+ (instancetype)focus##className##Init:(void (^)(className *ins))focus;\
@end


FocusUI_Init_H(UIView)
FocusUI_Init_H(UILabel)
FocusUI_Init_H(UITableView)
FocusUI_Init_H(UIImageView)
FocusUI_Init_H(UIControl)
FocusUI_Init_H(UICollectionView)
FocusUI_Init_H(UITextView)
FocusUI_Init_H(UITextField)
FocusUI_Init_H(UISwitch)
