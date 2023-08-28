//
//  TM_SettingViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "TM_SettingViewController.h"
#import "TM_ConfigTool.h"
#import "TM_LoginViewController.h"
#import "TM_NavigationController.h"
#import "TM_AboutCompanyController.h"
#import "TM_ProtocolViewController.h"

#define SettingRowHeight      (45)
#define SettingFooterHeigt    (55)

#define kMeSettingCellKey @"kSettingCellKey"

@interface TM_SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation TM_SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNav];
    
    [self updateFooterViewStatus];
}
#pragma mark - 创建UI
- (void)createNav {
    self.title = @"设置";
    
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
    [self.view addSubview:self.tableView];
    self.dataArray = [NSMutableArray arrayWithArray:[TM_ConfigTool getSettingDatasCenter]];
    [self.tableView reloadData];
    [self updateFooterViewStatus];
}
//更新登录状态后，更新 footer view 。
- (void)updateFooterViewStatus{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        _footerView.backgroundColor = [UIColor whiteColor];
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.frame = CGRectMake(0, 5, _footerView.width, _footerView.height - 10);
        [_logoutButton setTitleColor:TM_SpecialGlobalColor forState:UIControlStateNormal];
        [_logoutButton setTitleColor:TM_SpecialGlobalColor forState:UIControlStateHighlighted];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_footerView addSubview:_logoutButton];
        [_logoutButton addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView setTableFooterView:_footerView];
    }
    NSString * title = @"登录";
    if ([TM_SettingManager shareInstance].hasPhoneLogged) {
        title = @"退出登录";
    }
    [_logoutButton setTitle:title forState:UIControlStateNormal];
}
#pragma mark - Activity
- (void)leftNavItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logoutClick:(UIButton *)btn {
    if ([TM_SettingManager shareInstance].hasPhoneLogged) {
        [JTDefinitionTextView jt_showWithTitle:nil Text:@"是否退出登录" type:JTAlertTypeNot actionTextArr:@[@"取消",@"退出登录"] handler:^(NSInteger index) {
            if (index == 1) {
                [TM_SettingManager clear];
                [self updateFooterViewStatus];
            }
        }];
    }else{
        TM_LoginViewController *loginVC = [[TM_LoginViewController alloc] init];
        loginVC.modalPresentationStyle = 0;
        TM_NavigationController *nav = [[TM_NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMeSettingCellKey];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMeSettingCellKey];
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
    
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (SettingRowHeight - 25) * 0.5, kScreen_Width - 40, 25)];
    label.text = dic[@"name"];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:label];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TM_AboutCompanyController *vc = [TM_AboutCompanyController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString *urlString = @"";
            NSString *title = @"";
            if (indexPath.row == 1) {
                // 注册协议
                urlString = @"http://jdwlwm2m.com/custjdwl/trigger/queryUserXY";
                title = @"用户协议";
            }else if (indexPath.row == 2) {
                // 隐私协议
                urlString = @"http://jdwlwm2m.com/custjdwl/trigger/queryAppZC";
                title = @"隐私协议";
            }
            TM_ProtocolViewController *vc = [TM_ProtocolViewController new];
            vc.requestHandle.requestType = WKRequestType_Remote;
            vc.requestHandle.remoteUrl = urlString;
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1) {
        NSLog(@"%@",@"清理缓存");
    }else{
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else if (section == 1) {
        return 6;
    }else{
        return  0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (section == 0) {
        height = 15;
    }else if (section == 1) {
        height = 10;
    }
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 15;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];

    return header;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TM_SpecialGlobalColorBg;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.rowHeight = SettingRowHeight;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMeSettingCellKey];
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
