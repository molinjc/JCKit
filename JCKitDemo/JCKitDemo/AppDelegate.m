//
//  AppDelegate.m
//  JCKitDemo
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "AppDelegate.h"
#import "JCKitMacro.h"
#import "JCViewController.h"

#import "JCGraphicsUtilities.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    JCViewController *vc = [[JCViewController alloc] init];
    UINavigationController *rootNavigationC = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootNavigationC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    CGPathCreateWithPoints(3,CGPointMake(0, 10),CGPointMake(0, 0),CGPointMake(20, 30));
    
    //application.shortcutItems = @[[self touch3D]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    NSLog(@"%@ \n %@",shortcutItem, shortcutItem.userInfo);
    
    /// 判断方式可根据自己需要变更
    if ([shortcutItem.localizedTitle isEqualToString:@"test1"]) {
        NSLog(@"test1");
    }
    if ([shortcutItem.localizedTitle isEqualToString:@"test2"]) {
        NSLog(@"test2");
    }
}

- (UIApplicationShortcutItem *)touch3D {
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"2"];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"test1" localizedTitle:@"test1-1" localizedSubtitle:@"test1-1-1" icon:icon1 userInfo:@{@"a":@"a"}];
    return item1;
}

@end
