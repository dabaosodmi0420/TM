////
////  TM_QuestionViewController.m
////  TIanmu
////
////  Created by 郑连杰 on 2023/8/29.
////
//
//#import "TM_QuestionViewController.h"
//#import "TM_DataCardApiManager.h"
//@interface TM_QuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
//
//@property (nonatomic, strong)UITableView *tableView;
//
//@property (nonatomic, strong)NSArray *dataArray;
//
//@end
//
//@implementation TM_QuestionViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//- (void)createView {
//    self.title = @"常见问题";
//    
//    [self.view addSubview:self.tableView];
//}
//#pragma mark - 数据请求
//- (void)reloadData {
//    [TM_DataCardApiManager sendQueryHelpWithSuccess:^(id  _Nullable respondObject) {
//        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
//            
//        }else {
//            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
//            TM_ShowToast(self.view, msg);
//        }
//    } failure:^(NSError * _Nullable error) {
//        NSLog(@"%@",error);
//        TM_ShowToast(self.view, @"获取数据失败");
//    }];
//}
//
//#pragma mark - UITableViewDelegate
//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    YT_RecordVersionCell *cell = [tableView dequeueReusableCellWithIdentifier:kVerSionRecordCell];
//    if (!cell) {
//        cell = [[YT_RecordVersionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kVerSionRecordCell];
//    }
//    cell.model = self.dataArray[indexPath.section];
//    return cell;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 3)];
//    return footer;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 3;
//    }
//    return 1.5f;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataArray.count;
//}
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    YT_RecordVersionModel *model = self.dataArray[section];
//    NSInteger count = model.isExpand == YES ? 1 : 0;
//    return count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    YT_RecordVersionModel *model = self.dataArray[indexPath.section];
//    return model.cellHeight;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 90;
//    } else if (section == 1) {
//        return 81;
//    } else {
//        return 60;
//    }
//}
//#pragma mark - getter
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStyleGrouped];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.bounces = NO;
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//#ifdef __IPHONE_15_0
//        if (@available(iOS 15.0, *)) {
//            _tableView.sectionHeaderTopPadding = 0;
//            _tableView.prefetchingEnabled = NO;
//        }
//#endif
//    }
//    return _tableView;
//}
//
//- (NSArray *)dataArray {
//    if (!_dataArray) {
//        _dataArray = [NSArray array];
//    }
//    return _dataArray;
//}
//
//@end
