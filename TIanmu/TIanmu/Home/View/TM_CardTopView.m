//
//  TM_CardTopView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/26.
//

#import "TM_CardTopView.h"

@interface TM_CardTopView()

/* model */
@property (strong, nonatomic) TM_DataCardDetalInfoModel *model;
@end

@implementation TM_CardTopView

- (instancetype)initWithFrame:(CGRect)frame model:(TM_DataCardDetalInfoModel *)model{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        self.backgroundColor = [UIColor whiteColor];
        [self setCornerRadius:20];
        [self createView:frame];
        
    }
    return self;
}
- (void)createView:(CGRect)frame {
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImg.image = [UIImage imageNamed:@"card_topBackground"];
    bgImg.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:bgImg];
    // 顶部logo
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(50, 25, 90, 90)];
    logoImg.image = [UIImage imageNamed:@"logo"];
    logoImg.layer.cornerRadius = logoImg.width * 0.5;
    logoImg.clipsToBounds = YES;
    logoImg.contentMode = UIViewContentModeScaleToFill;
    logoImg.backgroundColor = [UIColor clearColor];
    [self addSubview:logoImg];
    
    // 设备编号
    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(logoImg.maxX + 25, logoImg.y + 10, 0, 25) title:self.model.iccid fontSize:19 color:[UIColor whiteColor]];
    [label1 sizeToFit];
    [self addSubview:label1];
    // 余额
    UILabel *label4 = [UIView createLabelWithFrame:CGRectMake(label1.x, label1.maxY + 25, 0, 25) title:[NSString stringWithFormat:@"余额:￥%.2f元", [self.model.balance doubleValue]] fontSize:18 color:[UIColor whiteColor]];
    [label4 sizeToFit];
    [self addSubview:label4];
    
    NSString *status = @"未待激活";
    if ([self.model.is_realname isEqualToString:@"1"]) {
        status = @"正常";
    }else if ([self.model.is_realname isEqualToString:@"2"] ) {
        status = @"停机";
    }else if ([self.model.is_realname isEqualToString:@"3"] ) {
        status = @"拆机";
    }else if ([self.model.is_realname isEqualToString:@"4"] ) {
        status = @"违章停机";
    }
    
    
    NSString *realStatus = @"未实名";
    if ([self.model.is_realname isEqualToString:@"1"]) {
        realStatus = @"审请中";
    }else if ([self.model.is_realname isEqualToString:@"2"] ) {
        realStatus = @"已实名";
    }else if ([self.model.is_realname isEqualToString:@"3"] ) {
        realStatus = @"恶意实名";
    }
    
    NSArray *title1 = @[status, realStatus, self.model.package_name];
    NSArray *title2 = @[@"当前状态", @"实名状态", @"套餐名称"];
    for (int i = 0; i < title2.count; i++) {
        CGFloat padding = 15;
        CGFloat w = (self.width - 20 - (title2.count * 2) * padding) / 3;
        CGFloat x = 10 + (w + 2 * padding) * i + padding;
        CGFloat y = logoImg.maxY + 30;
        UILabel *l1 = [UIView createLabelWithFrame:CGRectMake(x, y, w, 30) title:title1[i] fontSize:20 color:[UIColor whiteColor]];
        l1.textAlignment = NSTextAlignmentCenter;
        l1.adjustsFontSizeToFitWidth = YES;
        [self addSubview:l1];
        
        UILabel *l2 = [UIView createLabelWithFrame:CGRectMake(x, l1.maxY + 10, w, 30) title:title2[i] fontSize:16 color:[UIColor whiteColor]];
        l2.textAlignment = NSTextAlignmentCenter;
        l2.adjustsFontSizeToFitWidth = YES;
        [self addSubview:l2];
        
        if (i != title2.count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(l1.maxX + padding, l1.y + 6, 0.5, l2.maxY - 10 - l1.y - 6)];
            line.backgroundColor = TM_SpecialGlobalColorBg;
            [self addSubview:line];
        }
    }
    
}

@end
