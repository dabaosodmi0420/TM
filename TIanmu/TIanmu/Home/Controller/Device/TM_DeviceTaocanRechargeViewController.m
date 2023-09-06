//
//  TM_DeviceTaocanRechargeViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/9/1.
//

#import "TM_DeviceTaocanRechargeViewController.h"
#import "JT_TopSegmentMenuView.h"
#import "TM_DataCardApiManager.h"
#import "TM_DataCardUsedFlowModel.h"
#import "TM_WeixinTool.h"
#import "TM_DataCardTaoCanModel.h"
#import "TM_PayViewController.h"
#import "TM_NoticeView.h"
#define K_TmpStr  @"# #"

@interface TM_DeviceTaocanRechargeViewController (){
    UIButton *_selectedBtn;
    NSArray <UILabel *>*_topInfoLables;
    NSInteger _curTaocanType;
    
    NSString *_noticeContent;
    
    NSArray *_taocanTypeArr;
}
/* 流量卡使用情况 */
@property (strong, nonatomic) TM_DataCardUsedFlowModel  *usedFlowModel;

@property (strong, nonatomic) TM_NoticeView *noticeView;
#pragma mark - 流量充值
@property (nonatomic, strong) JT_TopSegmentMenuView     *segmentMenuView;
/* 充值包 */
@property (strong, nonatomic) UIScrollView              *taocanScrollerView;
/* 选择的套餐 */
@property (strong, nonatomic) UILabel                   *taocanTipL;
/* 套餐数据 */
@property (strong, nonatomic) NSArray                   *taocanDataArr;
/* 当前选择套餐 */
@property (strong, nonatomic) TM_DataCardTaoCanInfoModel *taocanModel;
@end

@implementation TM_DeviceTaocanRechargeViewController

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
    self.title = @"流量充值";
    self.contentScrollView.height = recharge.y - 30;
    [JTDefinitionTextView jt_showWithTitle:@"" Text:@"订购套餐当月立即生效，请确认！！！" type:JTAlertTypeNot actionTextArr:@[@"确认"] handler:^(NSInteger index) {
                
    }];
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

    [self flowRechargeView];
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
    
}

