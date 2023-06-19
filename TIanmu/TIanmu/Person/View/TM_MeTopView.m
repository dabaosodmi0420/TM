//
//  TM_MeTopView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import "TM_MeTopView.h"
#import "TM_LoginTopView.h"
#import "TM_OrderFormView.h"
#import "TM_imgLabelButton.h"

@interface TM_MeTopView()

/* 上面登录View */
@property (strong, nonatomic) TM_LoginTopView       *loginView;
/* 订单View */
@property (strong, nonatomic) TM_OrderFormView      *orderFormView;


@end

@implementation TM_MeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UIView *v1 = [UIView new];
    v1.backgroundColor = TM_SpecialGlobalColor;
    [self addSubview:v1];
    UIView *v2 = [UIView new];
    v2.backgroundColor = TM_SpecialGlobalColorBg;
    [self addSubview:v2];
    
    [self addSubview:self.loginView];
    [self addSubview:self.orderFormView];
    
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(167);
    }];
    
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(v1.mas_bottom).offset(0);
    }];
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-11);
        make.height.mas_equalTo(232);
    }];
    [self.orderFormView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.top.mas_equalTo(self.loginView.mas_bottom).offset(30);
        make.height.mas_equalTo(145);
    }];
}
#pragma mark - Activity

#pragma mark - gettting

- (TM_LoginTopView *)loginView{
    if(!_loginView) {
        _loginView = [[TM_LoginTopView alloc] initWithFrame:CGRectMake(0, 0, self.width - 22, 232)];
        _loginView.clickBlock = ^(TM_LoginTopViewEnum type) {
            NSLog(@"%@",@(type));
        };
    }
    return _loginView;
}

- (TM_OrderFormView *)orderFormView {
    if(!_orderFormView){
        _orderFormView = [[TM_OrderFormView alloc] initWithFrame:CGRectMake(0, 0, self.width - 22, 145)];
        _orderFormView.clickBlock = ^(TM_OrderFormViewEnum type) {
            NSLog(@"%@",@(type));
        };
    }
    return _orderFormView;
}

@end
