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
#import "TM_DataCardDetalInfoModel.h"
#import "JTNetworkSignalView.h"
#import "TM_DataCardManagerViewController.h"
#import "TM_RechargeViewController.h"

@interface TM_DeviceDetailViewController ()<TM_HomeShortcutMenuViewDelegate>{
    NSMutableArray <UILabel *>*_topInfoLables;
    
    JTNetworkSignalView *_netSigV;
}

/* model */
@property (strong, nonatomic) TM_DataCardDetalInfoModel *model;

/* 用户码 */
@property (strong, nonatomic) UILabel *codeL;


/* 按钮菜单 */
@property (strong, nonatomic) TM_HomeShortcutMenuView   *shortcutMenuView;
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
    [self createNav];
}
#pragma mark - 创建UI
- (void)createNav {
    self.title = @"设备";
//    self.navigationController.navigationBar.translucent = YES;
//    self.extendedLayoutIncludesOpaqueBars = YES;
    
    // 返回按钮
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 20, 20);
    [returnBtn setImage:[UIImage imageNamed:@"back_white_icon"] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"back_white_icon"] forState:UIControlStateHighlighted];
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 10);
    [returnBtn addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnBtnItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItems = @[ returnBtnItem];
    
}
- (void)createView {
    [super createView];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 320)];
    [self.view addSubview:topView];
    [UIView setVerGradualChangingColor:topView colorArr:@[TM_SpecialGlobalColor, TM_ColorRGB(59, 85, 183)]];
    
    UIButton *deviceChange = [UIView createButton:CGRectMake(kScreen_Width - 60, 10, 60, 25) title:@"设备切换" titleColoe:TM_ColorRGB(108, 115, 158) selectedColor:TM_ColorRGB(108, 115, 158) fontSize:12 sel:@selector(deviceChange) target:self];
    deviceChange.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:deviceChange.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(deviceChange.height * 0.5,deviceChange.height * 0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = deviceChange.bounds;
    maskLayer.path = maskPath.CGPath;
    deviceChange.layer.mask = maskLayer;
    [topView addSubview:deviceChange];
    
    UILabel *userCode = [UIView createLabelWithFrame:CGRectMake(0, 40, kScreen_Width, 25) title:@"用户码" fontSize:14 color:[UIColor whiteColor]];
    userCode.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:userCode];
    UILabel *code = [UIView createLabelWithFrame:CGRectMake(0, userCode.maxY, kScreen_Width, 25) title:@"" fontSize:20 color:[UIColor whiteColor]];
    code.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:code];
    self.codeL = code;
    
    UIView *signalView = [[UIView alloc] initWithFrame:CGRectMake(0, code.maxY + 10, 160, 30)];
    signalView.centerX = topView.width * 0.5;
    signalView.layer.cornerRadius = signalView.height * 0.5;
    signalView.clipsToBounds = YES;
    signalView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:signalView];
    
    _netSigV = [[JTNetworkSignalView alloc] initWithPosition:CGPointMake(10, (signalView.height - 16) * 0.5) showPopView:NO vc:self block:^{
       
    }];
    [_netSigV jt_reload:0 :@""];
    [signalView addSubview:_netSigV];
    
    UILabel *signalLabel = [UIView createLabelWithFrame:CGRectMake(_netSigV.maxX + 10, 0, signalView.width - (_netSigV.maxX + 10), signalView.height) title:@"设备状态：在线" fontSize:15 color:TM_ColorRGB(108, 115, 158)];
    [signalView addSubview:signalLabel];
    
    
    NSArray *titles = @[@"本月总流量",@"套餐总天数",@"本月已用流量",@"已用天数",@"本月剩余流量",@"剩余天数"];
    _topInfoLables = [NSMutableArray arrayWithCapacity:titles.count];
    CGFloat y = signalView.maxY + 20;
    for (NSUInteger i = 0; i < titles.count; i++) {
        CGFloat centerX = topView.width / 3 * (i % 2 == 0 ? 1 : 2);
        CGFloat w = topView.width * 0.5;
        CGFloat h = 20;
        CGFloat x = i % 2 == 0 ? 0 : w;
        
        // 几排
        NSUInteger index = (NSUInteger)(i / 2);
                 
        if ( i % 2 == 0 && index != 0) {
            y += (2 * h + 10 + 10);
        }
        
        UILabel *label = [UIView createLabelWithFrame:CGRectMake(x, y, w, h) title:titles[i] fontSize:13 color:[UIColor whiteColor]];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [topView addSubview:label];
        
        UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(x, label.maxY + 5, w, h) title:@"" fontSize:18 color:[UIColor whiteColor]];
        label1.textAlignment = NSTextAlignmentCenter;
        [label1 sizeToFit];
        [topView addSubview:label1];
        
        label.centerX = centerX;
        label1.centerX = centerX;
        
        [_topInfoLables addObject:label1];
    }
    
    
    self.shortcutMenuView.y = topView.maxY + 10;
    [self.view addSubview:self.shortcutMenuView];
}

