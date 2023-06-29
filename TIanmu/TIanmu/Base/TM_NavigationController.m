//
//  TM_NavigationController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_NavigationController.h"

@interface TM_NavigationController ()

@end

@implementation TM_NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    if(self.viewControllers.count == 2) {
        self.viewControllers[0].hidesBottomBarWhenPushed = NO;
    }
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
