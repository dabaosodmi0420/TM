//
//  TM_ServicePageViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_ServicePageViewController.h"
#import "TM_NoFuncView.h"
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
    TM_NoFuncView *noFuncView = [[TM_NoFuncView alloc] initWithFrame:CGRectMake(0, 60, 130, 0)];
    noFuncView.centerX = self.view.width * 0.5;
    [self.view addSubview:noFuncView];
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
