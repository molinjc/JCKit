//
//  JCSimplifyUI.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/2/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCSimplifyUI.h"

#define FocusUI_Init_M(className) \
@implementation className (JCFocus)\
+ (instancetype)focus##className##Init:(void (^)(className *ins))focus {\
className *ins = [[className alloc] init];\
if(focus) {\
focus(ins);\
}\
return ins;\
}\
@end


#define FocusUIButton_Init_M(className, buttonType) \
@implementation className (JCFocus)\
+ (instancetype)focus##className##Init:(void (^)(className *ins))focus {\
className *ins = [className buttonWithType:buttonType];\
if(focus) {\
focus(ins);\
}\
return ins;\
}\
@end


FocusUI_Init_M(UIView)
FocusUI_Init_M(UILabel)
FocusUI_Init_M(UITableView)
FocusUI_Init_M(UIImageView)
FocusUI_Init_M(UIControl)
FocusUI_Init_M(UICollectionView)
FocusUI_Init_M(UITextView)
FocusUI_Init_M(UITextField)
FocusUI_Init_M(UISwitch)
FocusUIButton_Init_M(UIButton, UIButtonTypeSystem)
