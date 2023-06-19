//
//  TM_NavTitleView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_NavTitleView.h"


@implementation TM_NavTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self creatViews];
    }
    return self;
}

- (void)creatViews {

    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
    button.frame = CGRectMake(0, 0, self.width, self.bounds.size.height);
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor tm_colorWithHexString:@"FFFFFF" andAlpha:.5]]; // 方框按钮的背景色
    [button setImage:[UIImage imageNamed:@"home_search_icon_white"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"home_search_icon_white"] forState:UIControlStateHighlighted];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [button setImageEdgeInsets:UIEdgeInsetsMake(getAutoSize(5), getAutoSize(10), getAutoSize(5), button.width - getAutoSize(30))];
    button.layer.cornerRadius = 4;
    button.tag = kNavButtonTag;
    
//    UIButton *scanButton = [[UIButton alloc] initWithFrame:self.bounds];
//    scanButton.frame = CGRectMake(button.right - getAutoSize(20)- getAutoSize(13), (button.height - getAutoSize(18))/2, getAutoSize(20), getAutoSize(18));
//    [scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
//    [scanButton setImage:[UIImage imageNamed:@"tm_home_icon_scan_white"] forState:UIControlStateNormal];
//    [scanButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    [scanButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [scanButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
//    scanButton.tag = kScanButtonTag;
    
    [self addSubview:button];
//    [self addSubview:scanButton];
    UILabel *placeHolderLabel = [UILabel new];
    placeHolderLabel.text = @"输入您想要的宝贝";
    placeHolderLabel.textColor = [UIColor whiteColor];
    placeHolderLabel.tag = kNavTitleTag;
    placeHolderLabel.adjustsFontSizeToFitWidth = YES;
    placeHolderLabel.minimumScaleFactor = 0.1;
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:placeHolderLabel];
    placeHolderLabel.frame = CGRectMake(button.origin.x + 37, button.origin.y, button.size.width - 70, button.size.height);
}

// 点击搜索按钮
- (void)searchAction {
    if (_navTitleViewDelegate && [_navTitleViewDelegate respondsToSelector:@selector(clickHomeNavTitleViewBtnsWithSigns:)]) {
        [_navTitleViewDelegate clickHomeNavTitleViewBtnsWithSigns:@"1"];
    }
}

// 扫一扫
- (void)scanAction {
    if (_navTitleViewDelegate && [_navTitleViewDelegate respondsToSelector:@selector(clickHomeNavTitleViewBtnsWithSigns:)]) {
        [_navTitleViewDelegate clickHomeNavTitleViewBtnsWithSigns:@"2"];
    }
}

-(CGSize)intrinsicContentSize{
    return CGSizeMake(kScreen_Width, self.height);
}

@end
