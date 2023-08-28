//
//  TM_ChangeNetViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_ChangeNetViewController.h"

@interface TM_ChangeNetViewController ()

@end

@implementation TM_ChangeNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 创建UI
- (void)createView {
    self.title = @"网络切换";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 150)];
    [topView setCornerRadius:10 rectCorner:(UIRectCornerBottomLeft | UIRectCornerBottomRight)];
    [self.view addSubview:topView];
    [UIView setVerGradualChangingColor:topView colorArr:@[TM_SpecialGlobalColor, TM_ColorRGB(59, 85, 183)]];
    
    // 设备编号
    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(30, 40, 200, 25) title:@"设备编号" fontSize:16 color:[UIColor whiteColor]];
    [label1 sizeToFit];
    [topView addSubview:label1];
    // 有效期
    UILabel *label2 = [UIView createLabelWithFrame:CGRectMake(30, label1.maxY + 5, 200, 30) title:self.cardDetailInfoModel.iccid fontSize:18 color:[UIColor whiteColor]];
    [label2 sizeToFit];
    [topView addSubview:label2];
    
    
    // 运营商实名部分
    NSArray *icons = @[@"china_telecom", @"china_unicom", @"china_mobile"];
    
    for (int i = 0; i < icons.count; i++) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(30, topView.maxY + 30 + (100 + 25) * i, kScreen_Width - 60, 100)];
        contentView.backgroundColor = TM_ColorHex(@"#DDDDDD");
        contentView.layer.cornerRadius = 10;
        contentView.clipsToBounds = YES;
        [self.view addSubview:contentView];
        
        UIView *contentView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 15, contentView.width - 30, contentView.height - 30)];
        contentView1.backgroundColor = [UIColor whiteColor];
        contentView1.layer.cornerRadius = 10;
        contentView1.clipsToBounds = YES;
        contentView1.tag = 100 + i;
        [contentView addSubview:contentView1];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 94, 72)];
        icon.centerY = contentView1.height * 0.5;
        icon.image = [UIImage imageNamed: icons[i]];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [contentView1 addSubview:icon];
        
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(contentView1.width - 60, 0, 50, 30)];
        sw.centerY = contentView1.height * 0.5;
        [sw addTarget:self action:@selector(changeNetwork:) forControlEvents:UIControlEventValueChanged];
        sw.tag = 110 + i;
        [contentView1 addSubview:sw];
    }
}
- (void)refreshUI {
    
}

- (void)reloadData {
    
}

- (void)changeNetwork:(UISwitch *)sw {
    NSInteger tag = sw.tag - 110;
    NSString *isp = @"";
    NSString *netType = @"";
    // 网络类型，yd，lt，dx
    if (tag == 0) { // 电信
        isp = @"telecom";
        netType = @"dx";
    }else if (tag == 1) { // 联通
        isp = @"cmcc";
        netType = @"lt";
    }else if (tag == 2) { // 移动
        isp = @"unicom";
        netType = @"yd";
    }
}
@end
