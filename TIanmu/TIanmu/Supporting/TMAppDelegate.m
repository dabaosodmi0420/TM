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
#import "TM_WeixinTool.h"
@interface TMAppDelegate ()

@end

@implementation TMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 注册SDK
    [self registerSDK];
    
    // 创建tabBar控制器
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self createTabBarVC];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Activity
- (UITabBarController *)createTabBarVC {
    TM_TabBarViewController *tabBarVC = [[TM_TabBarViewController alloc] init];
    
    return tabBarVC;
}

- (void)registerSDK {
    
    //在register之前打开log, 后续可以根据log排查问题
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
        NSLog(@"WeChatSDK: %@", log);
    }];

    //务必在调用自检函数前注册
    [WXApi registerApp:kWeixin_AppID universalLink:kWeixin_UniversalLink];

    //调用自检函数
//    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//        NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//    }];
}

#pragma mark - 微信回调
- (void)onResp:(BaseResp*)resp{
    NSLog(@"%@",resp);
    [[TM_WeixinTool shareWeixinToolManager] tm_weixinOnResp:resp];
}

#pragma mark - 回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
    
}
@end
