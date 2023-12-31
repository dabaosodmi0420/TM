//
//  TM_BaseViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_BaseViewController.h"
#import "TM_ConfigTool.h"

@interface TM_BaseViewController ()

@end

@implementation TM_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavBarSetting];
    [self createView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)createView {
    
}

- (void)showNotOpenAlert {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"功能暂未开启";
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.5];
    [self.view addSubview:hud];
}


/**
 *  初始化导航条样式设置
 */
- (void)initNavBarSetting {
    NSDictionary *navBarConfig = [NSDictionary dictionaryWithObjectsAndKeys:TM_ColorRGB(230, 248, 255), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil];
    //不透明 保证 extendedLayoutIncludesOpaqueBars = YES时 frame.y = 0 在导航栏下方
    self.navigationController.navigationBar.translucent = NO;
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.backgroundColor = TM_SpecialGlobalColor;
        barApp.shadowColor = TM_SpecialGlobalColor;
        barApp.titleTextAttributes = navBarConfig;
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationController.navigationBar.standardAppearance = barApp;
    }else{
        //设置navBar白色字体
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TM_ColorRGB(230, 248, 255), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];
        //设置navBar背景
        [self.navigationController.navigationBar setBarTintColor:TM_SpecialGlobalColor];
        [self setNavigationBarColor:TM_SpecialGlobalColor];
    }
}
- (void)setNavigationBarColor:(UIColor *)color {
    //navBar前景设置
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    //设置navBar底部阴影线
    [self.navigationController.navigationBar setShadowImage:[self imageWithColor:color]];
}
- (UIImage *)imageWithColor:(UIColor*)color {
    CGRect imgRect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(imgRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, imgRect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
