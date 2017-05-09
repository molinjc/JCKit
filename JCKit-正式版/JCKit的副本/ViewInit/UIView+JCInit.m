//
//  UIView+JCInit.m
//  JCViewLayout
//
//  Created by molin.JC on 2017/3/11.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UIView+JCInit.h"

@implementation NSObject (JCInit)

- (id)set:(void (^)(id))initBlock {
    if (initBlock) {
        initBlock(self);
    }
    return self;
}

@end

@implementation UIView (JCInit)

+ (instancetype)viewInit:(id)init, ... {
    if (!init) {
        return VIEW;
    }
    
    id nextInit = init;
    UIView *view = VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UIView class]]) {
            view = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            view.backgroundColor = nextInit;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [view.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return view;
}

@end

@implementation UILabel (JCInit)

+ (instancetype)labelInit:(id)init, ... {
    if (!init) {
        return LABEL;
    }
    
    id nextInit = init;
    UILabel *label = LABEL;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UILabel class]]) {
            label = nextInit;
        }else if ([nextInit isKindOfClass:[NSString class]]) {
            label.text = nextInit;
        }else if ([nextInit isKindOfClass:[NSAttributedString class]]) {
            label.attributedText = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            label.textColor = nextInit;
        }else if ([nextInit isKindOfClass:[UIFont class]]) {
            label.font = nextInit;
        }else if ([nextInit isKindOfClass:[NSNumber class]]) {
            NSInteger type = [(NSNumber *)nextInit integerValue];
            if (type >= 0 && type <= 4) {
                label.textAlignment = type;
            }
        }
        else if ([nextInit isKindOfClass:[CALayer class]]) {
            [label.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return label;
}

@end

@implementation UIImageView (JCInit)

+ (instancetype)imageViewInit:(id)init, ... {
    if (!init) {
        return IMAGE_VIEW;
    }
    
    id nextInit = init;
    UIImageView *imageView = IMAGE_VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UIImageView class]]) {
            imageView = nextInit;
        }else if ([nextInit isKindOfClass:[UIImage class]]) {
            imageView.image = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            imageView.backgroundColor = nextInit;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [imageView.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return imageView;
}

@end

@implementation UIButton (JCInit)

+ (instancetype)buttonInit:(id)init, ... {
    if (!init) {
        return BUTTON;
    }
    
    id nextInit = init;
    UIButton *button = BUTTON;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[NSNumber class]]) {
            NSInteger type = [(NSNumber *)nextInit integerValue];
            if (type >= 0 && type < 6) {
                button = [UIButton buttonWithType:type];
            }
        }else if ([nextInit isKindOfClass:[UIButton class]]) {
            button = nextInit;
        }else if ([nextInit isKindOfClass:[NSString class]]) {
            [button setTitle:init forState:UIControlStateNormal];
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            [button setTitleColor:init forState:UIControlStateNormal];
        }else if ([nextInit isKindOfClass:[UIImage class]]) {
            [button setImage:init forState:UIControlStateNormal];
        }else if ([nextInit isKindOfClass:[UIFont class]]) {
            button.titleLabel.font = init;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [button.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return button;
}

@end

@implementation UITableView (JCInit)

+ (instancetype)tableViewInit:(id)init, ... {
    if (!init) {
        return TABLE_VIEW;
    }
    
    id nextInit = init;
    UITableView *tableView = TABLE_VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UITableView class]]) {
            tableView = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            tableView.backgroundColor = init;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [tableView.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return tableView;
}

+ (instancetype)tableViewProtocol:(id)protocol init:(id)init, ... {
    if (!init) {
        return TABLE_VIEW;
    }
    
    id nextInit = init;
    UITableView *tableView = TABLE_VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UITableView class]]) {
            tableView = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            tableView.backgroundColor = init;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [tableView.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    tableView.delegate = protocol;
    tableView.dataSource = protocol;
    return tableView;
}

@end

@implementation UIScrollView (JCInit)

+ (instancetype)scrollViewInit:(id)init, ... {
    if (!init) {
        return SCROLL_VIEW;
    }
    
    id nextInit = init;
    UIScrollView *scrollView = SCROLL_VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UIScrollView class]]) {
            scrollView = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            scrollView.backgroundColor = init;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [scrollView.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return scrollView;
}

@end

@implementation UICollectionView (JCInit)

+ (instancetype)collectionViewInit:(id)init, ... {
    if (!init) {
        return COLLECTION_VIEW;
    }
    
    id nextInit = init;
    UICollectionView *collectionView = COLLECTION_VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UICollectionView class]]) {
            collectionView = nextInit;
        }else if ([nextInit isKindOfClass:[UICollectionViewLayout class]]) {
            collectionView.collectionViewLayout = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            collectionView.backgroundColor = init;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [collectionView.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return collectionView;
}

+ (instancetype)collectionViewProtocol:(id)protocol init:(id)init, ... {
    if (!init) {
        return COLLECTION_VIEW;
    }
    
    id nextInit = init;
    UICollectionView *collectionView = COLLECTION_VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UICollectionView class]]) {
            collectionView = nextInit;
        }else if ([nextInit isKindOfClass:[UICollectionViewLayout class]]) {
            collectionView.collectionViewLayout = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            collectionView.backgroundColor = init;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [collectionView.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    collectionView.delegate = protocol;
    collectionView.dataSource = protocol;
    return collectionView;
}

@end

@implementation UITextField (JCInit)

+ (instancetype)textFieldInit:(id)init, ... {
    if (!init) {
        return TEXT_FIELD;
    }
    
    id nextInit = init;
    UITextField *textField = TEXT_FIELD;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UITextField class]]) {
            textField = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            textField.textColor = init;
        }else if ([nextInit isKindOfClass:[NSString class]]) {
            textField.placeholder = nextInit;
        }else if ([nextInit isKindOfClass:[NSAttributedString class]]) {
            textField.attributedPlaceholder = nextInit;
        }else if ([nextInit isKindOfClass:[NSNumber class]]) {
            NSInteger type = [(NSNumber *)nextInit integerValue];
            if (type >= 0 && type <= 11) {
                textField.keyboardType = type;
            }
        }else if ([nextInit isKindOfClass:[UIFont class]]) {
            textField.font = nextInit;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [textField.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return textField;
}

@end

@implementation UITextView (JCInit)

+ (instancetype)textViewInit:(id)init, ... {
    if (!init) {
        return TEXT_VIEW;
    }
    
    id nextInit = init;
    UITextView *textView = TEXT_VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UITextField class]]) {
            textView = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            textView.textColor = init;
        }else if ([nextInit isKindOfClass:[NSString class]]) {
            textView.text = nextInit;
        }else if ([nextInit isKindOfClass:[NSAttributedString class]]) {
            textView.attributedText = nextInit;
        }else if ([nextInit isKindOfClass:[NSNumber class]]) {
            NSInteger type = [(NSNumber *)nextInit integerValue];
            if (type >= 0 && type <= 4) {
                textView.textAlignment = type;
            }
        }else if ([nextInit isKindOfClass:[UIFont class]]) {
            textView.font = nextInit;
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [textView.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return textView;
}

@end

@implementation UIFont (JCInit)

+ (instancetype)fontInit:(id)init, ... {
    if (!init) {
        return [UIFont systemFontOfSize:15];
    }
    
    id nextInit = init;
    NSString *name;
    CGFloat size = 0;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UIFont class]]) {
            return nextInit;
        }else if ([nextInit isKindOfClass:[NSString class]]) {
            name = nextInit;
        }else if ([nextInit isKindOfClass:[NSNumber class]]) {
            size = [(NSNumber *)nextInit floatValue];
        }
    } while ((nextInit = va_arg(arglist, id)));
    va_end(arglist);
    
    if (name) {
        if (size > 0) {
            return [UIFont fontWithName:name size:size];
        }else {
            return [UIFont fontWithName:name size:15];
        }
    }else if (size > 0) {
        return [UIFont systemFontOfSize:size];
    }
    return [UIFont systemFontOfSize:15];
}

