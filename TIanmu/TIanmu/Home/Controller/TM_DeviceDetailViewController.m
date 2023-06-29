//
//  TM_DeviceDetailViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "TM_DeviceDetailViewController.h"

@interface TM_DeviceDetailViewController ()

@end

@implementation TM_DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNav];
}
#pragma mark - 创建UI
- (void)createNav {
    self.title = @"设备";
    
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
- (void)createView {
    [super createView];
    
}
#pragma mark - Activity
- (void)leftNavItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
