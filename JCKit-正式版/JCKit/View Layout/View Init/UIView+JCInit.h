//
//  UIView+JCInit.h
//  JCViewLayout
//
//  Created by molin.JC on 2017/3/11.
//  Copyright © 2017年 molin. All rights reserved.
//  Version 1.0

#import <UIKit/UIKit.h>

@interface NSObject (JCInit)
- (id)set:(void (^)(id init))initBlock;
@end

#pragma mark - UIView

#define VIEW            [[UIView alloc] init]
#define VIEW_INIT(...)  [UIView viewInit:__VA_ARGS__, nil]

@interface UIView (JCInit)

/**
 创建UIView
 @param init 可变参数，可以用UIView、UIColor、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UIView时，最好是放在第一个，不然UIView之前的值就无效，UIView后面的才起效.
 @remark UIColor是设置backgroundColor的
 @return UIView
 */
+ (instancetype)viewInit:(id)init, ...;

@end

#pragma mark - UILabel

#define LABEL [[UILabel alloc] init]
#define LABEL_INIT(...) [UILabel labelInit:__VA_ARGS__, nil]

@interface UILabel (JCInit)

/**
 创建UILabel
 @param init 可变参数，可以用UILabel、NSString、NSAttributedString、UIColor、UIFont、NSNumber、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UILabel时，最好是放在第一个，不然UILabel之前的值就无效，UILabel后面的才起效.
 @remark UIColor是设置textColor的.
 @remark NSNumber是设置textAlignment，NSTextAlignment值范围0-4.
 @return UILabel
 */
+ (instancetype)labelInit:(id)init, ...;
@end

#pragma mark - UIImageView

#define IMAGE_VIEW [[UIImageView alloc] init]
#define IMAGE_VIEW_INIT(...) [UIImageView imageViewInit:__VA_ARGS__, nil]

@interface UIImageView (JCInit)

/**
 创建UIImageView
 @param init 可变参数，可以用UIImageView、UIImage、UIColor、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UIImageView时，最好是放在第一个，不然UIImageView之前的值就无效，UIImageView后面的才起效.
 @remark UIColor是设置backgroundColor的.
 @return UIImageView
 */
+ (instancetype)imageViewInit:(id)init, ...;
@end

#pragma mark - UIButton

#define BUTTON [UIButton buttonWithType:UIButtonTypeRoundedRect]
#define BUTTON_INIT(...) [UIButton buttonInit:__VA_ARGS__, nil]

@interface UIButton (JCInit)

/**
 创建UIButton，buttonType默认为UIButtonTypeRoundedRect
 @param init 可变参数，可以用NSNumber、UIButton、NSString、UIImage、UIColor、UIFont、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UIButton时，最好是放在第一个，不然UIButton之前的值就无效，UIButton后面的才起效.
 @remark NSNumber是设置buttonType，UIButtonType枚举值范围0-5，设置该值时，最好是放在第一个，也不要含有UIButton了.
 @remark UIColor是设置setTitleColor的
 @return UIButton
 */
+ (instancetype)buttonInit:(id)init, ...;
@end

#pragma mark - UITableView

#define TABLE_VIEW [[UITableView alloc] init]
#define TABLE_VIEW_INIT(...) [UITableView tableViewInit:__VA_ARGS__, nil]
#define TABLE_VIEW_PROTOCOL_INIT(protocol, ...) [UITableView tableViewProtocol:protocol init:__VA_ARGS__, nil]

@interface UITableView (JCInit)

/**
 创建UITableView
 @param init 可变参数，可以用UITableView、UIColor、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UITableView时，最好是放在第一个，不然UITableView之前的值就无效，UITableView后面的才起效.
 @remark UIColor是设置backgroundColor的.
 @return UITableView
 */
+ (instancetype)tableViewInit:(id)init, ...;

/**
 创建UITableView, 并设置代理对象
 @param protocol 代理对象
 @param init 可变参数，可以用UITableView、UIColor、CALayer
 @remark protocol 设置delegate和dataSource的代理对象
 @see tableViewInit:
 @return UITableView
 */
