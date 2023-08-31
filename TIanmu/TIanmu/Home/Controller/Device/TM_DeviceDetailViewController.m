//
//  TM_DeviceDetailViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "TM_DeviceDetailViewController.h"
#import "TM_HomeShortcutMenuView.h"
#import "TM_ShortMenuModel.h"
#import "TM_ConfigTool.h"
#import "TM_DataCardApiManager.h"
#import "JTNetworkSignalView.h"
#import "TM_DataCardManagerViewController.h"
#import "TM_RechargeViewController.h"
#import "TM_BuyHistoryViewController.h"
#import "TM_RealNameAuthViewController.h"
#import "TM_ChangeNetViewController.h"
#import "TM_DeivceActivityViewController.h"

@interface TM_DeviceDetailViewController ()<TM_HomeShortcutMenuViewDelegate, UITextFieldDelegate>{
    NSMutableArray <UILabel *>*_topInfoLables;
    NSArray <UILabel *>*_wifiInfoLabels;
    JTNetworkSignalView *_netSigV;
    NSString *_wifiPw;
}
/* 顶部View */
@property (strong, nonatomic) UIView *topView;

/* 用户码 */
@property (strong, nonatomic) UILabel *codeL;
/* 在线状态 */
@property (strong, nonatomic) UILabel *signalView;
/* 余额 */
@property (strong, nonatomic) UILabel *balanceView;
/* 未生效套餐 */
@property (strong, nonatomic) UILabel *nextPackageL;
/* wifi View */
@property (strong, nonatomic) UIView  *wifiContentView;

/* wifi password */
@property (strong, nonatomic) UITextField *wifiPWTF;

/* 按钮菜单 */
@property (strong, nonatomic) TM_HomeShortcutMenuView   *shortcutMenuView;
/* 设备索引信息 */
@property (strong, nonatomic) TM_DeviceIndexInfo *deviceIndexInfoModel;

@end

@implementation TM_DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TM_SpecialGlobalColorBg;
    // Do any additional setup after loading the view.
    
    [self loadDatas];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
