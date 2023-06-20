//
//  TM_OrderFormView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import "TM_OrderFormView.h"
#import "TM_imgLabelButton.h"

#define kOrderFormTag 100

@interface TM_OrderFormView()
/* 我的订单 */
@property (strong, nonatomic) UIButton      *allOrderBtn;

@property (strong, nonatomic) TM_imgLabelButton     *dfkBtn;        // 代付款
@property (strong, nonatomic) TM_imgLabelButton     *dfhBtn;        // 代发货
@property (strong, nonatomic) TM_imgLabelButton     *dshBtn;        // 待收货
@property (strong, nonatomic) TM_imgLabelButton     *dpjBtn;        // 待评价
@property (strong, nonatomic) TM_imgLabelButton     *shBtn;         // 售后
@end

@implementation TM_OrderFormView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        [self createView];
    }
    return self;
}
- (void)createView {
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 22)];
    t.text = @"我的订单";
    t.textColor = [UIColor blackColor];
    t.font = [UIFont systemFontOfSize:20];
    [self addSubview:t];
    
    self.allOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allOrderBtn.frame = CGRectMake(self.width - 20 - 135, 20, 135, 22);
    self.allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.allOrderBtn setTitle:@"查看全部订单" forState:UIControlStateNormal];
    [self.allOrderBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.allOrderBtn setImage:[UIImage imageNamed:@"setting-arrow-right"] forState:UIControlStateNormal];
    
    self.allOrderBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.allOrderBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, -2, 20);
    self.allOrderBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 118, 2, 2);
    self.allOrderBtn.tag = kOrderFormTag;
    [self.allOrderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.allOrderBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(t.frame) + 15, self.width, 1)];
    line.backgroundColor = TM_SpecialGlobalColorBg;
    [self addSubview:line];
    
    NSArray *titleArr = @[@"代付款", @"代发货", @"待收货", @"待评价", @"售后"];
    NSArray *imgArr = @[@"personal_pay_icon", @"personal_send_icon", @"personal_delivery_icon", @"personal_remark_icon", @"personal_end_icon"];
    for (int i = 0; i < 5; i++) {
        TM_imgLabelButton *btn = [[TM_imgLabelButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        btn.center = CGPointMake(self.width / 10 * (i * 2 + 1), CGRectGetMaxY(line.frame) + (self.height - CGRectGetMaxY(line.frame)) * 0.5);
        btn.image = [UIImage imageNamed:imgArr[i]];
        btn.text = titleArr[i];
        btn.bottomNameFont = [UIFont systemFontOfSize:15];
        btn.color = [UIColor darkGrayColor];
        btn.tag = i + kOrderFormTag + 1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn {
    if (self.clickBlock) {
        self.clickBlock(btn.tag - kOrderFormTag);
    }
}

@end
