//
//  TM_HomePageViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_HomePageViewController.h"
#import "TM_NavTitleView.h"
#import "TM_imgLabelButton.h"
#import "TM_ScrollView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "TM_HomeShortcutMenuView.h"
#import "TM_HomeProductView.h"
#import "TM_ProductListCell.h"
#import "TM_ProductListModel.h"
#import "TM_BannerModel.h"
#import "TM_ShortMenuModel.h"
#import "TM_ConfigTool.h"
#import "TM_DataCardManagerViewController.h"
#import "TM_NavigationController.h"
#import "TM_LoginViewController.h"
#import "TM_DeviceDetailViewController.h"
#import "TM_ProductInfoViewController.h"
#import "TM_DataCardApiManager.h"
#import "TM_CardDetailViewController.h"

#define KProductListCellId  @"KProductListCellId"
#define KBannerCellId       @"KBannerCellId"
#define KShortMenuCellId    @"KShortMenuCellId"

#define kMainScrollViewTag       0xE01

@interface TM_HomePageViewController ()<TM_NavTitleViewDelegate, SDCycleScrollViewDelegate, TM_HomeShortcutMenuViewDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{
    BOOL _isDidAppear;
}

@property (nonatomic, strong) TM_NavTitleView           *navTitleView;
/* 轮播图 */
@property (strong, nonatomic) SDCycleScrollView         *cycleScrollView;
/* 按钮菜单 */
@property (strong, nonatomic) TM_HomeShortcutMenuView   *shortcutMenuView;
/* uicollectionView */
@property (strong, nonatomic) UICollectionView          *collectionView;
/** 产品数据源 */
@property (strong, nonatomic) NSMutableArray<TM_ProductListModel *> *productDatas;
/* 顶部banner数据源 */
@property (strong, nonatomic) NSMutableArray<TM_BannerModel *>      *bannerDatas;
/* 按钮菜单数据源 */
@property (strong, nonatomic) NSMutableArray<TM_ShortMenuModel *>   *shortMenuDatas;

@end

@implementation TM_HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDatas];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!_isDidAppear) {
        [self createNav];
        _isDidAppear = YES;
    }
}

#pragma mark - 数据
- (void)loadDatas {
    NSArray *cycleImages = @[@"http://jdwlwm2m.com/excel/appImg/banner1.png",
                             @"http://jdwlwm2m.com/excel/appImg/banner2.png",
                             @"http://jdwlwm2m.com/excel/appImg/banner3.png"];
    self.cycleScrollView.imageURLStringsGroup = cycleImages;
    
    self.shortMenuDatas = (NSMutableArray *)[[TM_ShortMenuModel mj_objectArrayWithKeyValuesArray:[TM_ConfigTool getDeviceShortMenuListDatas]] subarrayWithRange:NSMakeRange(0, 8)];
    self.shortcutMenuView.dataArray = self.shortMenuDatas;
    
    self.productDatas = [TM_ProductListModel mj_objectArrayWithKeyValuesArray:[TM_ConfigTool getProductListDatas]];
    [self.collectionView reloadData];
    
    [self endRefresh];
}

#pragma mark - 创建UI
- (void)createNav {
    // 左侧占位按钮
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    spaceView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithCustomView:spaceView] ;
    self.navigationItem.leftBarButtonItem = space;
    // 搜索
    self.navigationItem.titleView = self.navTitleView;
    // 右侧按钮
    TM_imgLabelButton *msgBtn = [[TM_imgLabelButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    msgBtn.image = [UIImage imageNamed:@"navBar_messageNew_white"];
    msgBtn.text = @"消息";
    msgBtn.bottomNameFont = [UIFont systemFontOfSize:10];
    msgBtn.color = [UIColor whiteColor];
    [msgBtn addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc] initWithCustomView:msgBtn];
    self.navigationItem.rightBarButtonItems = @[ msgItem];
    
}

- (void)createView {
    [super createView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.collectionView];
}

