//
//  TM_MainViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/3.
//

#import "TM_MainViewController.h"
#import "TM_TabBarViewController.h"
#import "TM_NavigationController.h"


@interface TM_MainViewController ()

@end

@implementation TM_MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self switchTabBarViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)switchTabBarViewController {
    // 创建tabBar控制器
    TM_TabBarViewController *tabBarVC = [[TM_TabBarViewController alloc] init];
    [self addChildViewController:tabBarVC];
    [self.view addSubview:tabBarVC.view];
}

@end
