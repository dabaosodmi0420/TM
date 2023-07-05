//
//  TM_WKBaseWebViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import "TM_WKBaseWebViewController.h"


@interface TM_WKBaseWebViewController ()
@property(nonatomic,strong,readwrite)WKWebView * webView;
@end

@implementation TM_WKBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //loadReq
    [self loadReq];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNav];
    if (@available(iOS 11.0,*)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
#pragma mark - 创建UI
- (void)createNav {
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
    if (self.titleString) {
        self.title = self.titleString;
    }
    //webView
    [self.view addSubview:self.webView];
}

- (void)loadReq{
    [self.requestHandle loadRequestWithWeb:self.webView];
}
#pragma mark - Activity
- (void)leftNavItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 懒加载
- (WKWebView *)webView{
    if(!_webView){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavi_StatusBarHeight)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

- (TM_WKRequestHandle *)requestHandle{
    if(!_requestHandle){
        _requestHandle = [TM_WKRequestHandle new];
    }
    return _requestHandle;
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