@end

@implementation UIViewController (JCInit)

+ (instancetype)viewControllerInit:(id)init, ... {
    if (!init) {
        return VIEW_CONTROLLER;
    }
    
    id nextInit = init;
    UIViewController *viewController = VIEW_CONTROLLER;;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UIViewController class]]) {
            viewController = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            viewController.view.backgroundColor = init;
        }else if ([nextInit isKindOfClass:[NSString class]]) {
            viewController.title = nextInit;
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return viewController;
}

@end

@implementation UINavigationController (JCInit)

+ (instancetype)navigationControllerInit:(id)init, ... {
    if (!init) {
        return nil;
    }
    
    id nextInit = init;
    UINavigationController *navigationController;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UINavigationController class]]) {
            navigationController = nextInit;
        }else if ([nextInit isKindOfClass:[UIViewController class]]) {
            navigationController = NAVIGATION_CONTROLLER(nextInit);
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            [navigationController.navigationBar setBarTintColor:init];
        }else if ([nextInit isKindOfClass:[UIImage class]]) {
            [navigationController.navigationBar setBackgroundImage:nextInit forBarMetrics:UIBarMetricsDefault];
        }else if ([nextInit isKindOfClass:[UITabBarItem class]]) {
            navigationController.tabBarItem = nextInit;
        }else if ([nextInit isKindOfClass:[NSDictionary class]]) {
            [navigationController.navigationBar setTitleTextAttributes:nextInit];
        }else if ([nextInit isKindOfClass:[NSString class]]) {
            navigationController.title = nextInit;
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return navigationController;
}

