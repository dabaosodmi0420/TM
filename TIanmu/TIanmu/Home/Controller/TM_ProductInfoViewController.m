//
//  TM_ProductInfoViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/15.
//

#import "TM_ProductInfoViewController.h"

@interface TM_ProductInfoViewController ()
/* scrollview */
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation TM_ProductInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView {
    self.title = self.productModel.menuname;
    [self.view addSubview:self.scrollView];
    
    UIImage *image = [UIImage imageNamed:self.productModel.detailImg];
    CGSize size = image.size;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * size.height / size.width)];
    imgV.image = image;
    self.scrollView.contentSize = imgV.frame.size;
    [self.scrollView addSubview:imgV];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavi_StatusBarHeight)];
        _scrollView.showsVerticalScrollIndicator = NO;
        
    }
    return _scrollView;
}
@end
