//
//  TM_BuyHistoryViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_BuyHistoryViewController.h"
#import "TM_DataCardApiManager.h"
#import "TM_CardTradeModel.h"
@interface TM_BuyHistoryViewController ()<UITableViewDelegate, UITableViewDataSource> {
    CGFloat _cellHeight;
}

/* uitableView */
@property (strong, nonatomic) UITableView                       *tableView;
@property (nonatomic, strong) NSArray<TM_CardTradeModel *>   *dataArray;

@end

@implementation TM_BuyHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDatas];
}
#pragma mark - 创建UI
- (void)createView {
    self.title = @"购买记录";
    [self.view addSubview:self.tableView];
    
    UIDatePicker *datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreen_Height - 400, kScreen_Width, 400)];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        datePickerView.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:datePickerView];
    
}
#pragma mark - 获取数据
- (void)getDatas {
    [TM_DataCardApiManager sendGetCardTradeWithCardNo:self.cardDetailInfoModel.card_define_no month:@"2023-06" success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                self.dataArray = [TM_CardTradeModel mj_objectArrayWithKeyValuesArray:data];
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
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, self.tableView.width - 40, _cellHeight - 10)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    [cell.contentView addSubview:contentView];
    
    TM_CardTradeModel *model = self.dataArray[indexPath.row];
    CGFloat margin = 25;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin, 7, contentView.width - 2 * margin, 20)];
    label.text = [NSString stringWithFormat:@"账户充值  %0.2f",model.sum];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    [label adjustsFontSizeToFitWidth];
    [contentView addSubview:label];
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"Paste me!";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
