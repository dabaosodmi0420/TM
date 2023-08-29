//
//  TM_NewHandGuideViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import "TM_NewHandGuideViewController.h"

@interface TM_NewHandGuideViewController ()

@end

@implementation TM_NewHandGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)createView {
    self.title = @"新手指导";
    
    self.view.backgroundColor = TM_ColorHex(@"dddddd");
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 160)];
    topview.backgroundColor = TM_SpecialGlobalColor;
    [self.view addSubview:topview];
    
    UILabel *l1 = [UIView createLabelWithFrame:CGRectMake(0, 60, kScreen_Width, 40) title:@"使用流程" fontSize:0 color:[UIColor whiteColor]];
    l1.font = [UIFont boldSystemFontOfSize:30];
    l1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:l1];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(10, topview.height - 30, kScreen_Width - 20, 90)];
    [v1 setCornerRadius:10];
    v1.backgroundColor = TM_ColorHex(@"eeeeee");
    [self.view addSubview:v1];
    
    UILabel *v1_l1 = [UILabel createLabelWithFrame:CGRectMake(20, 20, 100, 25) title:@"1.绑定流量卡" fontSize:17 color:TM_ColorHex(@"444444")];
    v1_l1.backgroundColor = [UIColor clearColor];
    [v1 addSubview:v1_l1];
    
    UILabel *v1_l2 = [UILabel createLabelWithFrame:CGRectMake(20, v1_l1.maxY + 10, v1.width - 60 - 20, 25) title:@"请先绑定物联网卡，才可以进行后续操作." fontSize:16 color:TM_ColorHex(@"888888")];
    v1_l2.backgroundColor = [UIColor clearColor];
    [v1 addSubview:v1_l2];
    
    UIView *v1_v = [[UIView alloc] initWithFrame:CGRectMake(v1.width - 55, (v1.height - 30) * 0.5 ,  55, 30)];
    [UIView setHorGradualChangingColor:v1_v colorArr:@[[UIColor whiteColor], [UIColor greenColor]]];
    [v1_v setCornerRadius:v1_v.height * 0.5 rectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    v1_v.clipsToBounds = YES;
    [v1 addSubview:v1_v];
    
    UILabel *v1_l3 = [UILabel createLabelWithFrame:v1_v.bounds title:@"去绑定" fontSize:16 color:TM_ColorHex(@"222222")];
    v1_l3.textAlignment = NSTextAlignmentRight;
    v1_l3.backgroundColor = [UIColor clearColor];
    [v1_v addSubview:v1_l3];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(10, v1.maxY + 40, kScreen_Width - 20, 105)];
    [v2 setCornerRadius:10];
    v2.backgroundColor = TM_ColorHex(@"eeeeee");
    [self.view addSubview:v2];
    
    UILabel *v2_l1 = [UILabel createLabelWithFrame:CGRectMake(20, 20, 100, 25) title:@"2.激活流量卡" fontSize:17 color:TM_ColorHex(@"444444")];
    v2_l1.backgroundColor = [UIColor clearColor];
    [v2 addSubview:v2_l1];
    
    UILabel *v2_l2 = [UILabel createLabelWithFrame:CGRectMake(20, v2_l1.maxY + 10, v2.width - 70 - 20, 40) title:@"根据工信部规定，物联网卡必须实名认证后方可上网使用." fontSize:16 color:TM_ColorHex(@"888888")];
    v2_l2.numberOfLines = 0;
    v2_l2.backgroundColor = [UIColor clearColor];
    [v2 addSubview:v2_l2];
    
    UIView *v2_v = [[UIView alloc] initWithFrame:CGRectMake(v2.width - 55, (v2.height - 30) * 0.5 ,  55, 30)];
    [UIView setHorGradualChangingColor:v2_v colorArr:@[[UIColor whiteColor], [UIColor greenColor]]];
    [v2_v setCornerRadius:v2_v.height * 0.5 rectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    v2_v.clipsToBounds = YES;
    [v2 addSubview:v2_v];
    
    UILabel *v2_l3 = [UILabel createLabelWithFrame:v2_v.bounds title:@"去激活" fontSize:16 color:TM_ColorHex(@"222222")];
    v2_l3.textAlignment = NSTextAlignmentRight;
    v2_l3.backgroundColor = [UIColor clearColor];
    [v2_v addSubview:v2_l3];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(10, v2.maxY + 40, kScreen_Width - 20, 90)];
    [v3 setCornerRadius:10];
    v3.backgroundColor = TM_ColorHex(@"eeeeee");
    [self.view addSubview:v3];
    
    UILabel *v3_l1 = [UILabel createLabelWithFrame:CGRectMake(20, 20, 100, 25) title:@"3.购买套餐" fontSize:17 color:TM_ColorHex(@"444444")];
    v3_l1.backgroundColor = [UIColor clearColor];
    [v3 addSubview:v3_l1];
    
    UILabel *v3_l2 = [UILabel createLabelWithFrame:CGRectMake(20, v3_l1.maxY + 10, v3.width - 60 - 20, 25) title:@"请对流量卡充值，有多种套餐供您选择." fontSize:16 color:TM_ColorHex(@"888888")];
    v3_l2.backgroundColor = [UIColor clearColor];
    [v3 addSubview:v3_l2];
    
    UIView *v3_v = [[UIView alloc] initWithFrame:CGRectMake(v3.width - 55, (v3.height - 30) * 0.5 ,  55, 30)];
    [UIView setHorGradualChangingColor:v3_v colorArr:@[[UIColor whiteColor], [UIColor greenColor]]];
    [v3_v setCornerRadius:v3_v.height * 0.5 rectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    v3_v.clipsToBounds = YES;
    [v3 addSubview:v3_v];
    
    UILabel *v3_l3 = [UILabel createLabelWithFrame:v3_v.bounds title:@"去充值" fontSize:16 color:TM_ColorHex(@"222222")];
    v3_l3.textAlignment = NSTextAlignmentRight;
    v3_l3.backgroundColor = [UIColor clearColor];
    [v3_v addSubview:v3_l3];
}

@end
