//
//  TM_RechargeViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import "TM_RechargeViewController.h"

@interface TM_RechargeViewController ()

@end

@implementation TM_RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView {
    [super createView];
    if (self.model.funcType == TM_ShortMenuTypeBalanceRecharge) {
        self.title = @"余额充值";
    }else if (self.model.funcType == TM_ShortMenuTypeFlowRecharge) {
        self.title = @"流量充值";
    }
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 220)];
    [self.view addSubview:topView];
    [UIView setVerGradualChangingColor:topView colorArr:@[TM_SpecialGlobalColor, TM_ColorRGB(59, 85, 183)]];
    // 顶部logo
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 25, 90, 90)];
    logoImg.image = [UIImage imageNamed:@"logo"];
    logoImg.layer.cornerRadius = logoImg.width * 0.5;
    logoImg.clipsToBounds = YES;
    logoImg.contentMode = UIViewContentModeScaleAspectFit;
    logoImg.backgroundColor = [UIColor clearColor];
    [topView addSubview:logoImg];
    
    // 当前套餐
    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(logoImg.maxX + 25, 20, 0, 25) title:@"当前套餐：测试" fontSize:16 color:[UIColor whiteColor]];
    [label1 sizeToFit];
    [topView addSubview:label1];
    // 已用天数
    UILabel *label2 = [UIView createLabelWithFrame:CGRectMake(label1.x, label1.maxY + 15, 0, 25) title:@"已使用：0天" fontSize:16 color:[UIColor whiteColor]];
    [label2 sizeToFit];
    [topView addSubview:label2];
    // 剩余天数
    UILabel *label3 = [UIView createLabelWithFrame:CGRectMake(label2.maxX + 60, label2.y, 0, 25) title:@"剩余：0天" fontSize:16 color:[UIColor whiteColor]];
    [label3 sizeToFit];
    [topView addSubview:label3];
    // 余额
    UILabel *label4 = [UIView createLabelWithFrame:CGRectMake(label1.x, label2.maxY + 15, 0, 25) title:@"剩余：0.1元" fontSize:16 color:[UIColor whiteColor]];
    [label4 sizeToFit];
    [topView addSubview:label4];
    // 设备编号
    UILabel *label5 = [UIView createLabelWithFrame:CGRectMake(logoImg.x, logoImg.maxY + 20, 0, 25) title:@"设备编号：0000000" fontSize:16 color:[UIColor whiteColor]];
    [label5 sizeToFit];
    [topView addSubview:label5];
    // 有效期
    UILabel *label6 = [UIView createLabelWithFrame:CGRectMake(logoImg.x, label5.maxY + 20, 0, 25) title:@"套餐有效期：2023-01-01" fontSize:16 color:[UIColor whiteColor]];
    [label6 sizeToFit];
    [topView addSubview:label6];
    
}


@end
