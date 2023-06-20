//
//  TM_PersonPageViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_PersonPageViewController.h"
#import "TM_MeTopView.h"
#import "TM_ShortMenuModel.h"
#import "TM_ConfigTool.h"

#define SettingRowHeight      (56)

@interface TM_PersonPageViewController ()<UITableViewDelegate, UITableViewDataSource>

/* uitableView */
@property (strong, nonatomic) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *dataArray;

/* 顶部View */
@property (strong, nonatomic) TM_MeTopView  *topView;


@end

@implementation TM_PersonPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNav];
}
#pragma mark - 创建UI
- (void)createNav {
    self.title = @"我的";
    
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
    [setting setImage:[UIImage imageNamed:@"personal_set"] forState:UIControlStateNormal];
    [setting setImage:[UIImage imageNamed:@"personal_set"] forState:UIControlStateHighlighted];
    setting.frame = CGRectMake(0, 0, 20, 20);
    [setting addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:setting];
    self.navigationItem.rightBarButtonItems = @[ settingItem];
    
}
- (void)createView {
    [super createView];
    
    [self.view addSubview:self.tableView];
    
    self.dataArray = [TM_ShortMenuModel mj_objectArrayWithKeyValuesArray:[TM_ConfigTool getSettingDatas]];
    [self.tableView reloadData];
}
#pragma mark - Activity
- (void)rightNavItemClick {
    NSLog(@"%@",@"点击设置");
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath.row == 0) {
        static NSString *const kSettingTopCellKey = @"kMeSettingTopCellKey";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTopCellKey];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingTopCellKey];
        }
        [cell.contentView addSubview:self.topView];
        return cell;
    }else {
        static NSString *const kSettingCellKey = @"kMeSettingCellKey";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellKey];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingCellKey];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *accessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
            accessoryView.userInteractionEnabled = NO;
            accessoryView.bounds = CGRectMake(0, 0, 15, 15);
            cell.accessoryView = accessoryView;
        }
        
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.backgroundColor = [UIColor whiteColor];
        
        UIButton *accessoryView = (UIButton *)cell.accessoryView;
        UIImage *image = [UIImage imageNamed:@"setting-arrow-right"];
        [accessoryView setImage:image forState:UIControlStateNormal];
        [accessoryView setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        
        TM_ShortMenuModel *model = self.dataArray[indexPath.row - 1];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 26, 26)];
        imageV.image = [UIImage imageNamed:model.picpath];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 25)];
        label.text = model.menuname;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:label];
        
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.topView.height;
    }else {
        return SettingRowHeight;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showNotOpenAlert];
}

#pragma mark - setting && getting
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavi_StatusBarHeight - kTabBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = TM_SpecialGlobalColorBg;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.rowHeight = SettingRowHeight;
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

- (TM_MeTopView *)topView{
    if (!_topView) {
        _topView = [[TM_MeTopView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 457)];
        _topView.controller = self;
    }
    return _topView;
}
@end
