//
//  TM_DeviceBalanceRechargeViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/9/1.
//

#import "TM_DeviceBalanceRechargeViewController.h"
#import "JT_TopSegmentMenuView.h"
#import "TM_DataCardApiManager.h"
#import "TM_DataCardUsedFlowModel.h"
#import "TM_WeixinTool.h"
#import "TM_PayViewController.h"
#import "TM_NoticeView.h"

#define K_TmpStr  @"# #"
@interface TM_DeviceBalanceRechargeViewController () {
    UIButton *_selectedBtn;
    NSArray <UILabel *>*_topInfoLables;
    NSString *_noticeContent;
}
/* 流量卡使用情况 */
@property (strong, nonatomic) TM_DataCardUsedFlowModel  *usedFlowModel;
@property (strong, nonatomic) TM_NoticeView *noticeView;
#pragma mark - 余额充值
/* customMoneyTF */
@property (strong, nonatomic) UITextField               *customMoneyTF;
/* 流量卡卡号 */
@property (strong, nonatomic) UILabel                   *balanceCardNumL;
/* 余额充值数组 */
@property (strong, nonatomic) NSArray                   *balanceRechargeArr;
/* 当前选中充值金额 */
@property (copy, nonatomic) NSString                    *balanceRecharge;
@end

@implementation TM_DeviceBalanceRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}
- (void)createView {
    [super createView];
    // 充值按钮
    UIButton *recharge = [UIView createButton:CGRectMake(0, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 44, kScreen_Width, 44)
                                        title:@"立即充值"
                                   titleColoe:TM_ColorRGB(255, 255, 255)
                                selectedColor:TM_ColorRGB(255, 255, 255)
                                     fontSize:16
                                          sel:@selector(rechargeClick)
                                       target:self];
    recharge.backgroundColor = TM_SpecialGlobalColor;
    [self.view addSubview:recharge];
    
    if (self.menuModel.funcType == TM_ShortMenuTypeBalanceRecharge) {
        self.title = @"余额充值";
        self.contentScrollView.height = recharge.y;
    }else if (self.menuModel.funcType == TM_ShortMenuTypeFlowRecharge) {
        self.title = @"流量充值";
        self.contentScrollView.height = recharge.y - 30;
        [JTDefinitionTextView jt_showWithTitle:@"" Text:@"订购套餐当月立即生效，请确认！！！" type:JTAlertTypeNot actionTextArr:@[@"确认"] handler:^(NSInteger index) {
                    
        }];
    }
    [self.view addSubview:self.contentScrollView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 220)];
    [self.contentScrollView addSubview:topView];
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
    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(logoImg.maxX + 25, 20, 0, 25) title:[NSString stringWithFormat:@"当前套餐:%@", K_TmpStr] fontSize:16 color:[UIColor whiteColor]];
    [label1 sizeToFit];
    [topView addSubview:label1];
    // 已用天数
    UILabel *label2 = [UIView createLabelWithFrame:CGRectMake(label1.x, label1.maxY + 15, 0, 25) title:[NSString stringWithFormat:@"已使用:%@天", K_TmpStr] fontSize:16 color:[UIColor whiteColor]];
    [label2 sizeToFit];
    [topView addSubview:label2];
    // 剩余天数
    UILabel *label3 = [UIView createLabelWithFrame:CGRectMake(label2.maxX + 30, label2.y, 0, 25) title:[NSString stringWithFormat:@"剩余:%@天", K_TmpStr] fontSize:16 color:[UIColor whiteColor]];
    [label3 sizeToFit];
    [topView addSubview:label3];
    // 余额
    UILabel *label4 = [UIView createLabelWithFrame:CGRectMake(label1.x, label2.maxY + 15, 0, 25) title:[NSString stringWithFormat:@"剩余:%@元", K_TmpStr] fontSize:16 color:[UIColor whiteColor]];
    [label4 sizeToFit];
    [topView addSubview:label4];
    // 设备编号
    UILabel *label5 = [UIView createLabelWithFrame:CGRectMake(logoImg.x, logoImg.maxY + 20, 0, 25) title:[NSString stringWithFormat:@"设备编号:%@", K_TmpStr] fontSize:16 color:[UIColor whiteColor]];
    [label5 sizeToFit];
    [topView addSubview:label5];
    // 有效期
    UILabel *label6 = [UIView createLabelWithFrame:CGRectMake(logoImg.x, label5.maxY + 20, 0, 25) title:[NSString stringWithFormat:@"套餐有效期:%@", K_TmpStr] fontSize:16 color:[UIColor whiteColor]];
    [label6 sizeToFit];
    [topView addSubview:label6];
    
    _topInfoLables = @[label1, label2, label3, label4, label5, label6];

    
    [self balanceRechargeView];
}
// 刷新顶部数据
- (void)refreshUIData:(NSDictionary *)data {
    self.usedFlowModel = [TM_DataCardUsedFlowModel mj_objectWithKeyValues:data];
    NSArray <NSString *>*datas =  @[
        [NSString stringWithFormat:@"当前套餐:%@",self.cardDetailInfoModel.package_name],
        [NSString stringWithFormat:@"已使用:%@天",self.usedFlowModel.device_info.useDays],
        [NSString stringWithFormat:@"剩余:%@天",self.usedFlowModel.device_info.leftDays],
        [NSString stringWithFormat:@"剩余:%@元",self.usedFlowModel.balance],
        [NSString stringWithFormat:@"设备编号:%@",self.cardDetailInfoModel.iccid],
        [NSString stringWithFormat:@"套餐有效期:%@",self.usedFlowModel.device_info.serveValidDate]
    ];
    for (int i = 0; i < datas.count; i++) {
        UILabel *l = _topInfoLables[i];
        l.text = [NSString stringWithFormat:@"%@",datas[i]];
        [l sizeToFit];
    }
    
    self.balanceCardNumL.text = [NSString stringWithFormat:@"%@",self.cardDetailInfoModel.iccid];
    [self.balanceCardNumL sizeToFit];
    
}
// // MARK: 余额充值页面
- (void)balanceRechargeView {
    // 流量卡卡号
    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(20, 240, 0, 25) title:@"流量卡卡号" fontSize:13 color:TM_ColorRGB(174, 174, 174)];
    [label1 sizeToFit];
    [self.contentScrollView addSubview:label1];
    // 卡号
    UILabel *label2 = [UIView createLabelWithFrame:CGRectMake(label1.x, label1.maxY + 15, 0, 25) title:@"" fontSize:16 color:[UIColor blackColor]];
    [self.contentScrollView addSubview:label2];
    self.balanceCardNumL = label2;
    
    UIView *lineL = [[UIView alloc]initWithFrame:CGRectMake(label2.x, label2.maxY + 8, kScreen_Width - 2 * label2.x, 0.5)];
    lineL.backgroundColor = TM_ColorRGB(174, 174, 174);
    [self.contentScrollView addSubview:lineL];
    
}
// 刷新充值金额数据
- (void)refreshMoneyListUI {
    NSArray *rechargeArr = self.balanceRechargeArr;
    CGFloat gap = 12;
    NSUInteger lineNum = 3;
    CGFloat w = (kScreen_Width - (lineNum + 1) * gap) / lineNum;
    CGFloat h = w / 3.0;
    for (int i = 0; i < rechargeArr.count; i++) {
        NSString *recharge = [NSString stringWithFormat:@"￥%0.2f", [rechargeArr[i] doubleValue]];
        CGFloat x = gap + i % lineNum * (w + gap);
        CGFloat y = gap + i / lineNum * (h + gap) + self.balanceCardNumL.maxY + 10;
        UIButton *btn = [UIView createButton:CGRectMake(x, y, w, h) title:recharge titleColoe:TM_SpecialGlobalColor selectedColor:[UIColor whiteColor] fontSize:15 sel:@selector(changeBalanceRechargeMoney:) target:self];
        [btn setBackgroundImage:[UIImage tm_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage tm_imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage tm_imageWithColor:TM_SpecialGlobalColor] forState:UIControlStateSelected];
        
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = TM_SpecialGlobalColor.CGColor;
        btn.tag = 888 + i;
        [self.contentScrollView addSubview:btn];
        if (i == 0) {
            [self changeBalanceRechargeMoney:btn];
        }
        if (i == rechargeArr.count - 1) { // 自定义金额
            x = gap;
            y = ceil((CGFloat)i / lineNum) * (h + gap) + self.balanceCardNumL.maxY + 10 + gap ;
            UITextField *customMoneyTF = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
            customMoneyTF.font = [UIFont systemFontOfSize:14];
            customMoneyTF.textColor = TM_SpecialGlobalColor;
            customMoneyTF.textAlignment = NSTextAlignmentCenter;
            customMoneyTF.keyboardType = UIKeyboardTypeNumberPad;
            customMoneyTF.placeholder = @"自定义";
            [customMoneyTF addTarget:self action:@selector(customMoneyTFEdit:) forControlEvents:UIControlEventEditingChanged];
            
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"自定义" attributes:@{NSForegroundColorAttributeName:TM_ColorRGB(174, 174, 174),NSFontAttributeName:customMoneyTF.font}];
            customMoneyTF.attributedPlaceholder = attrString;
            customMoneyTF.layer.cornerRadius = 5;
            customMoneyTF.clipsToBounds = YES;
            customMoneyTF.layer.borderWidth = 1;
            customMoneyTF.layer.borderColor = TM_SpecialGlobalColor.CGColor;
            [self.contentScrollView addSubview:customMoneyTF];
            self.customMoneyTF = customMoneyTF;
            [self.noticeView removeFromSuperview];
            self.noticeView = [[TM_NoticeView alloc] initWithFrame:CGRectMake(20, customMoneyTF.maxY + 30, self.contentScrollView.width - 40, 0) content:_noticeContent];
            [self.contentScrollView addSubview:self.noticeView];
            self.contentScrollView.contentSize = CGSizeMake(kScreen_Width, self.noticeView.maxY + 10);
        }
    }
}
#pragma mark - 获取数据
// 获取用户流量信息
- (void)reloadData {
    _noticeContent = @"";
    [TM_DataCardApiManager sendQueryNoticesWithCardNo:self.cardDetailInfoModel.card_define_no type:self.menuModel.funcType == TM_ShortMenuTypeBalanceRecharge ? @"balance" : @"flow" success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"] && [respondObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = respondObject[@"data"] ;
            NSString *content = @"";
            for (NSDictionary *dic in arr) {
                content = [[content stringByAppendingString:dic[@"info"]] stringByAppendingString:@"\n"];
            }
            self->_noticeContent = content;
            
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
        [self requestData];
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"获取数据失败");
        [self requestData];
    }];
    
}
// 查询流量使用情况
- (void)requestData {
    [TM_DataCardApiManager sendQueryUserFlowWithCardNo:self.cardDetailInfoModel.iccid success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                [self refreshUIData:data];
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
    [self requestMoneyList];
}
// 获取充值金额列表数据
- (void)requestMoneyList {
    [TM_DataCardApiManager sendQueryMoneyListWithSuccess:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                self.balanceRechargeArr = [NSArray arrayWithArray:data];
                [self refreshMoneyListUI];
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
#pragma mark - Activity
// 余额充值选择
- (void)changeBalanceRechargeMoney:(UIButton *)btn {
    
    if (_selectedBtn != btn) {
        _selectedBtn.selected = NO;
        _selectedBtn = btn;
        _selectedBtn.selected = YES;
    }
    if (btn.tag - 888 < self.balanceRechargeArr.count) {
        self.balanceRecharge = [NSString stringWithFormat:@"%@", self.balanceRechargeArr[btn.tag - 888]];
    }
}
- (void)customMoneyTFEdit:(UITextField *)tf {
    if(tf.text.length > 0) {
        _selectedBtn.selected = NO;
        _selectedBtn = nil;
    }
    self.balanceRecharge = tf.text;
    
}

- (void)rechargeClick {
    
    NSLog(@"%@",@"余额充值");
    if (self.balanceRecharge && self.balanceRecharge.length > 0) {
        [TM_DataCardApiManager sendGetWechatRechargePreWithPhoneNum:[TM_SettingManager shareInstance].sIdentifierId CardNo:self.cardDetailInfoModel.card_define_no recharge_money:self.balanceRecharge success:^(id  _Nullable respondObject) {
            NSLog(@"%@",respondObject);
            if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                TM_PayViewController *payVC = [TM_PayViewController new];
                payVC.wxPayData = respondObject;
                payVC.money = self.balanceRecharge;
                [self.navigationController pushViewController:payVC animated:YES];
            }else {
                NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
                TM_ShowToast(self.view, msg);
            }
        } failure:^(NSError * _Nullable error) {
            NSLog(@"%@",error);
            TM_ShowToast(self.view, @"获取订单失败");
        }];
    }else {
        TM_ShowToast(self.view, @"请选择或输入充值金额");
    }

}


@end
