//
//  TM_AboutCompanyController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import "TM_AboutCompanyController.h"

@interface TM_AboutCompanyController ()

@end

@implementation TM_AboutCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNav];
}
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
- (void)createView {
    self.title = @"关于天目e生活APP";
    // 顶部logo
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 55,  kScreen_Width * 0.4, kScreen_Width * 0.4)];
    logoImg.centerX = kScreen_Width * 0.5;
    logoImg.image = [UIImage imageNamed:@"denglu"];
    logoImg.layer.cornerRadius = logoImg.width * 0.5;
    logoImg.clipsToBounds = YES;
    logoImg.contentMode = UIViewContentModeScaleAspectFit;
    logoImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:logoImg];
    
    UILabel *msg = [UIView createLabelWithFrame:CGRectMake(0, logoImg.maxY + 40, kScreen_Width, 40) title:@"Copyright ©2021\n山东省得润电子信息科技有限公司版权所有" fontSize:16 color:[UIColor darkTextColor]];
    msg.numberOfLines = 0;
    msg.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:msg];
}
#pragma mark - Activity
- (void)leftNavItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
