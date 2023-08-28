//
//  TM_ProductInfoViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/15.
//

#import "TM_ProductInfoViewController.h"

@interface TM_ProductInfoViewController ()

@end

@implementation TM_ProductInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView {
    self.title = self.productModel.menuname;
    self.requestHandle.requestType = WKRequestType_LOCAL;
    self.requestHandle.localFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [self.requestHandle loadRequestWithWeb:self.webView];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    NSString *js = [NSString stringWithFormat:@"setJSforImageType('%@')", self.productModel.menuname];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

@end