@end

@implementation UITabBarController (JCInit)

+ (instancetype)tabBarControllerInit:(id)init, ... {
    if (!init) {
        return TAB_BAR_CONTROLLER;
    }
    
    id nextInit = init;
    UITabBarController *tabBarController = TAB_BAR_CONTROLLER;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UITabBarController class]]) {
            tabBarController = nextInit;
        }else if ([nextInit isKindOfClass:[UINavigationController class]]) {
            [tabBarController addChildViewController:nextInit];
        }else if ([nextInit isKindOfClass:[UIViewController class]]) {
            [tabBarController addChildViewController:nextInit];
        }else if ([nextInit isKindOfClass:[NSArray class]]) {
            for (id vc in nextInit) {
                if ([vc isKindOfClass:[UIViewController class]]) {
                    [tabBarController addChildViewController:vc];
                }
            }
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            [tabBarController.tabBar setBarTintColor:init];
        }else if ([nextInit isKindOfClass:[UIImage class]]) {
            [tabBarController.tabBar setBackgroundImage:nextInit];
        }else if ([nextInit isKindOfClass:[UITabBar class]]) {
            [tabBarController setValue:nextInit forKey:@"tabBar"];
        }else if ([nextInit isKindOfClass:[NSString class]]) {
            tabBarController.title = nextInit;
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return tabBarController;
}

@end

@implementation UIWindow (JCInit)

+ (instancetype)windowInit:(id)init, ... {
    if (!init) {
        return WINDOW;
    }
    
    id nextInit = init;
    UIWindow *window = WINDOW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UIWindow class]]) {
            window = nextInit;
        }else if ([nextInit isKindOfClass:[UIViewController class]]) {
            window.rootViewController = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            window.backgroundColor = nextInit;
        }else if ([nextInit isKindOfClass:[UIView class]]) {
            [window addSubview:nextInit];
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [window.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return window;
}

@end

@implementation UIWebView (JCInit)

+ (instancetype)webViewInit:(id)init, ... {
    if (!init) {
        return WEB_VIEW;
    }
    
    id nextInit = init;
    UIWebView *webView = WEB_VIEW;
    va_list arglist;
    va_start(arglist, init);
    do {
        if ([nextInit isKindOfClass:[UIWebView class]]) {
            webView = nextInit;
        }else if ([nextInit isKindOfClass:[UIColor class]]) {
            webView.backgroundColor = nextInit;
        }else if ([nextInit isKindOfClass:[UIView class]]) {
            [webView addSubview:nextInit];
        }else if ([nextInit isKindOfClass:[CALayer class]]) {
            [webView.layer addSublayer:nextInit];
        }
    } while ((nextInit = va_arg(arglist, id)));
    
    va_end(arglist);
    return webView;
}

@end
