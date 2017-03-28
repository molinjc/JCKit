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
FocusUI_Init_M(UIScrollView)
FocusUIButton_Init_M(UIButton, UIButtonTypeSystem)

#pragma mark - NavigationController

@interface JCNavigationController ()

@end

@implementation JCNavigationController

@end

#pragma mark - TabBarController

NSString * const JCTabBarControllerChildControllerName = @"JCTabBarControllerSubControllerName";
NSString * const JCTabBarControllerChildControllerClass = @"JCTabBarControllerChildControllerClass";
NSString * const JCTabBarControllerChildControllerTitle = @"JCTabBarControllerSubControllerTitle";
NSString * const JCTabBarControllerChildControllerNormalImage = @"JCTabBarControllerSubControllerNormalImage";
NSString * const JCTabBarControllerChildControllerSelectedImage = @"JCTabBarControllerSubControllerSelectedImage";

@interface JCTabBarController ()

@end

@implementation JCTabBarController

- (void)addChildViewControllers:(NSArray<NSDictionary *> *)childViewControllers {
    if (childViewControllers.count == 0 || childViewControllers == nil) {
        return;
    }
    
    for (NSDictionary *dic in childViewControllers) {
        NSString *className = dic[JCTabBarControllerChildControllerName];
        Class class;
        UIViewController *childViewController;
        if (className.length > 0) {
            class = NSClassFromString(className);
            if (class) {
                childViewController = class.new;
            }
        }else {
            childViewController = dic[JCTabBarControllerChildControllerClass];
        }
        if (childViewController) {
            [self addChildViewController:childViewController title:dic[JCTabBarControllerChildControllerTitle] image:dic[JCTabBarControllerChildControllerNormalImage] selectedImage:dic[JCTabBarControllerChildControllerSelectedImage]];
        }else {
            NSLog(@"该childViewController为空！");
        }
    }
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:childController];
    navigationController.tabBarItem =  [[UITabBarItem alloc]initWithTitle:title image:image selectedImage:selectedImage];
    [self addChildViewController:navigationController];
}

@end