#pragma mark - 创建UI
- (void)createView {
    [super createView];
    self.title = @"设备";
    [self.view addSubview:self.contentScrollView];
    [self createDeviceInfoUI];
    //新增了一个参数"need_active": "0", //0不需要跳转激活页面，1需要进激活页面
    if ([self.deviceIndexInfoModel.need_active intValue] == 1) {
        TM_DeivceActivityViewController *activity = [TM_DeivceActivityViewController new];
        activity.cardInfoModel = self.cardInfoModel;
        [self.navigationController pushViewController:activity animated:YES];
    }
}
- (void)createDeviceInfoUI {
    /** 顶部View */
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 320)];
    [self.contentScrollView addSubview:topView];
    [UIView setVerGradualChangingColor:topView colorArr:@[TM_SpecialGlobalColor, TM_ColorRGB(59, 85, 183)]];
    self.topView = topView;
    // 更换设备按钮
    UIButton *deviceChange = [UIView createButton:CGRectMake(kScreen_Width - 70, 10, 70, 32) title:@"设备切换" titleColoe:TM_ColorRGB(108, 115, 158) selectedColor:TM_ColorRGB(108, 115, 158) fontSize:14 sel:@selector(deviceChange) target:self];
    deviceChange.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:deviceChange.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(deviceChange.height * 0.5,deviceChange.height * 0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = deviceChange.bounds;
    maskLayer.path = maskPath.CGPath;
    deviceChange.layer.mask = maskLayer;
    [topView addSubview:deviceChange];
    // 设备号
    UILabel *userCode = [UIView createLabelWithFrame:CGRectMake(0, 40, kScreen_Width, 25) title:@"设备号" fontSize:15 color:[UIColor whiteColor]];
    userCode.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:userCode];
    UILabel *code = [UIView createLabelWithFrame:CGRectMake(0, userCode.maxY, kScreen_Width, 25) title:@"" fontSize:20 color:[UIColor whiteColor]];
    code.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:code];
    self.codeL = code;
    // 在线状态
    CGFloat margin = 40;
    CGFloat width = (kScreen_Width - 3 * margin) / 2.0;
    UILabel *signalView = [[UILabel alloc] initWithFrame:CGRectMake(margin, code.maxY + 10, width, 35)];
    signalView.font = [UIFont systemFontOfSize:17];
    signalView.textColor = TM_ColorRGB(102, 113, 159);
    signalView.backgroundColor = [UIColor whiteColor];
    signalView.textAlignment = NSTextAlignmentCenter;
    signalView.layer.cornerRadius = signalView.height * 0.5;
    signalView.clipsToBounds = YES;
    [topView addSubview:signalView];
    self.signalView = signalView;
    // 余额
    UILabel *balanceView = [[UILabel alloc] initWithFrame:CGRectMake(margin + signalView.maxX, code.maxY + 10, width, 35)];
    balanceView.font = [UIFont systemFontOfSize:17];
    balanceView.textColor = TM_ColorRGB(102, 113, 159);
    balanceView.backgroundColor = [UIColor whiteColor];
    balanceView.textAlignment = NSTextAlignmentCenter;
    balanceView.layer.cornerRadius = signalView.height * 0.5;
    balanceView.clipsToBounds = YES;
    [topView addSubview:balanceView];
    self.balanceView = balanceView;
    // 几个显示信息
    NSArray *titles = @[@"套餐:",@"已用流量:",@"套餐有效期:",@"剩余流量:",@"套餐已用:",@"到期时间:"];
    _topInfoLables = [NSMutableArray arrayWithCapacity:titles.count];
    CGFloat y = signalView.maxY + 25;
    CGFloat padding = 20;
    CGFloat h = 20;
    for (NSUInteger i = 0; i < titles.count; i++) {
        CGFloat w = (topView.width - padding * 3) * 0.5;
        CGFloat x = i % 2 == 0 ? padding : 2 * padding + w;
        
        // 几排
        NSUInteger index = (NSUInteger)(i / 2);
                 
        if ( i % 2 == 0 && index != 0) {
            y += (h + 10 + 10);
        }
        
        UILabel *label = [UIView createLabelWithFrame:CGRectMake(x, y, 0, h) title:titles[i] fontSize:16 color:[UIColor whiteColor]];
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
        [topView addSubview:label];
        
        UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(label.maxX + 2, y, w - label.width, h) title:@"" fontSize:18 color:[UIColor whiteColor]];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.adjustsFontSizeToFitWidth = YES;
        [topView addSubview:label1];
        
        [_topInfoLables addObject:label1];
    }
    UILabel *nextPackageL = [UIView createLabelWithFrame:CGRectMake(20, y + h + 10, kScreen_Width - 40, 35) title:@"" fontSize:18 color:[UIColor whiteColor]];
    nextPackageL.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:nextPackageL];
    self.nextPackageL = nextPackageL;
    
    /** wifi 信息 */
    UIView *wifiContentView = [[UIView alloc] initWithFrame:CGRectMake(10, topView.maxY + 10, kScreen_Width - 20, 160)];
    [wifiContentView setCornerRadius:10];
    wifiContentView.hidden = YES;
    wifiContentView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:wifiContentView];
    self.wifiContentView = wifiContentView;
    // 图标
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, wifiContentView.height - 40, wifiContentView.height - 40)];
    logoImg.image = [UIImage imageNamed:@"wifiSafe"];
    [logoImg setCornerRadius:10];
    logoImg.contentMode = UIViewContentModeScaleToFill;
    [wifiContentView addSubview:logoImg];
    // 内容
    UILabel *wifiTitleL = [UIView createLabelWithFrame:CGRectMake(logoImg.maxX + 25, 10, wifiContentView.width - 70 - logoImg.maxX, 30) title:@"WIFI管理" fontSize:18 color:TM_ColorRGB(93, 93, 93)];
    wifiTitleL.textAlignment = NSTextAlignmentCenter;
    [wifiContentView addSubview:wifiTitleL];
    // wifi名称
    UILabel *wifiNameL = [UIView createLabelWithFrame:CGRectMake(logoImg.maxX + 25, wifiTitleL.maxY + 3, wifiContentView.width - 70 - logoImg.maxX, 25) title:@"" fontSize:16 color:TM_ColorRGB(115, 115, 115)];
    wifiNameL.textAlignment = NSTextAlignmentLeft;
    [wifiContentView addSubview:wifiNameL];
    // wifi密码
    UILabel *wifiPWL = [UIView createLabelWithFrame:CGRectMake(logoImg.maxX + 25, wifiNameL.maxY + 3, wifiContentView.width - 70 - logoImg.maxX, 25) title:@"" fontSize:16 color:TM_ColorRGB(115, 115, 115)];
    wifiPWL.textAlignment = NSTextAlignmentLeft;
    [wifiContentView addSubview:wifiPWL];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(wifiPWL.x + 70, wifiPWL.y, wifiPWL.width - 70, wifiPWL.height)];
    tf.font = [UIFont systemFontOfSize:16];
    tf.textColor = TM_ColorRGB(115, 115, 115);
    tf.delegate = self;
    [wifiContentView addSubview:tf];
    self.wifiPWTF = tf;
    // wifi连接人数
    UILabel *wifiNumL = [UIView createLabelWithFrame:CGRectMake(logoImg.maxX + 25, wifiPWL.maxY + 3, wifiContentView.width - 70 - logoImg.maxX, 25) title:@"" fontSize:16 color:TM_ColorRGB(115, 115, 115)];
    wifiNumL.textAlignment = NSTextAlignmentLeft;
    [wifiContentView addSubview:wifiNumL];
    _wifiInfoLabels = @[wifiNameL, wifiPWL, wifiNumL];
    
    UIButton *saveWifiPW = [UIView createButton:CGRectMake(0, wifiNumL.maxY + 6, 80, 25)
                                            title:@"保存修改"
                                       titleColoe:[UIColor whiteColor]
                                    selectedColor:[UIColor whiteColor]
                                         fontSize:15
                                        sel:@selector(savePassword:)
                                       target:self];
    saveWifiPW.centerX = wifiTitleL.centerX;
    saveWifiPW.backgroundColor = TM_SpecialGlobalColor;
    [saveWifiPW setCornerRadius:saveWifiPW.height * 0.5];
    [wifiContentView addSubview:saveWifiPW];
    
    /** 下面菜单 */
    [self.contentScrollView addSubview:self.shortcutMenuView];
}
#pragma mark - 获取数据
- (void)loadDatas {
    [TM_DataCardApiManager sendQueryDeviceIndexInfoWithCardNo:self.cardInfoModel.iccid success:^(TM_DeviceIndexInfo * _Nonnull model) {
        if (model) {
            self.deviceIndexInfoModel = model;
            [self refreshTopInfo];
            [self refreshContentView];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)refreshTopInfo {
    
    self.codeL.text = self.model.iccid;
    self.signalView.text = [NSString stringWithFormat:@"状态:%@", self.deviceIndexInfoModel.wifiInfo.deviceStatus == 0 ? @"设备离线" : @"设备在线"];
    self.balanceView.text = [NSString stringWithFormat:@"余额:%.1f", self.deviceIndexInfoModel.balance];
    self.nextPackageL.text = [NSString stringWithFormat:@"未生效套餐:%@", self.deviceIndexInfoModel.packageDaysInfo.nextPackageName ?: @"无"];
    NSArray *datas = @[self.deviceIndexInfoModel.packageDaysInfo.nowPackageName ?: @"",
                       self.deviceIndexInfoModel.flowInfo.used ? [NSString stringWithFormat:@"%@天", self.deviceIndexInfoModel.flowInfo.used] : @"0.0GB",
                       self.deviceIndexInfoModel.packageDaysInfo.totalDays ? [NSString stringWithFormat:@"%@天", self.deviceIndexInfoModel.packageDaysInfo.totalDays] : @"0天",
                       self.deviceIndexInfoModel.flowInfo.remain ? [NSString stringWithFormat:@"%@GB", self.deviceIndexInfoModel.flowInfo.remain] : @"0.0GB",
                       self.deviceIndexInfoModel.packageDaysInfo.useDays ? [NSString stringWithFormat:@"%@天", self.deviceIndexInfoModel.packageDaysInfo.useDays] : @"0天",
                       self.deviceIndexInfoModel.packageDaysInfo.nowEndTime ?: @"--年--月--日"
    ];
    for (int i = 0; i < datas.count; i++) {
        UILabel *l = _topInfoLables[i];
        l.text = [NSString stringWithFormat:@"%@",datas[i]];
        [l sizeToFit];
    }
}
- (void)refreshContentView {
    
    if ([self.deviceIndexInfoModel.show_wifi intValue] == 1) {
        self.wifiContentView.hidden = NO;
        self.shortcutMenuView.y = self.wifiContentView.maxY + 10;
        _wifiInfoLabels[0].text = [NSString stringWithFormat:@"WIFI名称:%@", self.deviceIndexInfoModel.wifiInfo.ssid ?: @"--"];
        _wifiInfoLabels[1].text = [NSString stringWithFormat:@"WIFI密码:%@", self.deviceIndexInfoModel.wifiInfo.key ?: @"--"];
        _wifiInfoLabels[2].text = [NSString stringWithFormat:@"WIFI连接:%d人", self.deviceIndexInfoModel.wifiInfo.conn_cnt];

    }else {
        self.wifiContentView.hidden = YES;
        self.shortcutMenuView.y = self.topView.maxY + 10;
    }
    
    if (self.deviceIndexInfoModel.cardTypeInfo.webConn.length > 0) {
        _shortcutMenuView.hidden = NO;
        NSArray *menuNames = [[self.deviceIndexInfoModel.cardTypeInfo.webConn substringToIndex:self.deviceIndexInfoModel.cardTypeInfo.webConn.length -1] componentsSeparatedByString:@";"];
        [self updataShortMenus:menuNames];
    }
    
    self.contentScrollView.contentSize = CGSizeMake(kScreen_Width, self.shortcutMenuView.maxY + 20);
}
- (void)updataShortMenus:(NSArray *)curMenuNames {
    
    NSMutableArray *needMenus = [NSMutableArray array];
    CGFloat height = self.shortcutMenuView.height / 2.0 * ceil( curMenuNames.count / [@(self.shortcutMenuView.nEachLineNum) doubleValue]);
    self.shortcutMenuView.height = height;
    NSArray *allMenus = [TM_ShortMenuModel mj_objectArrayWithKeyValuesArray:[TM_ConfigTool getDeviceShortMenuListDatas]];
    for (NSString *name in curMenuNames) {
        for (TM_ShortMenuModel *model in allMenus) {
            if ([model.funcCode isEqualToString:name]) {
                [needMenus addObject:model];
            }
        }
    }
    self.shortcutMenuView.dataArray = needMenus;
}
#pragma mark - Activity
- (void)leftNavItemClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)deviceChange {
    NSLog(@"%@",@"设备切换");
    TM_DataCardManagerViewController *vc = [[TM_DataCardManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)savePassword:(UIButton *)btn {
    if (_wifiPw.length == 0) {
        TM_ShowToast(self.view, @"请输入密码");
        return;
    }
    [TM_DataCardApiManager sendSaveWifiPasswordlWithCardNo:self.cardInfoModel.card_define_no wifiName:self.deviceIndexInfoModel.wifiInfo.ssid wifiPW:_wifiPw success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            TM_ShowToast(self.view, @"修改成功");
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"修改失败");
    }];
}
- (void)wifiPasswordTextFieldEdit:(UITextField*)textfield {
    NSString * tempStr = textfield.text;
    if (tempStr.length >= 0){
        
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _wifiInfoLabels[1].text = @"WIFI密码:";
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _wifiPw = textField.text;
    if (textField.text.length > 0) {
        _wifiInfoLabels[1].text = [NSString stringWithFormat:@"WIFI密码:%@", textField.text];
    }else {
        _wifiInfoLabels[1].text = [NSString stringWithFormat:@"WIFI密码:%@", self.deviceIndexInfoModel.wifiInfo.key ?: @"--"];
    }
    
    textField.text = @"";
}
#pragma mark - TM_HomeShortcutMenuViewDelegate
- (void)clickHomeShortcutMenuWithModel:(TM_ShortMenuModel *)model {
    switch (model.funcType) {
        case TM_ShortMenuTypeBalanceRecharge:
        case TM_ShortMenuTypeFlowRecharge: {
            TM_RechargeViewController *vc = [TM_RechargeViewController new];
            vc.menuModel = model;
            vc.cardDetailInfoModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeRealNameAuth: {
            TM_RealNameAuthViewController *vc = [TM_RealNameAuthViewController new];
            vc.cardDetailInfoModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeTransactionRecord: {
            TM_BuyHistoryViewController *vc = [TM_BuyHistoryViewController new];
            vc.cardDetailInfoModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeNetChange: {
            TM_ChangeNetViewController *vc = [TM_ChangeNetViewController new];
            vc.cardDetailInfoModel = self.model;
            vc.deviceIndexInfoModel = self.deviceIndexInfoModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeService: {
            [[TM_WeixinTool shareWeixinToolManager] tm_weixinToolWithType:TM_WeixinToolTypeWXServiceChat data:@{} completeBlock:^(TM_WeixinToolType type, NSDictionary * _Nonnull param) {
                            
            }];
        }
            break;
        case TM_ShortMenuTypeRemoteControl: {
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - 懒加载
- (TM_HomeShortcutMenuView *)shortcutMenuView{
    if(!_shortcutMenuView) {
        _shortcutMenuView = [[TM_HomeShortcutMenuView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, 200)];
        _shortcutMenuView.hidden = YES;
        _shortcutMenuView.delegate = self;
        _shortcutMenuView.backgroundColor = [UIColor whiteColor];
        _shortcutMenuView.layer.cornerRadius = 10;
        _shortcutMenuView.nEachLineNum = 3;
        _shortcutMenuView.clipsToBounds = YES;
    }
    return _shortcutMenuView;
}
@end
