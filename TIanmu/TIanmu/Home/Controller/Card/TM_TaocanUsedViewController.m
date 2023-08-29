//
//  TM_TaocanUsedViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import "TM_TaocanUsedViewController.h"
#import "TM_CardTopView.h"
#import "TM_DataCardApiManager.h"

@interface TM_TaocanUsedViewController ()
/* 顶部 */
@property (strong, nonatomic) TM_CardTopView *topView;

/* <#descript#> */
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *usedPencentageL;
@property (strong, nonatomic) UILabel *lastPencentageL;
@property (strong, nonatomic) UILabel *usedL;
@property (strong, nonatomic) UILabel *lastL;
@property (strong, nonatomic) UILabel *timeL;
@property (strong, nonatomic) UILabel *totalL;
@end

@implementation TM_TaocanUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)createView {
    self.title = @"套餐用量";
    self.topView = [[TM_CardTopView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 280) model:self.model];
    self.topView.backgroundColor = TM_SpecialGlobalColorBg;
    [self.view addSubview:self.topView];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(15, self.topView.maxY + 15, 15, 30)];
    v1.backgroundColor = TM_SpecialGlobalColor;
    [self.view addSubview:v1];
    
    UILabel *titleL = [UIView createLabelWithFrame:CGRectMake(v1.maxX + 10, v1.y, 200, 30) title:@"无数据" fontSize:20 color:TM_ColorHex(@"333333")];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    self.titleL = titleL;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(v1.x, titleL.maxY + 15, kScreen_Width - 2 * v1.x, 170)];
    contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [contentView setCornerRadius:10 borderColor:TM_ColorHex(@"303030") borderLineW:0.7];
    [self.view addSubview:contentView];
    
    UILabel *title1L = [UIView createLabelWithFrame:CGRectMake(10, 15, 200, 20) title:@"流量使用详情" fontSize:19 color:TM_ColorHex(@"333333")];
    title1L.backgroundColor = [UIColor clearColor];
    [contentView addSubview:title1L];
    
    // 百分比
    UILabel *usedPencentageL = [UIView createLabelWithFrame:CGRectMake(0, title1L.maxY + 8, contentView.width * 0.5, 30) title:@"无数据" fontSize:15 color:TM_ColorHex(@"444444")];
    usedPencentageL.textAlignment = NSTextAlignmentCenter;
    usedPencentageL.backgroundColor = [UIColor clearColor];
    [contentView addSubview:usedPencentageL];
    self.usedPencentageL = usedPencentageL;
    
    UILabel *lastPencentageL = [UIView createLabelWithFrame:CGRectMake(usedPencentageL.maxX, usedPencentageL.y , contentView.width * 0.5, 30) title:@"无数据" fontSize:15 color:TM_ColorHex(@"444444")];
    lastPencentageL.textAlignment = NSTextAlignmentCenter;
    lastPencentageL.backgroundColor = [UIColor clearColor];
    [contentView addSubview:lastPencentageL];
    self.lastPencentageL = lastPencentageL;
    
    // 用量
    UILabel *usedL = [UIView createLabelWithFrame:CGRectMake(0, usedPencentageL.maxY + 3, contentView.width * 0.5, 30) title:@"无数据" fontSize:21 color:TM_ColorHex(@"000000")];
    usedL.font = [UIFont boldSystemFontOfSize:21];
    usedL.textAlignment = NSTextAlignmentCenter;
    usedL.backgroundColor = [UIColor clearColor];
    [contentView addSubview:usedL];
    self.usedL = usedL;
    
    UILabel *lastL = [UIView createLabelWithFrame:CGRectMake(usedL.maxX, usedL.y, contentView.width * 0.5, 30) title:@"无数据" fontSize:21 color:TM_ColorHex(@"000000")];
    lastL.font = [UIFont boldSystemFontOfSize:21];
    lastL.textAlignment = NSTextAlignmentCenter;
    lastL.backgroundColor = [UIColor clearColor];
    [contentView addSubview:lastL];
    self.lastL = lastL;
    
    // 时间
    UILabel *timeL = [UIView createLabelWithFrame:CGRectMake(10, contentView.height - 40, (contentView.width - 30) * 0.7, 30) title:@"无数据" fontSize:18 color:TM_ColorHex(@"333333")];
    timeL.backgroundColor = [UIColor clearColor];
    [contentView addSubview:timeL];
    self.timeL = timeL;
    
    UILabel *totalL = [UIView createLabelWithFrame:CGRectMake(timeL.maxX + 10, timeL.y, (contentView.width - 30) * 0.3, 30) title:@"无数据" fontSize:18 color:TM_ColorHex(@"333333")];
    totalL.textAlignment = NSTextAlignmentRight;
    totalL.backgroundColor = [UIColor clearColor];
    [contentView addSubview:totalL];
    self.totalL = totalL;
}

- (void)reloadData {
    [TM_DataCardApiManager sendQueryUserFlowWithCardNo:self.model.card_define_no success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            CGFloat used = [data[@"used"] doubleValue];
            CGFloat total = [data[@"total"] doubleValue];
            CGFloat percent = used / total;
            self.usedPencentageL.text = [NSString stringWithFormat:@"已用%.2f%%", percent * 100];
            self.lastPencentageL.text = [NSString stringWithFormat:@"剩余%.2f%%", (1 - percent) * 100];
            self.usedL.text = [NSString stringWithFormat:@"共%.2f GB", used];
            self.lastL.text = [NSString stringWithFormat:@"共%.2f GB", total - used];
            self.timeL.text = [NSString stringWithFormat:@"流量有效期:%@",data[@"tc_end_time"]];
            self.totalL.text = [NSString stringWithFormat:@"共%.1fGB", total];
            self.titleL.text = self.model.package_name;
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"获取数据失败");
    }];
}
                    
@end
