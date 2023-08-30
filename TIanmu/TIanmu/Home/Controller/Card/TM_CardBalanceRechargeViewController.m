//
//  TM_CardBalanceRechargeViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import "TM_CardBalanceRechargeViewController.h"
#import "TM_CardTopView.h"
#import "TM_DataCardApiManager.h"
#import "TM_PayViewController.h"
#import "TM_NoticeView.h"
@interface TM_CardBalanceRechargeViewController (){
    UIButton *_selectedBtn;
    NSString *_noticeContent;
}
/* 顶部 */
@property (strong, nonatomic) TM_CardTopView *topView;

/* customMoneyTF */
@property (strong, nonatomic) UITextField               *customMoneyTF;
/* 流量卡卡号 */
@property (strong, nonatomic) UILabel                   *balanceCardNumL;
/* 余额充值数组 */
@property (strong, nonatomic) NSArray                   *balanceRechargeArr;
/* 当前选中充值金额 */
@property (copy, nonatomic) NSString                    *balanceRecharge;

@property (strong, nonatomic) TM_NoticeView *noticeView;

@end

@implementation TM_CardBalanceRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)createView {
    self.title = @"余额充值";
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

    self.contentScrollView.height = recharge.y;
    [self.view addSubview:self.contentScrollView];
    
    self.topView = [[TM_CardTopView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 280) model:self.model];
    [self.contentScrollView addSubview:self.topView];
    
    // 流量卡卡号
    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(20, _topView.maxY + 10, 0, 25) title:@"流量卡卡号" fontSize:13 color:TM_ColorRGB(174, 174, 174)];
    [label1 sizeToFit];
    [self.contentScrollView addSubview:label1];
    // 卡号
    UILabel *label2 = [UIView createLabelWithFrame:CGRectMake(label1.x, label1.maxY + 15, 0, 25) title:@"" fontSize:16 color:[UIColor blackColor]];
    self.balanceCardNumL = label2;
    self.balanceCardNumL.text = [NSString stringWithFormat:@"%@",self.model.iccid];
    [self.balanceCardNumL sizeToFit];
    [self.contentScrollView addSubview:label2];
    
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
    [TM_DataCardApiManager sendQueryNoticesWithCardNo:self.model.card_define_no type:@"balance" success:^(id  _Nullable respondObject) {
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
- (void)requestData {
    // 获取充值金额列表数据
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
    self.customMoneyTF.text = @"";
    [self.customMoneyTF resignFirstResponder];
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
        [TM_DataCardApiManager sendGetWechatRechargePreWithPhoneNum:[TM_SettingManager shareInstance].sIdentifierId CardNo:self.model.card_define_no recharge_money:self.balanceRecharge success:^(id  _Nullable respondObject) {
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
