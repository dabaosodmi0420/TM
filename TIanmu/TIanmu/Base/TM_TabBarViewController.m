//
//  TM_TabBarViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_TabBarViewController.h"
#import "TM_BaseViewController.h"
#import "TM_NavigationController.h"
@interface TM_TabBarViewController ()

@end

@implementation TM_TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = [self createTabBarViewController];
    self.tabBar.backgroundColor = [UIColor lightTextColor];
    self.tabBar.tintColor = TM_SpecialGlobalColor;
    self.tabBar.unselectedItemTintColor = TM_ColorRGB(110, 110, 110);
}

- (NSMutableArray *)createTabBarViewController {
    NSArray *classNames = @[
        TM_HomePageViewControllerName,
        TM_ServicePageViewControllerName,
        TM_PersonPageViewControllerName
    ];
    NSArray *tabBarTitles = @[
        @"首页",
        @"客服",
        @"我的"
    ];
    NSArray *tabBarImageNormal = @[
        @"tab_me_normal",
        @"tab_me_normal",
        @"tab_me_normal"
    ];
    NSArray *tabBarImageSelect = @[
        @"tab_me_select",
        @"tab_me_select",
        @"tab_me_select"
    ];
    
    // 创建Tabbar上的ViewController
    NSMutableArray *viewControllers = [NSMutableArray array];

    for (int i = 0; i < classNames.count; i ++) {
        NSString *className = classNames[i];
        NSString *title = tabBarTitles[i];
        Class class = NSClassFromString(className);
        id obj = [[class alloc] init];
        if (obj && [obj isKindOfClass:[TM_BaseViewController class]]){
            TM_BaseViewController *vc = obj;
            vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNormal[i]] selectedImage:[UIImage imageNamed:tabBarImageSelect[i]]];
            TM_NavigationController *nav = [[TM_NavigationController alloc] initWithRootViewController:vc];
            [viewControllers addObject:nav];
        }
    }
    return viewControllers;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
