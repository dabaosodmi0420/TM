//
//  TM_LoginTopView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import "TM_LoginTopView.h"
#import "TM_imgLabelButton.h"

@interface TM_LoginTopView()


/* 流量卡 优惠券 收藏 */
@property (strong, nonatomic) TM_imgLabelButton     *flowBtn;
@property (strong, nonatomic) TM_imgLabelButton     *discountBtn;
@property (strong, nonatomic) TM_imgLabelButton     *favBtn;
@end

@implementation TM_LoginTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}
- (void)createView {
    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [UIColor whiteColor];
    v1.layer.cornerRadius = 10;
    v1.clipsToBounds = YES;
    [self addSubview:v1];
    
    [self addSubview:self.headerBtn];
    [self addSubview:self.phoneNumLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = TM_SpecialGlobalColorBg;
    [self addSubview:line];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = TM_SpecialGlobalColorBg;
    [self addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = TM_SpecialGlobalColorBg;
    [self addSubview:line2];
    
    [self addSubview:self.flowBtn];
    [self addSubview:self.discountBtn];
    [self addSubview:self.favBtn];
    
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(65);
        make.width.mas_equalTo(self.bounds.size.width);
        make.height.mas_equalTo(self.bounds.size.height - 65);
    }];
    
    [self.headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((self.bounds.size.width - 96) * 0.5);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(96);
    }];
    
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerBtn.centerX);
        make.top.mas_equalTo(self.headerBtn.mas_bottom).offset(16);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(20);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.phoneNumLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
    }];

    CGFloat centerX = self.bounds.size.width / 6;
    [self.flowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line.mas_centerX).offset(-centerX * 2);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.width.height.mas_equalTo(56);
    }];
    [self.discountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line.mas_centerX);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.width.height.mas_equalTo(56);
    }];
    [self.favBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line.mas_centerX).offset(centerX * 2);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.width.height.mas_equalTo(56);
    }];

    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line.mas_centerX).offset(-centerX);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line.mas_centerX).offset(centerX);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(1);
    }];
    
}

#pragma mark - Activity

- (void)loginClick {
    NSLog(@"%@",@"登录");
    if (self.clickBlock){
        self.clickBlock(TM_LoginTopViewEnumLogin);
    }
}

- (void)flowClick {
    NSLog(@"%@",@"流量卡");
    if (self.clickBlock){
        self.clickBlock(TM_LoginTopViewEnumFlow);
    }
}

- (void)discountClick {
    NSLog(@"%@",@"优惠券");
    if (self.clickBlock){
        self.clickBlock(TM_LoginTopViewEnumDiscount);
    }
}

- (void)favClick {
    NSLog(@"%@",@"我的收藏");
    if (self.clickBlock){
        self.clickBlock(TM_LoginTopViewEnumFav);
    }
}

#pragma mark - getting
- (UIButton *)headerBtn {
    if(!_headerBtn) {
        _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerBtn setImage:[UIImage imageNamed:@"denglu"] forState:UIControlStateNormal];
        [_headerBtn setImage:[UIImage imageNamed:@"denglu"] forState:UIControlStateHighlighted];
        _headerBtn.backgroundColor = TM_SpecialGlobalColor;
        _headerBtn.layer.cornerRadius = 48;
        _headerBtn.layer.borderWidth = 1;
        _headerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _headerBtn.clipsToBounds = YES;
        [_headerBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerBtn;
}
- (UILabel *)phoneNumLabel{
    if(!_phoneNumLabel) {
        _phoneNumLabel = [UILabel new];
        _phoneNumLabel.text = @"请登录";
        _phoneNumLabel.textColor = [UIColor blackColor];
        _phoneNumLabel.font = [UIFont systemFontOfSize:19];
        _phoneNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneNumLabel;
}

- (TM_imgLabelButton *)flowBtn {
    if (!_flowBtn) {
        _flowBtn = [[TM_imgLabelButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        _flowBtn.image = [UIImage imageNamed:@"shoucang"];
        _flowBtn.text = @"流量卡";
        _flowBtn.bottomNameFont = [UIFont systemFontOfSize:16];
        _flowBtn.color = [UIColor darkGrayColor];
        [_flowBtn addTarget:self action:@selector(flowClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flowBtn;
}

- (TM_imgLabelButton *)discountBtn {
    if (!_discountBtn) {
        _discountBtn = [[TM_imgLabelButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        _discountBtn.image = [UIImage imageNamed:@"shoucang"];
        _discountBtn.text = @"优惠券";
        _discountBtn.bottomNameFont = [UIFont systemFontOfSize:16];
        _discountBtn.color = [UIColor darkGrayColor];
        [_discountBtn addTarget:self action:@selector(discountClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _discountBtn;
}

- (TM_imgLabelButton *)favBtn {
    if (!_favBtn) {
        _favBtn = [[TM_imgLabelButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        _favBtn.image = [UIImage imageNamed:@"shoucang"];
        _favBtn.text = @"我的收藏";
        _favBtn.bottomNameFont = [UIFont systemFontOfSize:16];
        _favBtn.color = [UIColor darkGrayColor];
        [_favBtn addTarget:self action:@selector(favClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favBtn;
}
@end
