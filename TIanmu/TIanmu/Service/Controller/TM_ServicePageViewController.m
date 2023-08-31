//
//  TM_ServicePageViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_ServicePageViewController.h"
#import "TM_NoFuncView.h"
#import "TM_WeixinTool.h"
@interface TM_ServicePageViewController ()

@end

@implementation TM_ServicePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)createView {
    self.title = @"客服";
    self.view.backgroundColor = TM_SpecialGlobalColorBg;
//    TM_NoFuncView *noFuncView = [[TM_NoFuncView alloc] initWithFrame:CGRectMake(0, 60, 130, 0)];
//    noFuncView.centerX = self.view.width * 0.5;
//    [self.view addSubview:noFuncView];
    
    UIButton *service = [UIButton buttonWithType:UIButtonTypeCustom];
    service.frame = CGRectMake(0, 80, 200, 50);
    service.centerX = self.view.centerX;
    [service setImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
    [service setTitle:@"联系微信客服" forState:UIControlStateNormal];
    [service setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    service.titleLabel.font = [UIFont systemFontOfSize:19];
    service.titleLabel.textAlignment = NSTextAlignmentCenter;
    service.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [service setImageEdgeInsets:UIEdgeInsetsMake(15, -15, 15, 10)];
    [service setTitleEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    service.backgroundColor = TM_ColorRGB(83, 168, 73);
    [service setCornerRadius:10];
    [service addTarget:self action:@selector(serviceClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:service];
}

- (void)serviceClick {
    [[TM_WeixinTool shareWeixinToolManager] tm_weixinToolWithType:TM_WeixinToolTypeWXServiceChat data:@{} completeBlock:^(TM_WeixinToolType type, NSDictionary * _Nonnull param) {
            
    }];
}

@end

