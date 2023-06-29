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

@interface TM_DataCardManagerViewController ()<UITableViewDelegate, UITableViewDataSource> {
    CGFloat _cellHeight;
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
                                      sel:@selector(editClick)
                                      target:self];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItems = @[ editItem];
}
- (void)createView {
    [super createView];
    [self.view addSubview:self.tableView];
    
    UIButton *addDataCard = [UIView createButton:CGRectMake(10, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 40, kScreen_Width - 20, 40)
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
#pragma mark - 获取数据
- (void)getDatas {
    [TM_DataCardApiManager sendQueryUserAllCardWithPhoneNum:[TM_SettingManager shareInstance].sIdentifierId success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                self.dataArray = [TM_DataCardInfoModel mj_objectArrayWithKeyValuesArray:data];
                [self.tableView reloadData];
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
- (void)leftNavItemClick {
    NSLog(@"%@",@"跳转设置");
    TM_SettingViewController *vc = [[TM_SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addDataCardClick {
    NSLog(@"%@",@"添加流量卡");
}
- (void)editClick {
    NSLog(@"%@",@"编辑");
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageV.maxX + margin, margin, contentView.width - (imageV.maxX + margin) - 50, imageV.height)];
    label.text = [NSString stringWithFormat:@"%@",model.iccid];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:17];
    [label adjustsFontSizeToFitWidth];
    [contentView addSubview:label];
    
    UIImageView *accessoryView = [UIImageView new];
    accessoryView.size = CGSizeMake(15, 15);
    accessoryView.center = CGPointMake(contentView.width - 30, contentView.height * 0.5);
    UIImage *image = [UIImage imageNamed:@"setting-arrow-right"];
    accessoryView.image = image;
    accessoryView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:accessoryView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TM_DataCardInfoModel *model = self.dataArray[indexPath.row];
    TM_DeviceDetailViewController *vc = [[TM_DeviceDetailViewController alloc] init];
    vc.cardInfoModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setting && getting
- (UITableView *)tableView {
    if (!_tableView) {
        _cellHeight = 80;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 40) style:UITableViewStylePlain];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
