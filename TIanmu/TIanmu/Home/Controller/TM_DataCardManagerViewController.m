//
//  TM_DataCardManagerViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/28.
//

#import "TM_DataCardManagerViewController.h"
#import "TM_DataCardInfoModel.h"
#import "TM_DataCardApiManager.h"
#import "TM_SettingViewController.h"
#import "TM_DeviceDetailViewController.h"
#import "TM_StorageData.h"
#import "TM_AddDeviceViewController.h"
#import "TM_CardDetailViewController.h"

#define kDeleteBtn_Tag 111

@interface TM_DataCardManagerViewController ()<UITableViewDelegate, UITableViewDataSource> {
    CGFloat _cellHeight;
    BOOL _isEdit;// 是否点击的编辑按钮
}

/* uitableView */
@property (strong, nonatomic) UITableView                       *tableView;
@property (nonatomic, strong) NSArray<TM_DataCardInfoModel *>   *dataArray;

@end

@implementation TM_DataCardManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([TM_SettingManager shareInstance].hasPhoneLogged) {
        [self getDatas];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNav];
}
#pragma mark - 创建UI
- (void)createNav {
    self.title = @"流量卡管理";
    
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
    [setting setImage:[UIImage imageNamed:@"personal_set"] forState:UIControlStateNormal];
    [setting setImage:[UIImage imageNamed:@"personal_set"] forState:UIControlStateHighlighted];
    setting.frame = CGRectMake(0, 0, 20, 20);
    [setting addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:setting];
    self.navigationItem.leftBarButtonItems = @[ settingItem];
    
    UIButton *editBtn = [UIView createButton:CGRectMake(0, 0, 30, 30)
                                       title:@"编辑"
                                  titleColoe:[UIColor whiteColor]
                               selectedColor:[UIColor whiteColor]
                                    fontSize:14
                                         sel:@selector(editClick:)
                                      target:self];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItems = @[ editItem];
}
- (void)createView {
    [super createView];
    [self.view addSubview:self.tableView];
    
    UIButton *addDataCard = [UIView createButton:CGRectMake(10, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 45, kScreen_Width - 20, 40)
                                           title:@"+添加流量卡"
                                      titleColoe:[UIColor whiteColor]
                                   selectedColor:[UIColor whiteColor]
                                        fontSize:16
                                             sel:@selector(addDataCardClick)
                                          target:self];
    addDataCard.backgroundColor = TM_ColorRGB(46, 115, 200);
    addDataCard.layer.masksToBounds = YES;
    addDataCard.layer.cornerRadius = 10;
    [self.view addSubview:addDataCard];
}
- (void)addNoDataUI {
    UILabel *msgL = [UILabel createLabelWithFrame:CGRectMake(30, 70, kScreen_Width - 60, 80) title:@"您还没有绑定流量卡\n可点击下方添加按钮\n进行添加绑定" fontSize:16 color:TM_ColorHex(@"888888")];
    msgL.numberOfLines = 0;
    msgL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:msgL];
    
    UIButton *back = [UIButton createButton:CGRectMake(0, msgL.maxY + 30, 80, 30) title:@"返回首页" titleColoe:TM_SpecialGlobalColor selectedColor:TM_SpecialGlobalColor fontSize:16 sel:@selector(back:) target:self];
    back.centerX = self.view.centerX;
    [back setCornerRadius:back.height * 0.5 borderColor:TM_SpecialGlobalColorBg borderLineW:0.5];
    [self.view addSubview:back];
}
- (void)addErrorDataUI {
    UILabel *msgL = [UILabel createLabelWithFrame:CGRectMake(30, 70, kScreen_Width - 60, 80) title:@"数据加载失败\n请重新刷新数据" fontSize:16 color:TM_ColorHex(@"888888")];
    msgL.numberOfLines = 0;
    msgL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:msgL];
    
    UIButton *refresh = [UIButton createButton:CGRectMake(0, msgL.maxY + 30, 80, 30) title:@"刷新" titleColoe:TM_SpecialGlobalColor selectedColor:TM_SpecialGlobalColor fontSize:16 sel:@selector(getDatas) target:self];
    refresh.centerX = self.view.centerX;
    [refresh setCornerRadius:refresh.height * 0.5 borderColor:TM_SpecialGlobalColorBg borderLineW:0.5];
    [self.view addSubview:refresh];
    
    UIButton *back = [UIButton createButton:CGRectMake(0, refresh.maxY + 30, 80, 30) title:@"返回首页" titleColoe:TM_SpecialGlobalColor selectedColor:TM_SpecialGlobalColor fontSize:16 sel:@selector(back:) target:self];
    back.centerX = self.view.centerX;
    [back setCornerRadius:back.height * 0.5 borderColor:TM_SpecialGlobalColorBg borderLineW:0.5];
    [self.view addSubview:back];
}
#pragma mark - 获取数据
- (void)getDatas {
    [TM_DataCardApiManager sendQueryUserAllCardWithPhoneNum:[TM_SettingManager shareInstance].sIdentifierId success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                self.dataArray = [TM_DataCardInfoModel mj_objectArrayWithKeyValuesArray:data];
                if (self.dataArray.count > 0) {
                    [self.tableView reloadData];
                }else {
                    [self addNoDataUI];
                }
            }else {
                TM_ShowToast(self.view, @"获取数据失败");
                [self addErrorDataUI];
            }
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
            [self addErrorDataUI];
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"获取数据失败");
        [self addErrorDataUI];
    }];
}
#pragma mark - Activity
- (void)back:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)leftNavItemClick {
    NSLog(@"%@",@"跳转设置");
    TM_SettingViewController *vc = [[TM_SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addDataCardClick {
    NSLog(@"%@",@"添加流量卡");
    TM_AddDeviceViewController *vc = [TM_AddDeviceViewController new];
    vc.refreshDataBlock = ^() {
        NSLog(@"%@",@"刷新数据");
        [self getDatas];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)editClick:(UIButton *)btn {
    NSLog(@"%@",@"编辑");
    _isEdit = !_isEdit;
    if (_isEdit) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else {
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (void)deleteCardItem:(UIButton *)btn {
    [JTDefinitionTextView jt_showWithTitle:@"提示" Text:@"确定移除该流量卡吗" type:JTAlertTypeNot actionTextArr:@[@"确定",@"取消"] handler:^(NSInteger index) {
        if (index == 0) {
            TM_DataCardInfoModel *model = self.dataArray[btn.tag - kDeleteBtn_Tag];
            [TM_DataCardApiManager sendUserUnBindCardWithPhoneNum:[TM_SettingManager shareInstance].sIdentifierId CardNo:model.card_define_no success:^(id  _Nullable respondObject) {
                if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
                    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.dataArray];
                    [tmpArr removeObject:model];
                    self.dataArray = tmpArr;
                    [self.tableView reloadData];
                }else {
                    NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
                    TM_ShowToast(self.view, msg);
                }
            } failure:^(NSError * _Nullable error) {
                NSLog(@"%@",error);
                TM_ShowToast(self.view, @"解绑失败");
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *const kSettingCellKey = @"kDataCardManagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellKey];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingCellKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIButton *accessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
//        accessoryView.userInteractionEnabled = NO;
//        accessoryView.bounds = CGRectMake(0, 0, 15, 15);
//        cell.accessoryView = accessoryView;
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, self.tableView.width - 40, _cellHeight - 10)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    [cell.contentView addSubview:contentView];
    
    TM_DataCardInfoModel *model = self.dataArray[indexPath.row];
    CGFloat margin = 12;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, contentView.height - 2 * margin, contentView.height - 2 * margin)];
    imageV.image = [UIImage imageNamed:@"denglu"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageV.maxX + margin, margin, contentView.width - (imageV.maxX + margin) - 55, imageV.height)];
    label.text = [NSString stringWithFormat:@"%@",model.iccid];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:17];
    label.adjustsFontSizeToFitWidth = YES;
    [contentView addSubview:label];
    
    UIImageView *accessoryView = [UIImageView new];
    accessoryView.size = CGSizeMake(15, 15);
    accessoryView.center = CGPointMake(contentView.width - 45, contentView.height * 0.5);
    UIImage *image = [UIImage imageNamed:@"setting-arrow-right"];
    accessoryView.image = image;
    accessoryView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:accessoryView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.size = CGSizeMake(11, 13);
    deleteBtn.center = CGPointMake(contentView.width - deleteBtn.width - 5, contentView.height * 0.5);
    [deleteBtn setImage:[UIImage imageNamed:@"delete_highlight_icon"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"delete_highlight_icon"] forState:UIControlStateHighlighted];
    deleteBtn.tag = kDeleteBtn_Tag + indexPath.row;
    [deleteBtn addTarget:self action:@selector(deleteCardItem:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deleteBtn];
    deleteBtn.hidden = !_isEdit;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TM_DataCardInfoModel *cardInfoModel = self.dataArray[indexPath.row];
    
    [[TM_SettingManager shareInstance] updateCurrentDataCardInfoModel:cardInfoModel];
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
    
}

#pragma mark - setting && getting
- (UITableView *)tableView {
    if (!_tableView) {
        _cellHeight = 80;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 45) style:UITableViewStylePlain];
        _tableView.backgroundColor = TM_SpecialGlobalColorBg;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = _cellHeight;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
#ifdef __IPHONE_15_0
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
            _tableView.prefetchingEnabled = NO;
        }
#endif
    }
    return _tableView;
}

@end