+ (instancetype)tableViewProtocol:(id)protocol init:(id)init, ...;
@end

#pragma mark - UIScrollView

#define SCROLL_VIEW [[UIScrollView alloc] init]
#define SCROLL_VIEW_INIT(...) [UIScrollView scrollViewInit:__VA_ARGS__, nil]

@interface UIScrollView (JCInit)

/**
 创建UIScrollView
 @param init 可变参数，可以用UITableView、UIColor、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UIScrollView时，最好是放在第一个，不然UIScrollView之前的值就无效，UIScrollView后面的才起效.
 @remark UIColor是设置backgroundColor的.
 @return UIScrollView
 */
+ (instancetype)scrollViewInit:(id)init, ...;
@end

#pragma mark - UICollectionView

#define COLLECTION_VIEW [[UICollectionView alloc] init]
#define COLLECTION_VIEW_INIT(...) [UICollectionView collectionViewInit:__VA_ARGS__, nil]
#define COLLECTION_VIEW_PROTOCOL_INIT(protocol, ...) [UICollectionView collectionViewProtocol:protocol init:__VA_ARGS__, nil]

@interface UICollectionView (JCInit)

/**
 创建UICollectionView
 @param init 可变参数，可以用UICollectionView、UICollectionViewLayout、UIColor、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UICollectionView时，最好是放在第一个，不然UICollectionView之前的值就无效，UICollectionView后面的才起效.
 @remark UIColor是设置backgroundColor的.
 @return UICollectionView
 */
+ (instancetype)collectionViewInit:(id)init, ...;

/**
 创建UICollectionView, 并设置代理对象
 @param protocol 代理对象
 @param init 可变参数，可以用UICollectionView、UICollectionViewLayout、UIColor、CALayer
 @remark protocol 设置delegate和dataSource的代理对象
 @see collectionViewInit:
 @return UICollectionView
 */
+ (instancetype)collectionViewProtocol:(id)protocol init:(id)init, ...;
@end

#pragma mark - UITextField

#define TEXT_FIELD [[UITextField alloc] init]
#define TEXT_FIELD_INIT(...) [UITextField textFieldInit:__VA_ARGS__, nil]

@interface UITextField (JCInit)

/**
 创建UITextField
 @param init 可以用UITextField、UIColor、NSString、NSAttributedString、NSNumber、UIFont、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UITextField时，最好是放在第一个，不然UITextField之前的值就无效，UITextField后面的才起效.
 @remark UIColor是设置textColor的.
 @remark NSString是设置placeholder, NSAttributedString是设置attributedPlaceholder
 @remark NSNumber是设置keyboardType，UIKeyboardType值范围0-11.
 @return UITextField
 */
+ (instancetype)textFieldInit:(id)init, ...;
@end

#pragma mark - UITextView

#define TEXT_VIEW [[UITextView alloc] init]
#define TEXT_VIEW_INIT(...) [UITextView textViewInit:__VA_ARGS__, nil]

@interface UITextView (JCInit)

/**
 创建UITextView
 @param init 可以用UITextView、UIColor、NSString、NSAttributedString、NSNumber、UIFont、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 参数里含有UITextView时，最好是放在第一个，不然UITextView之前的值就无效，UITextView后面的才起效.
 @remark UIColor是设置textColor的.
 @remark NSString是设置text, NSAttributedString是设置attributedText
 @remark NSNumber是设置textAlignment，NSTextAlignment值范围0-4.
 @return UITextView
 */
+ (instancetype)textViewInit:(id)init, ...;
@end

#pragma mark - UIFont

#define FONT_INIT(...) [UIFont fontInit:__VA_ARGS__, nil]

@interface UIFont (JCInit)

/**
 创建UIFont, 默认字体大小为15
 @param init 可变参数，可以用UIFont、NSString、NSNumber
 @remark 使用该类方法时，一定要在最后加nil.
 @remark NSString是设置字体名
 @remark NSNumber是设置字体大小
 @return UIFont
 */
