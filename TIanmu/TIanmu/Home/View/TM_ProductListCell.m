//
//  TM_ProductListCell.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import "TM_ProductListCell.h"

@interface TM_ProductListCell()

/* image */
@property (strong, nonatomic) UIImageView *imageView;
/* titleLabel */
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation TM_ProductListCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.width, self.height - CGRectGetMaxY(self.imageView.frame))];
    self.titleLabel.font = [UIFont systemFontOfSize:getAutoSize(14)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = TM_ColorRGB(101, 101, 101);
    [self addSubview:self.titleLabel];
}

- (void)setModel:(TM_ProductListModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.picpath]];
    self.titleLabel.text = _model.menuname;
}
@end
