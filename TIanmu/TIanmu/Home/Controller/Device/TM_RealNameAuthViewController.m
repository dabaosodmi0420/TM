//
//  TM_RealNameAuthViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_RealNameAuthViewController.h"
#import "TM_DataCardApiManager.h"
#import "TM_TmfskInfoModel.h"
#import "TM_WeixinTool.h"
@interface TM_RealNameAuthViewController ()
/* data */
@property (strong, nonatomic) TM_TmfskInfoModel *tmfskInfoData;

@end

@implementation TM_RealNameAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 创建UI
- (void)createView {
    self.title = @"实名认证";
    
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(realNameClick:)];
        [contentView1 addGestureRecognizer:tap];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 94, 72)];
        icon.centerY = contentView1.height * 0.5;
        icon.image = [UIImage imageNamed: icons[i]];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [contentView1 addSubview:icon];
        
        UIView *realNameV = [[UIView alloc] initWithFrame:CGRectMake(contentView1.width - 60, 0, 60, 30)];
        realNameV.tag = 110 + i;
        realNameV.centerY = contentView1.height * 0.5;
        [realNameV setCornerRadius:realNameV.height * 0.5 rectCorner:(UIRectCornerTopLeft | UIRectCornerBottomLeft)];
        [contentView1 addSubview:realNameV];
        
        UILabel *realNameL = [UIView createLabelWithFrame:CGRectMake(contentView1.width - 60, 0, 60, 30) title:@"未实名" fontSize:15 color:[UIColor darkTextColor]];
        realNameL.tag = 120 + i;
        realNameL.textAlignment = NSTextAlignmentRight;
        realNameL.centerY = contentView1.height * 0.5;
        realNameL.backgroundColor = [UIColor clearColor];
        [realNameL setCornerRadius:realNameL.height * 0.5 rectCorner:(UIRectCornerTopLeft | UIRectCornerBottomLeft)];
        [contentView1 addSubview:realNameL];
    }
}
- (void)refreshUI {
    for (TM_TmfskInfoListModel *model in self.tmfskInfoData.list) {
        NSInteger i = 0;
        if ([model.isp isEqualToString:@"telecom"]) { // 电信
            i = 0;
        }else if ([model.isp isEqualToString:@"cmcc"]) {  // 联通
            i = 1;
        }else if ([model.isp isEqualToString:@"unicom"]) {  // 移动
            i = 2;
        }
        UILabel *realNameV = (UILabel *)[self.view viewWithTag:110 + i];
        UILabel *realNameL = (UILabel *)[self.view viewWithTag:120 + i];
        if ([model.is_identity intValue] == 1) {
            [UIView setHorGradualChangingColor:realNameV colorArr:@[TM_ColorHex(@"#FFFEAD"), TM_ColorHex(@"#FFA500")]];
            realNameL.text = @"已实名";
        }else {
            [UIView setHorGradualChangingColor:realNameV colorArr:@[TM_ColorHex(@"#f1f1f1"), TM_ColorHex(@"#dbdbdb")]];
            realNameL.text = @"未实名";
        }
    }
}
- (void)reloadData {
    [TM_DataCardApiManager sendQueryTmfskInfoWithCardNo:self.cardDetailInfoModel.card_define_no success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                self.tmfskInfoData = [TM_TmfskInfoModel mj_objectWithKeyValues:respondObject[@"data"]];
                [self refreshUI];
            }else {
                TM_ShowToast(self.view, @"获取数据失败");
            }
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"获取数据失败");
    }];
    
    
}

- (void)realNameClick:(UIGestureRecognizer *)ges {
    NSLog(@"%@",ges.view);
    UIView *selectedView = ges.view;
    NSInteger tag = selectedView.tag - 100;
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
    TM_TmfskInfoListModel *model = nil;
    for (TM_TmfskInfoListModel *modelTmp in self.tmfskInfoData.list) {
        if ([modelTmp.isp isEqualToString:isp]) {
            model = modelTmp;
            break;
        }
        
    }
    if ([model.is_identity intValue] == 1) {
        TM_ShowToast(self.view, @"已实名");
    }else {
        if (tag == 1) { // 联通拉起小程序
            [[TM_WeixinTool shareWeixinToolManager] tm_weixinToolWithType:TM_WeixinToolTypeMiniProgram data:@{} completeBlock:^(TM_WeixinToolType type, NSDictionary * _Nonnull param) {
                
            }];
        }else {
            [TM_DataCardApiManager sendSetTmfskAuthWithCardNo:self.cardDetailInfoModel.card_no
                                                        iccid:model.iccid
                                                       msisdn:model.msisdn
                                                      netType:netType
                                                      success:^(id  _Nullable respondObject) {
                NSLog(@"%@",respondObject);
                if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                    id data = respondObject[@"data"];
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        
                    }else {
                        TM_ShowToast(self.view, @"获取数据失败");
                    }
                }else {
                    NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
                    TM_ShowToast(self.view, msg);
                }
            } failure:^(NSError * _Nullable error) {
                NSLog(@"%@",error);
                TM_ShowToast(self.view, @"获取数据失败");
            }];
            
            [TM_DataCardApiManager sendUpdateTmfskAuthWithCardNo:self.cardDetailInfoModel.card_define_no success:^(id  _Nullable respondObject) {
                NSLog(@"%@",respondObject);
                if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                    id data = respondObject[@"data"];
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        
                    }else {
                        TM_ShowToast(self.view, @"获取数据失败");
                    }
                }else {
                    NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
                    TM_ShowToast(self.view, msg);
                }
            } failure:^(NSError * _Nullable error) {
                NSLog(@"%@",error);
                TM_ShowToast(self.view, @"获取数据失败");
            }];
        }
    }
    
}

@end
