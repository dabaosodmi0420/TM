//
//  TM_PayViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/4.
//

#import "TM_PayViewController.h"

@interface TM_PayViewController ()
@property (strong, nonatomic) UITableView                       *tableView;

@end

@implementation TM_PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView {
    self.title = @"充值支付";
    // 顶部
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 90)];
    topView.backgroundColor = TM_SpecialGlobalColor;
    [self.view addSubview:topView];
    
    UILabel *label = [UIView createLabelWithFrame:CGRectMake(0, 10, kScreen_Width, 30) title:@"支付金额" fontSize:17 color:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    
    NSString *money = self.money ? [NSString stringWithFormat:@"￥%0.2f", [self.money doubleValue]] : @"￥0.00";
    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(0, 50, kScreen_Width, 30) title:money fontSize:22 color:[UIColor whiteColor]];
    label1.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label1];
    
    // 支付选择
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.maxY + 15, kScreen_Width, 60)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    imageV.image = [UIImage imageNamed:@"pay_ico_wechat"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:imageV];
    
    UILabel *label3 = [UIView createLabelWithFrame:CGRectMake(imageV.maxX + 10, 10, kScreen_Width - imageV.maxX - 50, 20) title:@"微信支付" fontSize:17 color:[UIColor darkTextColor]];
    [contentView addSubview:label3];
    
    UILabel *label4 = [UIView createLabelWithFrame:CGRectMake(imageV.maxX + 10, label3.maxY , kScreen_Width - imageV.maxX - 50, 20) title:@"推荐安装微信5.0及以上版本的使用" fontSize:14 color:TM_ColorHex(@"#888888")];
    [contentView addSubview:label4];
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 38, (contentView.height - 18) * 0.5, 18, 18)];
    imageV1.image = [UIImage imageNamed:@"cb_s"];
    imageV1.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:imageV1];
    
    // 充值按钮
    UIButton *recharge = [UIView createButton:CGRectMake(30, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 40 - 10, kScreen_Width - 60, 40)
                                        title:@"确认付款"
                                   titleColoe:TM_ColorRGB(255, 255, 255)
                                selectedColor:TM_ColorRGB(255, 255, 255)
                                     fontSize:17
                                          sel:@selector(rechargeClick)
                                       target:self];
    recharge.backgroundColor = TM_SpecialGlobalColor;
    [recharge setCornerRadius:10];
    [self.view addSubview:recharge];
}

- (void)rechargeClick {
    if (self.wxPayData) {
        [[TM_WeixinTool shareWeixinToolManager] tm_weixinToolWithType:TM_WeixinToolTypePay data:self.wxPayData completeBlock:^(TM_WeixinToolType type, NSDictionary * _Nonnull param) {
            NSLog(@"%@",param);
            if (param && [[NSString stringWithFormat:@"%@", param[@"errCode"]] isEqualToString:@"0"]) {
                [JTDefinitionTextView jt_showWithTitle:@"" Text:@"支付成功" type:JTAlertTypeNot actionTextArr:@[@"确定"] handler:^(NSInteger index) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else {
                TM_ShowToast(self.view, param[@"errMsg"]);
            }
        }];
    }
}

@end