+ (instancetype)fontInit:(id)init, ...;

@end

#pragma mark - UIImage

#define IMAGE(name) [UIImage imageNamed:name]

#pragma mark - UIViewController

#define VIEW_CONTROLLER [[UIViewController alloc] init]
#define VIEW_CONTROLLER_INIT(...) [UIViewController viewControllerInit:__VA_ARGS__, nil]

@interface UIViewController (JCInit)

/**
 创建UIViewController
 @param init 可变参数，可以用UIViewController、UIColor、NSString
 @remark 使用该类方法时，一定要在最后加nil.
 @remark UIColor是设置view的backgroundColor的.
 @remark NSString是设置titl.
 @return UIViewController
 */
+ (instancetype)viewControllerInit:(id)init, ...;
@end

#pragma mark - UINavigationController

#define NAVIGATION_CONTROLLER(root) [[UINavigationController alloc] initWithRootViewController:root]
#define NAVIGATION_CONTROLLER_INIT(...) [UINavigationController navigationControllerInit:__VA_ARGS__, nil]

@interface UINavigationController (JCInit)

/**
 创建UINavigationController
 @param init 可变参数，可以用UINavigationController、UIViewController、UIColor、UIImage、UITabBarItem、NSDictionary、NSString
 @remark 使用该类方法时，一定要在最后加nil.
 @remark 含有UINavigationController、UIViewController时，取最后一个创建UINavigationController，后面的参数将设置在这个UINavigationController上.
 @remark UIColor设置setBarTintColor.
 @remark UIImage设置setBackgroundImage.
 @remark NSDictionary设置setTitleTextAttributes
 @return UINavigationController
 */
+ (instancetype)navigationControllerInit:(id)init, ...;
@end

#pragma mark - UITabBarController

#define TAB_BAR_CONTROLLER [[UITabBarController alloc] init]
#define TAB_BAR_CONTROLLER_INIT(...) [UITabBarController tabBarControllerInit:__VA_ARGS__, nil]

@interface UITabBarController (JCInit)

/**
 创建UITabBarController
 @param init 可变参数，可以用UITabBarController、UINavigationController、UIViewController、NSArray、UIColor、UIImage、UITabBar、NSString.
 @remark 使用该类方法时，一定要在最后加nil.
 @remark UINavigationController、UIViewController都是作为子控件, 添加到childViewControllers.
 @remark NSArray只包含UIViewController对象，等于childViewControllers，都是子控件.
 @remark UIColor设置setBarTintColor.
 @remark UIImage设置setBackgroundImage.
 @remark UITabBar是替换tabBar属性
 @return UITabBarController
 */
+ (instancetype)tabBarControllerInit:(id)init, ...;
@end

#pragma mark - UIWindow

#define WINDOW [[UIWindow alloc] init]
#define WINDOW_INIT(...) [UIWindow windowInit:__VA_ARGS__, nil]

@interface UIWindow (JCInit)

/**
 创建UIWindow
 @param init 可变参数，可以用UIWindow、UIViewController、UIColor、UIView、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark UIViewController设置rootViewController
 @remark UIColor设置背景颜色
 @remark UIView、CALayer都会添加到视图
 @return UIWindow
 */
+ (instancetype)windowInit:(id)init, ...;
@end

#pragma mark - 

#define WEB_VIEW [[UIWebView alloc] init]
#define WEB_VIEW_INIT(...) [UIWebView webViewInit:_VA_ARGS__, nil]

@interface UIWebView (JCInit)

/**
 创建UIWebView
 @param init 可变参数，可以用UIWebView、UIColor、UIView、CALayer
 @remark 使用该类方法时，一定要在最后加nil.
 @remark UIColor设置背景颜色
 @remark UIView、CALayer都会添加到视图
 @return UIWebView
 */
+ (instancetype)webViewInit:(id)init, ...;
@end
