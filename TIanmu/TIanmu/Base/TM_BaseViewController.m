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
    self.view.backgroundColor = TM_SpecialGlobalColorBg;
    [self initNavBarSetting];
    [self createView];
    [self reloadData];
    self.navigationItem.hidesBackButton = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self createNav];
    }
}
#pragma mark - 创建UI
- (void)createNav {
    // 返回按钮
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 20, 20);
    [returnBtn setImage:[UIImage imageNamed:@"back_white_icon"] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"back_white_icon"] forState:UIControlStateHighlighted];
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 10);
    [returnBtn addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnBtnItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItems = @[ returnBtnItem];
    
}
#pragma mark - Activity
- (void)leftNavItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView {
    
}
- (void)reloadData {
    
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

#pragma mark - getting
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavi_StatusBarHeight - kTabBarHeight)];
        _contentScrollView.delegate = self;
        _contentScrollView.showsVerticalScrollIndicator = NO;
    }
    return _contentScrollView;
}

@end
