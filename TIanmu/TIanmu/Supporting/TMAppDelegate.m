//
//  AppDelegate.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/12.
//

#import "TMAppDelegate.h"
#import "TM_TabBarViewController.h"
#import "TM_NavigationController.h"
#import "TM_HomePageViewController.h"
#import "TM_ServicePageViewController.h"
#import "TM_PersonPageViewController.h"
@interface TMAppDelegate ()

@end

@implementation TMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建tabBar控制器
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self createTabBarVC];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UITabBarController *)createTabBarVC {
    TM_TabBarViewController *tabBarVC = [[TM_TabBarViewController alloc] init];
    
    return tabBarVC;
}


@end
