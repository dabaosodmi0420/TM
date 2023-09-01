//
//  AppOperateGuideView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/28.
//

#import "AppOperateGuideView.h"
#import "YT_PageControl.h"

@interface AppOperateGuideView ()<UIScrollViewDelegate>{
    BOOL    bDismiss_;         //是否已经执行过一次
    NSArray *imageNames;
}
@property (nonatomic ,copy) dispatch_block_t dismissBlock;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic, strong) YT_PageControl *pageControl;

@end

@implementation AppOperateGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        [self createView:frame];
    }
    return self;
}
- (void)createView:(CGRect)frame {
    imageNames = @[@"launch"];
    self.pageControl.numberOfPages = imageNames.count;
    //滚动面板
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [_scrollView setContentSize:CGSizeMake(frame.size.width * imageNames.count, 0)];
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    [self addSubview:self.pageControl];
    CGFloat btmH = 85.0f;
    if (iPhoneX) {
        btmH = 85.0f;//刘海屏机型
    } else {
        btmH = 50.0f;//苹果678机型
    }
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-btmH);
        make.centerX.equalTo(self);
        make.height.equalTo(@10);
    }];
    //添加图片
    [imageNames enumerateObjectsUsingBlock:^(NSString *  _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageWithContentsOfFile:path];
        if ([UIImage imageWithContentsOfFile:path]) {
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }else{
            path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }
        [_scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScreen_Height));
            make.left.mas_equalTo(kScreen_Width * idx);
        }];
    }];//跳过button
    __block NSInteger width,height,bottom,space,left,top = 0;
    for (int i = 0; i < imageNames.count; i++) {
        UIButton *skipBtn = [UIButton new];
        [skipBtn addTarget:self action:@selector(dismissAppOperateGuideBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [skipBtn setImage:iPhoneX ? [UIImage imageNamed:@"skip_X"] : [UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
        skipBtn.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:skipBtn];
        if (iPhoneX) {
            width = 56;
            height = 30;
            top = adapt375(50);
            left = kScreen_Width - adapt375(75);
        } else if (iPhone5) {
            width = 45;
            height = 25;
            top = 15;
            left =  kScreen_Width - adapt375(60);
        } else {
            width = 55;
            height = 29;
            top = 20;
            left =  kScreen_Width - adapt375(75);
        }
        [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top).offset(top);
            make.left.equalTo(self.scrollView.mas_left).offset(i*kScreen_Width+left);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
    }
}
//结束减速滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int itemIndex = (scrollView.contentOffset.x + self.width * 0.5) / self.width;
    if (itemIndex == (imageNames.count-1)) {
        self.pageControl.hidden =YES;
    }else{
        self.pageControl.hidden =NO;
        self.pageControl.currentPage = itemIndex;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int itemIndex = (scrollView.contentOffset.x + self.width * 0.5) / self.width;
    if (itemIndex == (imageNames.count-1)) {
        self.pageControl.hidden =YES;
    }else{
        self.pageControl.hidden =NO;
        self.pageControl.currentPage = itemIndex;
    }
   
    if ((scrollView.contentOffset.x > scrollView.width * (imageNames.count - 1) + 20) && !bDismiss_) {
        bDismiss_ = YES;
        
    }
}
+ (void)showAppGuideViewComplete:(dispatch_block_t)completeBlock {
    NSString *appV = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"TM_AppVersion"];
    if (![kCurrAppVersion isEqualToString:appV]) {
        AppOperateGuideView *guideView = [[AppOperateGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        guideView.dismissBlock = completeBlock;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:guideView];
        
    }else {
        !completeBlock ? : completeBlock();
    }
}
-(void)dismissAppOperateGuideBtnDidClick{
    !_dismissBlock ? : _dismissBlock();
    if (_dismissBlock) {
        [self removeFromSuperview];
    }
}
- (YT_PageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [YT_PageControl new];
        _pageControl.indicatorType = SMPageControlCurrentIndicatorTypeGreater;
        _pageControl.indicatorMargin = 8;
        _pageControl.indicatorDiameter = 5;
        _pageControl.indicatorW = 20;
        _pageControl.pageIndicatorTintColor = TM_ColorHex(@"#F1ECEC");
        _pageControl.currentPageIndicatorTintColor = TM_ColorHex(@"#DACDCD");
        _pageControl.alignment = SMPageControlAlignmentCenter;
        [_pageControl setEnabled:NO];
     
    }
    return _pageControl;
}
@end