// MARK: 流量充值页面
- (void)flowRechargeView {
    _segmentMenuView = [[JT_TopSegmentMenuView alloc] initWithFrame:CGRectMake(0, 220, kScreen_Width, getAutoSize(60))];
    _segmentMenuView.backgroundColor = [UIColor whiteColor];
    _segmentMenuView.btnTitleNormalColor = [UIColor blackColor];
    _segmentMenuView.btnTitleSeletColor = TM_SpecialGlobalColor;
    _segmentMenuView.btnBackNormalColor = [UIColor clearColor];
    _segmentMenuView.btnBackSeletColor = [UIColor clearColor];
    _segmentMenuView.btnTextFont = [UIFont systemFontOfSize:14];
    _segmentMenuView.isAverageWidth = YES;
    _segmentMenuView.isCorner = NO;
    @weakify(self)
    _segmentMenuView.clickGroupBtnBlock = ^(NSString *btnName, NSInteger index) {
        @strongify(self)
        self->_curTaocanType = index;
        [self requestTaocanData:index];
    };
    [self.contentScrollView addSubview:_segmentMenuView];
    
    // 下方现在选择的套餐
    UILabel *taocanTipL = [UIView createLabelWithFrame:CGRectMake(0, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 44 - 30, kScreen_Width, 30) title:@"   请选择套餐" fontSize:15 color: [UIColor darkGrayColor]];
    taocanTipL.backgroundColor = TM_SpecialGlobalColorBg;
    [self.view addSubview:taocanTipL];
    self.taocanTipL = taocanTipL;
    
//    self.taocanScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.segmentMenuView.maxY, kScreen_Width, taocanTipL.y - self.segmentMenuView.maxY)];
//    self.taocanScrollerView.showsVerticalScrollIndicator = NO;
//    [self.contentScrollView addSubview:self.taocanScrollerView];
}
// 刷新套餐选择选择数据
- (void)refreshTaocanUIData {
    NSLog(@"%@",@"刷新套餐");
    self.taocanTipL.text = @"   请选择套餐";
    self.taocanModel = nil;
    
    CGFloat contentSizeH = 0;
    for (int i = 0; i < self.taocanDataArr.count; i++) {
        TM_DataCardTaoCanInfoModel *model = self.taocanDataArr[i];
        CGFloat h = 65;
        CGFloat margin_top = 10;
        UIColor *btnBgColor = TM_ColorRGB(148, 216, 239);
        UIButton *btn = [UIView createButton:CGRectMake(20, self.segmentMenuView.maxY + (i + 1) * margin_top + i * h, kScreen_Width - 40, h) title:@"" titleColoe:btnBgColor selectedColor:[UIColor whiteColor] fontSize:15 sel:@selector(changeTaocanRechargeMoney:) target:self];
        NSString *price = [NSString stringWithFormat:@"售价:￥%0.1f元", [model.package_price doubleValue]];
        NSString *str = [NSString stringWithFormat:@"%@\n%@", model.package_name, price];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
            NSFontAttributeName : self.taocanTipL.font
        }];
        [attribute addAttributes:@{
            NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange([str rangeOfString:price].location, price.length)];
        [attribute addAttributes:@{
            NSForegroundColorAttributeName : btnBgColor} range:NSMakeRange([str rangeOfString:model.package_name].location, model.package_name.length)];
        [btn setAttributedTitle:attribute forState:UIControlStateNormal];
        
        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
            NSFontAttributeName : self.taocanTipL.font
        }];
        [attribute1 addAttributes:@{
            NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange([str rangeOfString:price].location, price.length)];
        [attribute1 addAttributes:@{
            NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange([str rangeOfString:model.package_name].location, model.package_name.length)];
        [btn setAttributedTitle:attribute1 forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[UIImage tm_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage tm_imageWithColor:TM_SpecialGlobalColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage tm_imageWithColor:btnBgColor] forState:UIControlStateSelected];
        btn.titleLabel.numberOfLines = 2;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = btnBgColor.CGColor;
        btn.tag = 888 + i;
        [self.contentScrollView addSubview:btn];
        
        contentSizeH = btn.maxY;
    }
    [self.noticeView removeFromSuperview];
    self.noticeView = [[TM_NoticeView alloc] initWithFrame:CGRectMake(20, contentSizeH + 30, self.contentScrollView.width - 40, 0) content:_noticeContent];
    [self.contentScrollView addSubview:self.noticeView];
    contentSizeH = self.noticeView.maxY + 10;
    self.contentScrollView.contentSize = CGSizeMake(kScreen_Width, contentSizeH);
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
    
    [self requestTaocanType];
    
}
// 获取套餐类型
- (void)requestTaocanType {
    [TM_DataCardApiManager sendQueryTaoCanPackageTypeListWithCardNo:self.cardDetailInfoModel.card_define_no success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            NSArray *data = respondObject[@"data"];
            if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
                self->_taocanTypeArr = data;
                NSMutableArray *taocanTypeArr = [NSMutableArray array];
                for (NSDictionary *dic in data) {
                    NSString *typeCname = dic[@"typeCname"];
                    [taocanTypeArr addObject:typeCname];
                }
                
                if (taocanTypeArr.count > 0) {
                    [self.segmentMenuView makeSegmentUIWithSegDataArr:taocanTypeArr selectIndex:0 selectSegName:nil];
                    self->_curTaocanType = 0;
                    [self requestTaocanData:0];
                }
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
// 获取套餐数据
- (void)requestTaocanData:(NSInteger)type {
    NSDictionary *dic = _taocanTypeArr[type];
    [TM_DataCardApiManager sendQueryTaoCanPackagesListWithCardNo:self.cardDetailInfoModel.card_define_no type:dic[@"type"] success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            self.taocanDataArr = [TM_DataCardTaoCanInfoModel mj_objectArrayWithKeyValuesArray:respondObject[@"data"][@"package_list"]];
            [self refreshTaocanUIData];
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
// 流量套餐选择
- (void)changeTaocanRechargeMoney:(UIButton *)btn {
    if (_selectedBtn != btn) {
        _selectedBtn.selected = NO;
        _selectedBtn = btn;
        _selectedBtn.selected = YES;
    }
    NSInteger index = _selectedBtn.tag - 888;
    if (index < self.taocanDataArr.count) {
        self.taocanModel = self.taocanDataArr[index];
        NSString *price = [NSString stringWithFormat:@"￥%0.2f", [self.taocanModel.package_price doubleValue]];
        NSString *str = [NSString stringWithFormat:@"   已选择套餐：%@ %@", self.taocanModel.package_name, price];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
            NSFontAttributeName : self.taocanTipL.font
        }];
        [attribute addAttributes:@{
            NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange([str rangeOfString:price].location, price.length)];
        self.taocanTipL.attributedText = attribute;
    }
    
}
- (void)rechargeClick { // 流量充值
    NSLog(@"%@",@"流量充值");
    if (self.taocanModel) {
        [JTDefinitionTextView jt_showWithTitle:@"提示" Text:@"请选择充值流量包支付方式" type:JTAlertTypeNot actionTextArr:@[@"余额支付", @"微信支付"] handler:^(NSInteger index) {
            if (index == 0) {
                if ([self.usedFlowModel.balance doubleValue] >= [self.taocanModel.package_price doubleValue]) {
                    [TM_DataCardApiManager sendOrderTcByBalanceWithOpenId:[TM_SettingManager shareInstance].sIdentifierId CardNo:self.cardDetailInfoModel.card_define_no recharge_money:self.taocanModel.package_price type:@"month" package_id:self.taocanModel.package_id success:^(id  _Nullable respondObject) {
                        NSLog(@"%@",respondObject);
                        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                            TM_PayViewController *payVC = [TM_PayViewController new];
                            payVC.wxPayData = respondObject;
                            payVC.money = self.taocanModel.package_price;
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
                    [JTDefinitionTextView jt_showWithTitle:@"注意" Text:@"当前余额不足，请先充值余额或使用微信支付！" type:0 actionTextArr:@[@"确定"] handler:nil];
                }
            }else {
                // 微信支付
                NSString *type = @"month";
                [TM_DataCardApiManager sendOrderTcByWXWithPhoneNum:[TM_SettingManager shareInstance].sIdentifierId CardNo:self.cardDetailInfoModel.card_define_no recharge_money:self.taocanModel.package_price type:type package_id:self.taocanModel.package_id success:^(id  _Nullable respondObject) {
                    NSLog(@"%@",respondObject);
                    if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                        TM_PayViewController *payVC = [TM_PayViewController new];
                        payVC.wxPayData = respondObject;
                        payVC.money = self.taocanModel.package_price;
                        [self.navigationController pushViewController:payVC animated:YES];
                    }else {
                        NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
                        TM_ShowToast(self.view, msg);
                    }
                } failure:^(NSError * _Nullable error) {
                    NSLog(@"%@",error);
                    TM_ShowToast(self.view, @"获取订单失败");
                }];
            }
        }];
        
    }else {
        TM_ShowToast(self.view, @"请选择套餐");
    }
    
    
}


@end
