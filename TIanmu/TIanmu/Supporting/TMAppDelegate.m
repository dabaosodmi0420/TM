//
//  AppDelegate.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/12.
//

#import "TMAppDelegate.h"
#import "TM_MainViewController.h"
#import "TM_WeixinTool.h"
#import "PrivacyAgreementView.h"
#import "AppOperateGuideView.h"
#import <Bugly/Bugly.h>
/**
 com.tm.tmlife
 appid：038e7a942a
 appkey：8f52d1d8-e3d8-4709-b65e-85f823f1e79b
 https://bugly.qq.com/docs/user-guide/instruction-manual-ios/?v=1.0.0
 */
@interface TMAppDelegate ()

@end

@implementation TMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 创建根控制器
    [self createRootViewController];
    // 注册SDK
    [self registerSDK];
    // 展示隐私协议
    [self showPrivateProtocal];
    return YES;
}

#pragma mark - Activity
- (void)createRootViewController {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [TM_MainViewController new];
    [self.window makeKeyAndVisible];
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
    
    [Bugly startWithAppId:@"038e7a942a"];
}
- (void)showPrivateProtocal {
    [PrivacyAgreementView showPrivacyAgreementComplete:^{
            
        [AppOperateGuideView showAppGuideViewComplete:^{
            
        }];
    }];
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
