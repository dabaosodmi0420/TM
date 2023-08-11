//
//  JT_TopSegmentMenuView.m
//

#import "JT_TopSegmentMenuView.h"

@interface JT_TopSegmentMenuView () <UIScrollViewDelegate>{
    UIView *_lineBottom;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *lastSelBtn;
@property (nonatomic, strong) UIView *botLineView;
@property (nonatomic, strong) NSMutableArray *btnDataArr;

@end

@implementation JT_TopSegmentMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnDataArr = [NSMutableArray arrayWithCapacity:0];
        self.btnTextFont = [UIFont systemFontOfSize:13];
        self.btnTitleNormalColor = TM_ColorHex(@"#5E6678");
        self.btnTitleSeletColor = TM_ColorHex(@"#FF5A00");
        self.btnBackNormalColor = TM_ColorHex(@"#F1F2F5");
        self.btnBackSeletColor = TM_ColorHex(@"#FCEFE7");
        self.btnWidth = 70.0;
        self.btnHeight = 30.0;
        self.btnJianGe = 10.0;
        self.btnTitleTextHeight = 20.0;
        [self addSubview:self.scrollView];
        [self addSubview:self.botLineView];
    }
    return self;
}
- (void)makeSegmentUIWithSegDataArr:(NSArray<NSString *> *)dataArr selectIndex:(NSInteger)selectIndex selectSegName:(NSString *)selectSegName {
    
    NSArray *titleArr = dataArr;
    CGFloat scrSumWidth = self.isAverageWidth ? self.width : [self getSumTitleWith:titleArr];
    CGFloat sums = scrSumWidth > self.width ? scrSumWidth : self.width;
    self.scrollView.contentSize = CGSizeMake(sums, self.scrollView.height);
    
    // 创建按钮
    CGFloat sumX = self.btnJianGe;
    for (int i = 0; i < titleArr.count; i ++) {
        NSString *goupName = titleArr[i];
        CGFloat btnWidth = self.isAverageWidth ? (self.width - self.btnJianGe * (titleArr.count + 1)) / titleArr.count : self.btnWidth;
        if (!self.isAverageWidth) {
            CGFloat titleWidth = [self textWidths:goupName heights:self.btnTitleTextHeight fonts:self.btnTextFont];
            if (titleWidth > self.btnWidth) {
                btnWidth = titleWidth;
            }
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(sumX, (self.height - self.btnHeight)/2.0, btnWidth, self.btnHeight);
        button.tag = 730+i;
        [button setTitle:goupName forState:UIControlStateNormal];
        button.titleLabel.font = self.btnTextFont;
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:self.btnTitleNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.btnTitleSeletColor forState:UIControlStateSelected];
        if (self.isCorner) {
            button.layer.cornerRadius = self.btnHeight/2.0;
            button.layer.masksToBounds = YES;
        }
        if (selectIndex != -1) {
            if (selectIndex == i) {
                button.selected = YES;
                [button setBackgroundColor:self.btnBackSeletColor];
                self.lastSelBtn = button;
            }else {
                button.selected = NO;
                [button setBackgroundColor:self.btnBackNormalColor];
            }
        }else {
            if ([goupName isEqualToString:selectSegName]) {
                button.selected = YES;
                [button setBackgroundColor:self.btnBackSeletColor];
                self.lastSelBtn = button;
            }else{
                button.selected = NO;
                [button setBackgroundColor:self.btnBackNormalColor];
            }
        }
        [button addTarget:self action:@selector(clickGroupNameBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.btnDataArr addObject:button];
        sumX += (btnWidth + self.btnJianGe);
    }
    
    if (self.btnDataArr.count > 0) {
        UIView *lineBottom = [UIView new];
        [self addSubview:lineBottom];
        _lineBottom = lineBottom;
        UIButton *firstBtn = self.btnDataArr.firstObject;
        [self clickGroupNameBtn:firstBtn];
    }
}

-(void)reloadColor:(NSInteger)selectIndex{
    self.btnTitleNormalColor = TM_ColorHex(@"#5E6678");
    self.btnTitleSeletColor = TM_ColorHex(@"#FF5A00");
    self.btnBackNormalColor = TM_ColorHex(@"#F1F2F5");
    self.btnBackSeletColor = TM_ColorHex(@"#FCEFE7");
    for (UIButton *btn in self.btnDataArr) {
        btn.selected = NO;
        [btn setBackgroundColor:self.btnBackNormalColor];
    }
    if (selectIndex != -1) {
        UIButton *button = self.btnDataArr[selectIndex];
        button.selected = YES;
        [button setTitleColor:self.btnTitleNormalColor forState:UIControlStateNormal];
               [button setTitleColor:self.btnTitleSeletColor forState:UIControlStateSelected];
        [button setBackgroundColor:self.btnBackSeletColor];
        self.lastSelBtn = button;
    }
    
}

- (void)setSelectIndex:(NSInteger)selectIndex selectSegName:(NSString *)selectSegName {
   
    for (UIButton *btn in self.btnDataArr) {
        btn.selected = NO;
        [btn setBackgroundColor:self.btnBackNormalColor];
    }
    if (selectIndex != -1) {
        UIButton *button = self.btnDataArr[selectIndex];
        button.selected = YES;
        [button setBackgroundColor:self.btnBackSeletColor];
        self.lastSelBtn = button;
    }else {
        for (NSInteger i=0; i<self.btnDataArr.count; i++) {
            UIButton *button = self.btnDataArr[i];
            if ([button.titleLabel.text isEqualToString:selectSegName]) {
                button.selected = YES;
                [button setBackgroundColor:self.btnBackSeletColor];
                self.lastSelBtn = button;
                break;
            }
        }
    }
    
    CGFloat btnX = self.lastSelBtn.x;
    CGFloat btnW = self.lastSelBtn.width;
    if (btnX + btnW > kScreen_Width/2.0) {
        [self.scrollView setContentOffset:CGPointMake(btnX - kScreen_Width/2.0 + btnW/2.0, 0) animated:YES];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (self.clickGroupBtnBlock) {
        self.clickGroupBtnBlock(self.lastSelBtn.titleLabel.text, self.lastSelBtn.tag - 730);
    }
}

#pragma mark - scrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= (scrollView.contentSize.width - kScreen_Width)) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - kScreen_Width, 0) animated:NO];
    }
    if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark - 点击事件
- (void)clickGroupNameBtn:(UIButton *)btn{
    CGFloat btnX = btn.x;
    CGFloat btnW = btn.width;
    if (btnX + btnW > kScreen_Width/2.0) {
        [self.scrollView setContentOffset:CGPointMake(btnX - kScreen_Width/2.0 + btn.width/2.0, 0) animated:YES];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    self.lastSelBtn.selected = NO;
    [self.lastSelBtn setBackgroundColor:self.btnBackNormalColor];
    btn.selected = YES;
    [btn setBackgroundColor:self.btnBackSeletColor];
    self.lastSelBtn = btn;
    if (self.clickGroupBtnBlock) {
        self.clickGroupBtnBlock(btn.titleLabel.text, btn.tag - 730);
    }
    _lineBottom.frame = CGRectMake(btn.x, self.height - 3, btn.width, 3);
    _lineBottom.backgroundColor = self.btnTitleSeletColor;
}

#pragma mark - 计算文字总宽度
- (CGFloat)getSumTitleWith:(NSArray *)titleArr {
    CGFloat sumK = 0.0;
    for (NSString *titles in titleArr) {
        CGFloat titleWidth = [self textWidths:titles heights:self.btnTitleTextHeight fonts:self.btnTextFont];
        if (titleWidth > self.btnWidth) {
            sumK += titleWidth;
        }else {
            sumK += self.btnWidth;
        }
    }
    return sumK + (titleArr.count + 1) * self.btnJianGe;
}

#pragma mark - 计算文字宽度
- (CGFloat)textWidths:(NSString *)strs heights:(CGFloat)heights fonts:(UIFont *)fonts{
    CGSize size = CGSizeZero;
    if ([strs length] <= 0 || !strs) {
        return 0;
    }
    size = [strs boundingRectWithSize:CGSizeMake(MAXFLOAT, heights) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fonts} context:nil].size;
    CGFloat widths = size.width;
    return widths;
}

#pragma mark - setter
- (void)setBtnTextFont:(UIFont *)btnTextFont {
    _btnTextFont = btnTextFont;
}

- (void)setBtnTitleNormalColor:(UIColor *)btnTitleNormalColor {
    _btnTitleNormalColor = btnTitleNormalColor;
}

- (void)setBtnTitleSeletColor:(UIColor *)btnTitleSeletColor {
    _btnTitleSeletColor = btnTitleSeletColor;
}

- (void)setBtnBackNormalColor:(UIColor *)btnBackNormalColor {
    _btnBackNormalColor = btnBackNormalColor;
}

- (void)setBtnBackSeletColor:(UIColor *)btnBackSeletColor {
    _btnBackSeletColor = btnBackSeletColor;
}

- (void)setBtnWidth:(CGFloat)btnWidth {
    _btnWidth = btnWidth;
}

- (void)setBtnHeight:(CGFloat)btnHeight {
    _btnHeight = btnHeight;
}

- (void)setBtnJianGe:(CGFloat)btnJianGe {
    _btnJianGe = btnJianGe;
}

- (void)setBtnTitleTextHeight:(CGFloat)btnTitleTextHeight {
    _btnTitleTextHeight = btnTitleTextHeight;
}

- (void)setBotLineIsHidden:(BOOL)botLineIsHidden {
    _botLineIsHidden = botLineIsHidden;
    self.botLineView.hidden = botLineIsHidden;
}

#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.height)];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)botLineView {
    if (!_botLineView) {
        _botLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, kScreen_Width, 0.5)];
        _botLineView.backgroundColor = TM_ColorHex(@"#E4E7EC");
        _botLineView.hidden = YES;
    }
    return _botLineView;
}

@end

