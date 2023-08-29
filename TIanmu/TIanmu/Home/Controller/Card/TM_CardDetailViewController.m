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
#import "TM_CardBalanceRechargeViewController.h"
#import "TM_CardFlowRechargeViewController.h"
#import "TM_TaocanUsedViewController.h"
#import "TM_QuestionViewController.h"
#import "TM_WeixinTool.h"
#import "TM_CancelCardViewController.h"
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
    
    CGFloat w = 90;
    UIImageView *changeImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - w - 10, 75, w, w * 0.36)];
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

#pragma mark - Activity
- (void)leftNavItemClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)deviceChange {
    NSLog(@"%@",@"设备切换");
    TM_DataCardManagerViewController *vc = [[TM_DataCardManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取数据
- (void)reloadData {
    if (![self.model.is_realname isEqualToString:@"2"]) {
        [TM_DataCardApiManager sendSetAuthWithCardNo:self.model.card_define_no success:^(id  _Nullable respondObject) {
            if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                id data = respondObject[@"data"];
                //实名url，若是data为空，且state是success，则说明已实名
                NSString *url = data[@"url"];
                if (url && url.length > 0) {
                    [JTDefinitionTextView jt_showWithTitle:@"温馨提示" Text:@"您的卡还没有实名认证，是否进行实名？" type:0 actionTextArr:@[@"取消", @"去实名"] handler:^(NSInteger index) {
                        if (index == 1) {
                            [JTBaseTool jt_openUrl:url];
                        }
                    }];
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
#pragma mark - TM_HomeShortcutMenuViewDelegate
- (void)clickHomeShortcutMenuWithModel:(TM_ShortMenuModel *)model {
    switch (model.funcType) {
        case TM_ShortMenuTypeBalanceRecharge: {
            TM_CardBalanceRechargeViewController *vc = [TM_CardBalanceRechargeViewController new];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeFlowRecharge: {
            if (self.model.monthCt == 0 && self.model.nextCt == 0 && self.model.ljCt == 0){
                [JTDefinitionTextView jt_showWithTitle:@"问下提示" Text:@"当前卡无订购套餐" type:0 actionTextArr:@[@"确定"] handler:^(NSInteger index) {
                                    
                }];
            }else {
                TM_CardFlowRechargeViewController *vc = [TM_CardFlowRechargeViewController new];
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case TM_ShortMenuTypeTaocanUsed: {
            TM_TaocanUsedViewController *vc = [TM_TaocanUsedViewController new];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeTransactionRecord: {
            TM_BuyHistoryViewController *vc = [TM_BuyHistoryViewController new];
            vc.cardDetailInfoModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeGuzhang: {
            [JTDefinitionTextView jt_showWithTitle:@"注意" Text:@"是否确认修复？" type:0 actionTextArr:@[@"确认", @"取消"] handler:^(NSInteger index) {
                TM_ShowToast(self.view, @"修复成功");
            }];
        }
            break;
        case TM_ShortMenuTypeService: {
            [[TM_WeixinTool shareWeixinToolManager] tm_weixinToolWithType:TM_WeixinToolTypeWXServiceChat data:@{} completeBlock:^(TM_WeixinToolType type, NSDictionary * _Nonnull param) {
                            
            }];
        }
            break;
        case TM_ShortMenuTypeCancelCard: {
            TM_CancelCardViewController *vc = [TM_CancelCardViewController new];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TM_ShortMenuTypeQuestion: {
            TM_QuestionViewController *vc = [TM_QuestionViewController new];
            vc.model = self.model;
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
