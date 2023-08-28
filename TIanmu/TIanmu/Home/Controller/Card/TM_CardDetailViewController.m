//
//  TM_CardDetailViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/11.
//

#import "TM_CardDetailViewController.h"
#import "TM_CardTopView.h"
#import "TM_ShortMenuModel.h"
#import "TM_HomeShortcutMenuView.h"
#import "TM_ConfigTool.h"
#import "TM_DataCardApiManager.h"
#import "TM_DataCardManagerViewController.h"
#import "TM_BuyHistoryViewController.h"
@interface TM_CardDetailViewController ()<TM_HomeShortcutMenuViewDelegate>
/* 顶部 */
@property (strong, nonatomic) TM_CardTopView *topView;
/* 按钮菜单 */
@property (strong, nonatomic) TM_HomeShortcutMenuView   *shortcutMenuView;
/* 设备索引信息 */
@property (strong, nonatomic) TM_DeviceIndexInfo *deviceIndexInfoModel;
@end

@implementation TM_CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView {
    self.title = @"流量卡";
    self.topView = [[TM_CardTopView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 280) model:self.model];
    [self.view addSubview:self.topView];
    
    CGFloat w = 100;
    UIImageView *changeImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - w - 12, 70, w, w * 0.36)];
    changeImg.userInteractionEnabled = YES;
    changeImg.image = [UIImage imageNamed:@"card_changeCardBg"];
    changeImg.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:changeImg];

    UIButton *deviceChange = [UIView createButton:changeImg.bounds title:@"设备切换" titleColoe:TM_ColorRGB(192, 144, 0) selectedColor:TM_ColorRGB(108, 115, 158) fontSize:15 sel:@selector(deviceChange) target:self];
    deviceChange.backgroundColor = [UIColor clearColor];
    [changeImg addSubview:deviceChange];
    
    
    self.shortcutMenuView.y = _topView.maxY;
    [self.view addSubview:self.shortcutMenuView];
    NSArray *needMenus = [TM_ShortMenuModel mj_objectArrayWithKeyValuesArray:[TM_ConfigTool getCardShortMenuListDatas]];
    self.shortcutMenuView.nEachLineNum = 3;
    self.shortcutMenuView.nLineNum = 3;
    self.shortcutMenuView.dataArray = needMenus;
}

- (void)updataShortMenus:(NSArray *)curMenuNames {
        
    
}
#pragma mark - Activity
- (void)deviceChange {
    NSLog(@"%@",@"设备切换");
    TM_DataCardManagerViewController *vc = [[TM_DataCardManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取数据
- (void)reloadData {
    
}
#pragma mark - TM_HomeShortcutMenuViewDelegate
- (void)clickHomeShortcutMenuWithModel:(TM_ShortMenuModel *)model {
    switch (model.funcType) {
        case TM_ShortMenuTypeBalanceRecharge:
        case TM_ShortMenuTypeFlowRecharge: {
//            TM_RechargeViewController *vc = [TM_RechargeViewController new];
//            vc.menuModel = model;
//            vc.cardDetailInfoModel = self.model;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeRealNameAuth: {
//            TM_RealNameAuthViewController *vc = [TM_RealNameAuthViewController new];
//            vc.cardDetailInfoModel = self.model;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeTransactionRecord: {
            TM_BuyHistoryViewController *vc = [TM_BuyHistoryViewController new];
            vc.cardDetailInfoModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 懒加载
- (TM_HomeShortcutMenuView *)shortcutMenuView{
    if(!_shortcutMenuView) {
        _shortcutMenuView = [[TM_HomeShortcutMenuView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, kScreen_Width / 862 * 500)];
        _shortcutMenuView.delegate = self;
        _shortcutMenuView.backgroundColor = [UIColor whiteColor];
        _shortcutMenuView.layer.cornerRadius = 10;
        _shortcutMenuView.clipsToBounds = YES;
    }
    return _shortcutMenuView;
}
@end
