//
//  AppOperateGuideView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/28.
//

#import "AppOperateGuideView.h"
#import "YT_PageControl.h"
#import "TM_AttributeTextView.h"
#import "JTDefinitionTextView.h"

@interface AppOperateGuideView ()<UIScrollViewDelegate, TM_AttributeTextViewDelegate>{
    BOOL    bDismiss_;         //是否已经执行过一次
    NSArray *imageNames;
}
@property (nonatomic ,copy) dispatch_block_t dismissBlock;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic, strong) YT_PageControl *pageControl;
/* 协议 */
@property (strong, nonatomic) TM_AttributeTextView  *attributeTV;

@end

@implementation AppOperateGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView:frame];
    }
    return self;
}
- (void)createView:(CGRect)frame {
    imageNames = @[@"operateGuide0", @"operateGuide1", @"operateGuide2"];
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
    }];
    
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
+ (void)showAppGuideView:(UIView *)superView complete:(dispatch_block_t)completeBlock {
    if (kCurrAppVersion ) {
        //
        AppOperateGuideView *guideView = [[AppOperateGuideView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        [superView addSubview:guideView];
        guideView.dismissBlock = completeBlock;
        
//        TM_AttributeTextView *attributeTV = [[TM_AttributeTextView alloc] initWithFrame:CGRectMake(self.agreeBtn.maxX + 10, self.agreeBtn.y , contentView.width - self.agreeBtn.maxX - 10 - getAutoWidth(92), 30)];
//        attributeTV.text = @"欢迎使用天目e生活APP，在您使用前请仔细阅读《天目e生活用户协议》和《隐私协议》,天目e生活将严格遵守您同意的各项条款使用您的信息,以便为您提供更好的服务。点击“同意”意味着您自愿遵守《天目e生活用户协议》和《隐私协议》";
//        attributeTV.font = [UIFont systemFontOfSize:14];
//        attributeTV.textColor = TM_ColorHex(@"#888888");
//        attributeTV.linkColor = TM_SpecialGlobalColor;
//        attributeTV.linkTextArr = @[@"《天目e生活用户协议》", @"《隐私协议》"];
//        attributeTV.linkTextSchemeArr = @[@"userProtocal", @"privateProtocal"];
//        attributeTV.delegate = self;
//        attributeTV.isSizeToFit = YES;
//        [contentView addSubview:attributeTV];
//        self.attributeTV = attributeTV;
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
