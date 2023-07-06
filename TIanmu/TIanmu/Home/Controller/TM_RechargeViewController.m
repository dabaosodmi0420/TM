//
//  TM_RechargeViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import "TM_RechargeViewController.h"
#import "JT_TopSegmentMenuView.h"

@interface TM_RechargeViewController (){
    UIButton *_selectedBtn;
}
#pragma mark - 余额充值
/* customMoneyTF */
@property (strong, nonatomic) UITextField *customMoneyTF;

#pragma mark - 流量充值
@property (nonatomic, strong) JT_TopSegmentMenuView *segmentMenuView;

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
    
    
    if (self.model.funcType == TM_ShortMenuTypeFlowRecharge) { // 流量充值
        [self flowRechargeView];
    }else if (self.model.funcType == TM_ShortMenuTypeBalanceRecharge) {// 余额充值
        [self balanceRechargeView];
    }
    
    // 登录
    UIButton *recharge = [UIView createButton:CGRectMake(0, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 44, kScreen_Width, 44)
                                   title:@"立即充值"
                              titleColoe:TM_ColorRGB(255, 255, 255)
                           selectedColor:TM_ColorRGB(255, 255, 255)
                                fontSize:16
                                     sel:@selector(rechargeClick)
                                    target:self];
    recharge.backgroundColor = TM_SpecialGlobalColor;
    [self.view addSubview:recharge];
}
- (void)flowRechargeView {
    _segmentMenuView = [[JT_TopSegmentMenuView alloc] initWithFrame:CGRectMake(0, 220, kScreen_Width, getAutoSize(60))];
    _segmentMenuView.backgroundColor = [UIColor whiteColor];
    _segmentMenuView.btnTitleNormalColor = [UIColor blackColor];
    _segmentMenuView.btnTitleSeletColor = TM_SpecialGlobalColor;
    _segmentMenuView.btnBackNormalColor = [UIColor clearColor];
    _segmentMenuView.btnBackSeletColor = [UIColor clearColor];
    _segmentMenuView.btnTextFont = [UIFont systemFontOfSize:15];
    _segmentMenuView.isAverageWidth = YES;
    _segmentMenuView.isCorner = NO;
    @weakify(self)
    _segmentMenuView.clickGroupBtnBlock = ^(NSString *btnName, NSInteger index) {
        @strongify(self)
        
    };
    [self.segmentMenuView makeSegmentUIWithSegDataArr:@[@"畅享版(单网)\n电信", @"优享版(双网)\n电信+移动", @"尊享版(三网)\n电信+移动+联通"] selectIndex:0 selectSegName:nil];
    [self.view addSubview:_segmentMenuView];
    
    UIButton *btn = [UIView createButton:CGRectMake(20, _segmentMenuView.maxY + 20, kScreen_Width - 40, 65) title:@"测试包\n售价：1.0元" titleColoe:TM_SpecialGlobalColor selectedColor:[UIColor whiteColor] fontSize:15 sel:@selector(changeRechargeMoney:) target:self];
    [btn setBackgroundImage:[UIImage tm_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage tm_imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage tm_imageWithColor:TM_SpecialGlobalColor] forState:UIControlStateSelected];
    btn.titleLabel.numberOfLines = 2;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = TM_SpecialGlobalColor.CGColor;
    
    [self.view addSubview:btn];
}
- (void)balanceRechargeView {
    // 流量卡卡号
    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(20, 240, 0, 25) title:@"流量卡卡号" fontSize:13 color:TM_ColorRGB(174, 174, 174)];
    [label1 sizeToFit];
    [self.view addSubview:label1];
    // 卡号
    UILabel *label2 = [UIView createLabelWithFrame:CGRectMake(label1.x, label1.maxY + 15, 0, 25) title:@"71256132" fontSize:16 color:[UIColor blackColor]];
    [label2 sizeToFit];
    [self.view addSubview:label2];
    
    UIView *lineL = [[UIView alloc]initWithFrame:CGRectMake(label2.x, label2.maxY + 8, kScreen_Width - 2 * label2.x, 0.5)];
    lineL.backgroundColor = TM_ColorRGB(174, 174, 174);
    [self.view addSubview:lineL];
    
    NSArray *rechargeArr = @[@"1", @"100", @"300", @"500", @"1000", @"自定义金额"];
    CGFloat gap = 12;
    NSUInteger lineNum = 3;
    CGFloat w = (kScreen_Width - (lineNum + 1) * gap) / lineNum;
    CGFloat h = w / 3.0;
    for (int i = 0; i < rechargeArr.count; i++) {
        CGFloat x = gap + i % lineNum * (w + gap);
        CGFloat y = gap + i / lineNum * (h + gap) + lineL.maxY + 10;
        if (i < rechargeArr.count - 1) {
            NSString *title = [NSString stringWithFormat:@"￥%0.2f", [rechargeArr[i] doubleValue]];
            UIButton *btn = [UIView createButton:CGRectMake(x, y, w, h) title:title titleColoe:TM_SpecialGlobalColor selectedColor:[UIColor whiteColor] fontSize:15 sel:@selector(changeRechargeMoney:) target:self];
            [btn setBackgroundImage:[UIImage tm_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage tm_imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage tm_imageWithColor:TM_SpecialGlobalColor] forState:UIControlStateSelected];
            
            btn.layer.cornerRadius = 5;
            btn.clipsToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = TM_SpecialGlobalColor.CGColor;
            
            [self.view addSubview:btn];
            if (i == 0) {
                [self changeRechargeMoney:btn];
            }
        }
        if (i == rechargeArr.count - 1) { // 自定义金额
            x = gap;
            y = ceil((CGFloat)i / lineNum) * (h + gap) + lineL.maxY + 10 + gap ;
            UITextField *customMoneyTF = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
            customMoneyTF.font = [UIFont systemFontOfSize:14];
            customMoneyTF.textColor = TM_SpecialGlobalColor;
            customMoneyTF.textAlignment = NSTextAlignmentCenter;
            customMoneyTF.keyboardType = UIKeyboardTypeNumberPad;
            customMoneyTF.placeholder = rechargeArr[i];
            [customMoneyTF addTarget:self action:@selector(customMoneyTFEdit:) forControlEvents:UIControlEventEditingChanged];

            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:rechargeArr[i] attributes:@{NSForegroundColorAttributeName:TM_ColorRGB(174, 174, 174),NSFontAttributeName:customMoneyTF.font}];
            customMoneyTF.attributedPlaceholder = attrString;
            customMoneyTF.layer.cornerRadius = 5;
            customMoneyTF.clipsToBounds = YES;
            customMoneyTF.layer.borderWidth = 1;
            customMoneyTF.layer.borderColor = TM_SpecialGlobalColor.CGColor;
            [self.view addSubview:customMoneyTF];
            self.customMoneyTF = customMoneyTF;
        }
    }
    
    
}

- (void)changeRechargeMoney:(UIButton *)btn {
    self.customMoneyTF.text = @"";
    [self.customMoneyTF resignFirstResponder];;
    if (_selectedBtn != btn) {
        _selectedBtn.selected = NO;
        _selectedBtn = btn;
        _selectedBtn.selected = YES;
    }
    
}

- (void)customMoneyTFEdit:(UITextField *)tf {
    if(tf.text.length > 0) {
        _selectedBtn.selected = NO;
        _selectedBtn = nil;
    }
}

- (void)rechargeClick {
    if (self.model.funcType == TM_ShortMenuTypeFlowRecharge) { // 流量充值
        NSLog(@"%@",@"流量充值");

    }else if (self.model.funcType == TM_ShortMenuTypeBalanceRecharge) {// 余额充值
        NSLog(@"%@",@"余额充值");
    
    }
}



@end