#pragma mark - Activity
- (void)rightNavItemClick {
    NSLog(@"%@",@"点击消息");
    [self showNotOpenAlert];
}
-(void)endRefresh{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
#pragma mark - tm_NavTitleViewDelegate --- 导航栏按钮点击代理
- (void)clickHomeNavTitleViewBtnsWithSigns:(NSString *)signs {
    if ([signs isEqualToString:@"1"]) { //1-搜索按钮点击
        [self showNotOpenAlert];
    }
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击：%ld",(long)index);
}

#pragma mark - TM_HomeShortcutMenuViewDelegate
- (void)clickHomeShortcutMenuWithModel:(TM_ShortMenuModel *)model{
    switch (model.funcType) {
        case TM_ShortMenuTypeBalanceRecharge:
        case TM_ShortMenuTypeFlowRecharge:
        case TM_ShortMenuTypeRealNameAuth:
        case TM_ShortMenuTypeTransactionRecord:
        case TM_ShortMenuTypeNetChange:
        case TM_ShortMenuTypeRemoteControl: {
            if ([TM_SettingManager shareInstance].hasPhoneLogged){
                TM_DataCardInfoModel *cardInfoModel = [TM_SettingManager shareInstance].dataCardInfoModel;
                if (cardInfoModel) {
                    [TM_DataCardApiManager sendQueryUserAllCardWithCardNo:cardInfoModel.iccid success:^(TM_DataCardDetalInfoModel * _Nonnull model) {
                        if([[NSString stringWithFormat:@"%@",model.card_or_device] isEqualToString:@"0"]) { // 卡
                            TM_CardDetailViewController *vc = [[TM_CardDetailViewController alloc] init];
                            vc.cardInfoModel = cardInfoModel;
                            vc.model = model;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if ([[NSString stringWithFormat:@"%@", model.card_or_device] isEqualToString:@"1"]) { // 设备
                            TM_DeviceDetailViewController *vc = [[TM_DeviceDetailViewController alloc] init];
                            vc.cardInfoModel = cardInfoModel;
                            vc.model = model;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    } failure:^(NSError * _Nullable error) {
                        
                    }];
                    
                }else{
                    TM_DataCardManagerViewController *vc = [[TM_DataCardManagerViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else {
                TM_LoginViewController *loginVC = [[TM_LoginViewController alloc] init];
                loginVC.modalPresentationStyle = 0;
                TM_NavigationController *nav = [[TM_NavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
            break;
        case TM_ShortMenuTypeElectronicWaste: {
            TM_ShowFuncNoOpenToast;
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - collectionView 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else {
        return self.productDatas.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 顶部bannner
        UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KBannerCellId forIndexPath:indexPath];
        [cell.contentView addSubview:self.cycleScrollView];
        return cell;
    }else if (indexPath.section == 1) { // 按钮菜单
        UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KShortMenuCellId forIndexPath:indexPath];
        [cell.contentView addSubview:self.shortcutMenuView];
        return cell;
    }else { // 产品列表
        TM_ProductListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KProductListCellId forIndexPath:indexPath];
        cell.model = self.productDatas[indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 1) {
        TM_ProductInfoViewController *vc = [[TM_ProductInfoViewController alloc] init];
        vc.productModel = self.productDatas[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
// 动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.cycleScrollView.size;
    }else if (indexPath.section == 1) {
        return self.shortcutMenuView.size;
    }else {
        return CGSizeMake(self.view.width * 0.5 - 20, self.view.width * 0.5 - 20 + 35);
    }
}
// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsZero;
    }else if (section == 1) {
        return UIEdgeInsetsZero;
    }else {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
}

#pragma mark - 懒加载
#pragma mark - getting && setting
- (UICollectionView *)collectionView{
    if (!_collectionView){
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义布局方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //定义每个cell纵向的间距
        flowLayout.minimumLineSpacing = 0;
        //定义每个cell的横向间距
        flowLayout.minimumInteritemSpacing = 0;
        //定义每个cell到容器边缘的距离
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavi_StatusBarHeight - kTabBarHeight) collectionViewLayout:flowLayout];
        //注册cell
        [_collectionView registerClass:[TM_ProductListCell class] forCellWithReuseIdentifier:KProductListCellId];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:KBannerCellId];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:KShortMenuCellId];

        //设置代理
        _collectionView.delegate = self;
        //设置数据源
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = TM_SpecialGlobalColorBg;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadDatas];
            
        }];
        _collectionView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            
            [self loadDatas];
        }];
    }
    return _collectionView;
}

- (TM_NavTitleView *)navTitleView {
    if (!_navTitleView) {
        CGRect frame = CGRectMake(0, 0, kScreen_Width - getAutoSize(35) - getAutoSize(60), getAutoSize(28));
        if (iPhone4_5) {
            frame = CGRectMake(0, 0, kScreen_Width - getAutoSize(35) - getAutoSize(60), getAutoSize(28));
        }
        _navTitleView = [[TM_NavTitleView alloc] initWithFrame:frame];
        _navTitleView.navTitleViewDelegate = self;
    }
    return _navTitleView;
}
- (SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width / 862 * 477) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleScrollView.autoScrollTimeInterval = 2.5;
    }
    return _cycleScrollView;
}
- (TM_HomeShortcutMenuView *)shortcutMenuView{
    if(!_shortcutMenuView) {
        _shortcutMenuView = [[TM_HomeShortcutMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width / 862 * 333)];
        _shortcutMenuView.delegate = self;
        _shortcutMenuView.backgroundColor = TM_SpecialGlobalColorBg;
    }
    return _shortcutMenuView;
}

@end
