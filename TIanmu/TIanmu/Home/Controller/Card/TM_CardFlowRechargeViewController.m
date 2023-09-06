//
//  TM_CardFlowRechargeViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import "TM_CardFlowRechargeViewController.h"
#import "TM_CardTopView.h"
#import "TM_DataCardApiManager.h"
#import "TM_PayViewController.h"
#import "JT_TopSegmentMenuView.h"
#import "TM_DataCardTaoCanModel.h"
#import "TM_DataCardApiManager.h"
#import "TM_DataCardUsedFlowModel.h"
#import "TM_NoticeView.h"
@interface TM_CardFlowRechargeViewController (){
    UIButton *_selectedBtn;
    NSInteger _curTaocanType;
    NSString *_noticeContent;
}

/* 顶部 */
@property (strong, nonatomic) TM_CardTopView *topView;

@property (nonatomic, strong) JT_TopSegmentMenuView     *segmentMenuView;
/* 充值包 */
@property (strong, nonatomic) UIScrollView              *taocanScrollerView;
/* 选择的套餐 */
@property (strong, nonatomic) UILabel                   *taocanTipL;
/* 套餐数据 */
@property (strong, nonatomic) NSArray                   *taocanDataArr;
/* 当前选择套餐 */
@property (strong, nonatomic) TM_DataCardTaoCanInfoModel *taocanModel;
/* 流量卡使用情况 */
@property (strong, nonatomic) TM_DataCardUsedFlowModel  *usedFlowModel;
/* 套餐整体数据 */
@property (strong, nonatomic) TM_DataCardTaoCanModel    *taocanData;

/*  */
@property (strong, nonatomic) TM_NoticeView *noticeView;

@end

@implementation TM_CardFlowRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView {
    self.title = @"流量充值";
    [JTDefinitionTextView jt_showWithTitle:@"" Text:@"订购套餐当月立即生效，请确认！！！" type:JTAlertTypeNot actionTextArr:@[@"确认"] handler:^(NSInteger index) {
    }];
    
    // 下方现在选择的套餐
    UILabel *taocanTipL = [UIView createLabelWithFrame:CGRectMake(0, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 44 - 30, kScreen_Width, 30) title:@"   请选择套餐" fontSize:15 color: [UIColor darkGrayColor]];
    taocanTipL.backgroundColor = TM_SpecialGlobalColorBg;
    [self.view addSubview:taocanTipL];
    self.taocanTipL = taocanTipL;
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
    
    self.contentScrollView.height = taocanTipL.y;
    [self.view addSubview:self.contentScrollView];
    
    self.topView = [[TM_CardTopView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 280) model:self.model];
    [self.contentScrollView addSubview:self.topView];
    
    _segmentMenuView = [[JT_TopSegmentMenuView alloc] initWithFrame:CGRectMake(0, _topView.maxY + 10, kScreen_Width, getAutoSize(40))];
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
//    NSMutableArray *taocanTypeArr = [NSMutableArray array];
//    if (self.model.monthCt != 0) {
//        [taocanTypeArr addObject:@"当月包"];
//    }
//    if (self.model.nextCt != 0) {
//        [taocanTypeArr addObject:@"次月包"];
//    }
//    if (self.model.ljCt != 0) {
//        [taocanTypeArr addObject:@"累计包"];
//    }
//    [self.segmentMenuView makeSegmentUIWithSegDataArr:taocanTypeArr selectIndex:0 selectSegName:nil];
    [self.contentScrollView addSubview:_segmentMenuView];
    
    
    
//    self.taocanScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.segmentMenuView.maxY, kScreen_Width, taocanTipL.y - self.segmentMenuView.maxY)];
//    self.taocanScrollerView.showsVerticalScrollIndicator = NO;
//    [self.view addSubview:self.taocanScrollerView];
}
// 刷新套餐选择选择数据
- (void)refreshTaocanUIData {
    NSLog(@"%@",@"刷新套餐");
    self.taocanDataArr = [NSArray arrayWithArray:self.taocanData.tcList];
    
    self.taocanTipL.text = @"   请选择套餐";
    self.taocanModel = nil;
    
    CGFloat contentSizeH = 0;
    [self.taocanScrollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.taocanDataArr.count; i++) {
        TM_DataCardTaoCanInfoModel *model = self.taocanDataArr[i];
        CGFloat padding = 15;
        CGFloat h = 65;
        CGFloat w = (kScreen_Width - 4 * padding) * 0.5;
        CGFloat margin_top = 10;
        CGFloat x = i % 2 == 0 ? padding : 3 * padding + w;
        CGFloat y = self.segmentMenuView.maxY + (i / 2 + 1) * margin_top + i / 2 * h;
        UIColor *btnBgColor = TM_ColorRGB(148, 216, 239);
        UIButton *btn = [UIView createButton:CGRectMake(x, y, w, h) title:@"" titleColoe:btnBgColor selectedColor:[UIColor whiteColor] fontSize:15 sel:@selector(changeTaocanRechargeMoney:) target:self];
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
    [TM_DataCardApiManager sendQueryNoticesWithCardNo:self.model.card_define_no type:@"flow" success:^(id  _Nullable respondObject) {
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
        [self requestTaocanType];
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"获取数据失败");
        [self requestTaocanType];
    }];
}
// 获取套餐类型
- (void)requestTaocanType {
    [TM_DataCardApiManager sendQueryTaoCanPackageTypeListWithCardNo:self.model.card_define_no success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            NSArray *data = respondObject[@"data"];
            if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
                self->_taocanDataArr = data;
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
    /** getUsedFlow
     private static final String MONTH = "month";当月
     private static final String NEXT = "next";次月
     private static final String ADD = "add";累计
     */
    NSDictionary *dic = _taocanDataArr[type];
    [TM_DataCardApiManager sendQueryTaoCanListWithCardNo:self.model.card_define_no type:dic[@"type"] success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            self.taocanData = [TM_DataCardTaoCanModel mj_objectWithKeyValues:respondObject[@"data"]];
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
- (void)rechargeClick {
   // 流量充值
    NSLog(@"%@",@"流量充值");
    if (self.taocanModel) {
        [JTDefinitionTextView jt_showWithTitle:@"提示" Text:@"请选择充值流量包支付方式" type:JTAlertTypeNot actionTextArr:@[@"余额支付", @"微信支付"] handler:^(NSInteger index) {
            if (index == 0) {
                if ([self.usedFlowModel.balance doubleValue] >= [self.taocanModel.package_price doubleValue]) {
                    [TM_DataCardApiManager sendOrderTcByBalanceWithOpenId:[TM_SettingManager shareInstance].sIdentifierId CardNo:self.model.card_define_no recharge_money:self.taocanModel.package_price type:@"month" package_id:self.taocanModel.package_id success:^(id  _Nullable respondObject) {
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
                [TM_DataCardApiManager sendOrderTcByWXWithPhoneNum:[TM_SettingManager shareInstance].sIdentifierId CardNo:self.model.card_define_no recharge_money:self.taocanModel.package_price type:type package_id:self.taocanModel.package_id success:^(id  _Nullable respondObject) {
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
@end
