//
//  TM_BuyHistoryViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_BuyHistoryViewController.h"
#import "TM_DataCardApiManager.h"
#import "TM_CardTradeModel.h"
#import "DatePickerView.h"
@interface TM_BuyHistoryViewController ()<UITableViewDelegate, UITableViewDataSource, DatePickerViewDelegate> {
    CGFloat _cellHeight;
}

/* 当前查询时间 */
@property (strong, nonatomic) UILabel                           *curQuertTimeL;

/* uitableView */
@property (strong, nonatomic) UITableView                       *tableView;
@property (nonatomic, strong) NSArray<TM_CardTradeModel *>      *dataArray;
@end

@implementation TM_BuyHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
    [self getDatas:[NSString stringWithFormat:@"%ld-%ld", (long)comp.year, (long)comp.month]];
}

#pragma mark - 创建UI
- (void)createView {
    self.title = @"购买记录";
    
    UILabel *curQuertTimeL = [UIView createLabelWithFrame:CGRectMake(0, 0, kScreen_Width, 40) title:@"       当前查询范围：当月" fontSize:15 color: TM_SpecialGlobalColor];
    curQuertTimeL.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:curQuertTimeL];
    self.curQuertTimeL = curQuertTimeL;
    
    [self.view addSubview:self.tableView];
    self.tableView.y = curQuertTimeL.maxY;
    self.tableView.height = kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 40 - curQuertTimeL.height;
    
    UIButton *changeTime = [UIView createButton:CGRectMake(0, kScreen_Height - kNavi_StatusBarHeight - Iphone_Bottom_UnsafeDis - 40, kScreen_Width, 40)
                                        title:@"选择时间"
                                   titleColoe:TM_ColorRGB(255, 255, 255)
                                selectedColor:TM_ColorRGB(255, 255, 255)
                                     fontSize:17
                                          sel:@selector(changeTimeClick)
                                       target:self];
    changeTime.backgroundColor = TM_SpecialGlobalColor;
    [self.view addSubview:changeTime];
    
    
}

#pragma mark - Activety
- (void)changeTimeClick {
    [self pickViewSelect];
}
- (void)pickViewSelect {
    DatePickerView* datePickerView = [[DatePickerView alloc] init];
    datePickerView.delegate = self;
    [datePickerView show];
}

- (void)pickerDateView:(BasePickerView *)pickerDateView selectYear:(NSInteger)year selectMonth:(NSInteger)month selectDay:(NSInteger)day {
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld", (long)year, (long)month];
    [self getDatas: dateStr];
    self.curQuertTimeL.text = [NSString stringWithFormat:@"       当前查询范围：%@", dateStr];
}

- (void)copyOrderNum:(UIButton *)btn {
    if (btn.tag - 666 < self.dataArray.count) {
        TM_CardTradeModel *model = self.dataArray[btn.tag - 666];
        NSLog(@"%@", model.ord_no);
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.ord_no;
        TM_ShowToast(self.view, @"复制成功");
    }
}
#pragma mark - 获取数据
- (void)getDatas:(NSString *)date {
    [TM_DataCardApiManager sendGetCardTradeWithCardNo:self.cardDetailInfoModel.card_define_no month:date success:^(id  _Nullable respondObject) {
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
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(margin, 7, contentView.width - 2 * margin, 20)];
    priceL.textColor = [UIColor darkGrayColor];
    priceL.font = [UIFont systemFontOfSize:15];
    NSString *price = [NSString stringWithFormat:@"￥%0.2f", model.sum];
    NSString *str = [NSString stringWithFormat:@"账户充值  %@", price];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
        NSFontAttributeName : priceL.font
    }];
    [attribute addAttributes:@{
        NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange([str rangeOfString:price].location, price.length)];
    priceL.attributedText = attribute;
    [contentView addSubview:priceL];
    
    UILabel *orderL = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, contentView.width - 2 * margin, 20)];
    orderL.centerY = contentView.height * 0.5;
    orderL.textColor = [UIColor darkGrayColor];
    orderL.font = [UIFont systemFontOfSize:15];
    orderL.text = [NSString stringWithFormat:@"订单号：%@", model.ord_no];
    [contentView addSubview:orderL];
    [orderL sizeToFit];
    
    UIButton *copyBtn = [UIView createButton:CGRectMake(orderL.maxX, 0, 50, 20)
                                       title:@"复制"
                                  titleColoe:TM_SpecialGlobalColor
                               selectedColor:TM_SpecialGlobalColor
                                    fontSize:17
                                         sel:@selector(copyOrderNum:)
                                      target:self];
    copyBtn.centerY = orderL.centerY;
    copyBtn.tag = 666 + indexPath.row;
    [contentView addSubview:copyBtn];
    
    UILabel *orderTimeL = [[UILabel alloc] initWithFrame:CGRectMake(margin, contentView.height - 7 - 20, contentView.width - 2 * margin, 20)];
    orderTimeL.textColor = TM_ColorHex(@"#AAAAAA");
    orderTimeL.font = [UIFont systemFontOfSize:15];
    orderTimeL.text = [NSString stringWithFormat:@"%@", model.cre_time];
    [contentView addSubview:orderTimeL];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - setting && getting
- (UITableView *)tableView {
    if (!_tableView) {
        _cellHeight = 100;
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
