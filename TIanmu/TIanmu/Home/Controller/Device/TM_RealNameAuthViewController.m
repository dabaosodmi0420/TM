//
//  TM_RealNameAuthViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_RealNameAuthViewController.h"
#import "TM_DataCardApiManager.h"
#import "TM_WeixinTool.h"
@interface TM_RealNameAuthViewController ()

/* 运营商数组 */
@property (strong, nonatomic) NSArray *operator_list;


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
    
    
    
}
- (void)refreshUI {
    for (int i = 0; i < self.operator_list.count; i++) {
        NSDictionary *data = self.operator_list[i];
        // 运营商实名部分

        NSString *type = data[@"card_operator"];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(30, 180 + (100 + 25) * i, kScreen_Width - 60, 100)];
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
        icon.image = [UIImage imageNamed: type];
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
        
        NSString *is_realname = [NSString stringWithFormat:@"%@",data[@"is_realname"]];
        if ([is_realname intValue] == 2) {
            [UIView setHorGradualChangingColor:realNameV colorArr:@[TM_ColorHex(@"#FFFEAD"), TM_ColorHex(@"#FFA500")]];
            realNameL.text = @"已实名";
        }else {
            [UIView setHorGradualChangingColor:realNameV colorArr:@[TM_ColorHex(@"#f1f1f1"), TM_ColorHex(@"#dbdbdb")]];
            realNameL.text = @"未实名";
        }
    }
}
- (void)reloadData {
    
    [TM_DataCardApiManager sendQueryDeviceAuthUrlWithCardNo:self.cardDetailInfoModel.iccid success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                self.operator_list = data[@"operator_info"][@"operator_list"];
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
    NSDictionary *data = self.operator_list[tag];
    NSString *is_realname = [NSString stringWithFormat:@"%@",data[@"is_realname"]];
    if ([is_realname intValue] == 2) {
        TM_ShowToast(self.view, @"已实名");
    }else {
        NSString *type = data[@"card_operator"];
        // 全网通 聚火
        if ([self.deviceIndexInfoModel.cardTypeInfo.card_type isEqualToString:@"device_qwtsb"] || [self.deviceIndexInfoModel.cardTypeInfo.card_type isEqualToString:@"device_qwt3wbjh "]) {
            [TM_DataCardApiManager sendQueryQWTDeviceAuthInfoWithCardNo:self.cardDetailInfoModel.iccid card_operator:type success:^(id  _Nullable respondObject) {
                if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                    id data = respondObject[@"data"];
                    NSString *iccid = data[@"iccid"];
                    if (iccid && iccid.length > 0) {
                        // 电信
                        NSString *url = @"http://uniteapp.ctwing.cn:9090/uapp/certifhtml/certif_entry.html?userCode=r/s9Tc00hjiKcR13MIjZHg==&passWord=9u8VuY1xbez6r6k/BBnLlw==&tmstemp=1595318328145&from=groupmessage&isappinstalled=0";
                        
                        [self gotoLoadRealNameCard_operator:type iccid:iccid url:url];
                    }
                }else {
                    NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
                    TM_ShowToast(self.view, msg);
                }
            } failure:^(NSError * _Nullable error) {
                NSLog(@"%@",error);
                TM_ShowToast(self.view, @"获取数据失败");
            }];
        }else {
            NSString *card_iccid = data[@"card_iccid"];
            if ([type isEqualToString:@"mobile"] || [type isEqualToString:@"unicom"]) {
                [self gotoLoadRealNameCard_operator:type iccid:card_iccid url:@""];
            }else {
                [TM_DataCardApiManager sendSetAuthWithCardNo:card_iccid success:^(id  _Nullable respondObject) {
                    if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                        id data = respondObject[@"data"];
                        //实名url，若是data为空，且state是success，则说明已实名
                        NSString *url = data[@"url"];
                        if (url && url.length > 0) {
                            [self gotoLoadRealNameCard_operator:type iccid:card_iccid url:url];
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
    
}
// 去实名
- (void)gotoLoadRealNameCard_operator:(NSString *)card_operator iccid:(NSString *)iccid  url:(NSString *)url{
    //telecom电信，mobile移动；unicom联通
    NSString *title = @"";
    if ([card_operator isEqualToString:@"mobile"] ) {
        title = @"移动";
    }else if ([card_operator isEqualToString:@"unicom"] ) {
        title = @"联通";
    }else {
        title = @"电信";
    }
    [JTBaseTool copyContent:iccid];
    [JTDefinitionTextView jt_showWithTitle:title Text:iccid type:0 actionTextArr:@[@"取消", @"已复制，去实名"] handler:^(NSInteger index) {
        if (index == 1) {
            // 移动、联通拉起小程序
            if ([card_operator isEqualToString:@"mobile"] || [card_operator isEqualToString:@"unicom"]) {
                NSString *netType = @"";
                if ([card_operator isEqualToString:@"mobile"] ) {
                    netType = @"yd";
                }else {
                    netType = @"lt";
                }
                [[TM_WeixinTool shareWeixinToolManager] tm_weixinToolWithType:TM_WeixinToolTypeMiniProgram data:@{@"netType" : netType} completeBlock:^(TM_WeixinToolType type, NSDictionary * _Nonnull param) {
                    
                }];
            }else {
                if (url.length > 0) {
                    [JTBaseTool jt_openUrl:url];
                }
            }
        }
    }];
    TM_ShowToast(self.view, @"已复制");
}
@end