#pragma mark - 获取数据
- (void)loadDatas {
    [TM_DataCardApiManager sendQueryUserAllCardWithCardNo:self.cardInfoModel.iccid success:^(id  _Nullable respondObject) {
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
}
- (void)refreshUIData:(NSDictionary *)data {
    self.model = [TM_DataCardDetalInfoModel mj_objectWithKeyValues:data];
    [self refreshTopInfo];
    [self refreshShortMenuView];
}
- (void)refreshTopInfo {
    
    self.codeL.text = self.model.iccid;
    
    NSArray *datas = @[self.model.totalFlow ?: @"0.0GB",
                       self.model.device_info.totalDays ?: @"0天",
                       self.model.usedFlow ?: @"0.0GB",
                       self.model.device_info.useDays ?: @"0天",
                       self.model.leftFlow ?: @"0.0GB",
                       self.model.device_info.leftDays ?: @"0天"
    ];
    for (int i = 0; i < datas.count; i++) {
        UILabel *l = _topInfoLables[i];
        CGFloat centerX = l.centerX;
        l.text = [NSString stringWithFormat:@"%@",datas[i]];
        [l sizeToFit];
        l.centerX = centerX;
    }
}
- (void)refreshShortMenuView {
    NSArray *menuNames = @[];
    if([[NSString stringWithFormat:@"%@",self.model.card_or_device] isEqualToString:@"0"]) { // 卡
        if ([self.model.card_type isEqualToString:@""]){
            
        }
    }else if ([[NSString stringWithFormat:@"%@",self.model.card_or_device] isEqualToString:@"1"]) { // 设备
        if ([self.model.card_type isEqualToString:@"device_tmfsk"]){
            menuNames = @[@"流量充值",@"余额充值",@"实名认证",@"交易记录",@"网络切换"];
        }
    }
    
    [self updataShortMenus:menuNames];
}
- (void)updataShortMenus:(NSArray *)curMenuNames {
    
    NSMutableArray *needMenus = [NSMutableArray array];
    
    NSArray *allMenus = [TM_ShortMenuModel mj_objectArrayWithKeyValuesArray:[TM_ConfigTool getShortMenuListDatas]];
    for (NSString *name in curMenuNames) {
        for (TM_ShortMenuModel *model in allMenus) {
            if ([model.menuname isEqualToString:name]) {
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
            
        }
            break;
        case TM_ShortMenuTypeTransactionRecord: {
            
        }
            break;
        case TM_ShortMenuTypeNetChange: {
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - 懒加载
- (TM_HomeShortcutMenuView *)shortcutMenuView{
    if(!_shortcutMenuView) {
        _shortcutMenuView = [[TM_HomeShortcutMenuView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, kScreen_Width / 862 * 333)];
        _shortcutMenuView.delegate = self;
        _shortcutMenuView.backgroundColor = [UIColor whiteColor];
        _shortcutMenuView.layer.cornerRadius = 10;
        _shortcutMenuView.nEachLineNum = 3;
        _shortcutMenuView.clipsToBounds = YES;
    }
    return _shortcutMenuView;
}
@end
