//
//  TM_QuestionViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import "TM_QuestionViewController.h"
#import "TM_DataCardApiManager.h"
#import "TM_QuestionCell.h"
#import "TM_QuestionModel.h"

#define k_questionCellID @"k_questionCellID"
@interface TM_QuestionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation TM_QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)createView {
    self.title = @"常见问题";
    
    [self.view addSubview:self.tableView];
}
#pragma mark - 数据请求
- (void)reloadData {
    [TM_DataCardApiManager sendQueryHelpWithSuccess:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            if (respondObject[@"data"] && [respondObject[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *data = respondObject[@"data"];
                for (NSDictionary *dic in data) {
                    [self.dataArray addObject:[TM_QuestionModel mj_objectWithKeyValues:dic]];
                }
                [self.tableView reloadData];
            }else {
                
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
- (void)click:(UIButton *)btn {
    TM_QuestionModel *model = self.dataArray[btn.tag - 100];
    model.isExpand = !model.isExpand;
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:k_questionCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_questionCellID];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    TM_QuestionModel *model = self.dataArray[indexPath.section];
    
    UILabel *label = [UIView createLabelWithFrame:CGRectMake(10, 0, kScreen_Width - 20, model.cellHeight) title:model.content fontSize:16 color:TM_ColorHex(@"#555555")];
    label.numberOfLines = 0;
    label.font = model.font;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, label.height - 0.7, label.width, 0.7)];
    line.backgroundColor = TM_ColorHex(@"aaaaaa");
    [cell.contentView addSubview:line];
    
    cell.contentView.backgroundColor = TM_ColorHex(@"eeeeee");
    [cell.contentView addSubview:label];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TM_QuestionModel *model = self.dataArray[section];
    NSInteger count = model.isExpand == YES ? 1 : 0;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TM_QuestionModel *model = self.dataArray[indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TM_QuestionModel *model = self.dataArray[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    view.backgroundColor = TM_ColorHex(@"ddddddd");
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 25, 25)];
    imageV.image = [UIImage imageNamed:model.isExpand ? @"jiantou_up" : @"jiantou_down"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageV];
    
    UILabel *label = [UIView createLabelWithFrame:CGRectMake(40, 0, kScreen_Width, 40) title:model.title fontSize:18 color:TM_ColorHex(@"#555555")];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 0.7, view.width, 0.7)];
    line.backgroundColor = TM_ColorHex(@"aaaaaa");
    [view addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = view.bounds;
    btn.tag = 100 + section;
    [view addSubview:btn];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#ifdef __IPHONE_15_0
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
            _tableView.prefetchingEnabled = NO;
        }
#endif
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
