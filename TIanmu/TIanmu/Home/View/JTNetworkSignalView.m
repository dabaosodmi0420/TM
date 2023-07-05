//
//  JTNetworkSignalView.m
//  ZXJTOpenAccountDemo
//
//  Created by 郑连杰 on 2020/7/24.
//  Copyright © 2020 你猜我是谁啊. All rights reserved.
//

#import "JTNetworkSignalView.h"
#import "UIColor+TM_HexToUIColor.h"

#define k_JTNetSignalShowLines 6

@interface JTNetworkSignalView(){
    
    BOOL _isShowMsgPopView;//是否显示popView
    BOOL _isShowMsg;//是否显示信息
    NSString *_msg;//显示信息
    
    BOOL _isRetime;//是否重新计时
    
    UIViewController *_vc;
    
    NSTimer *_timer;
}

@property (nonatomic, strong) CAShapeLayer *maskLayer;
/** 覆盖按钮 **/
@property (nonatomic, strong) UIButton *coverBtn;
/** msg **/
@property (nonatomic, strong) UILabel *msgL;
/** 当前网络状态 **/
@property (nonatomic, assign) NSInteger netStatus;
/** 回调 **/
@property (nonatomic, copy) JTNetSignalBlock block;
@end
@implementation JTNetworkSignalView

- (instancetype)initWithPosition:(CGPoint)position showPopView:(BOOL)showPopView vc:(UIViewController *)vc block:(JTNetSignalBlock)block{
    
    if (self = [super initWithFrame:CGRectMake(position.x, position.y, 18, 16)]) {
        _vc = vc;
        _isShowMsg = NO;
        _isShowMsgPopView = showPopView;
        _block = block;
        [self.layer addSublayer:[self drawLayer:[UIColor lightTextColor].CGColor :k_JTNetSignalShowLines]];
        if(_isShowMsgPopView){
            [self addSubview:self.coverBtn];
        }
    }
    return self;
}
- (void)jt_start{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    if (!_timer.isValid) {
        [_timer fire];        
    }
    
}
- (void)timerAction{
    if (self->_block) {
        self->_block();
    }
    
}
- (void)jt_stop{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        [self removeFromSuperview];
    }
}
//刷新
- (void)jt_reload:(NSInteger)type :(NSString *)videoBitrate{
    _netStatus = type;
    NSString *gre = @"0db14b";
    NSString *yel = @"ffff00";
    NSString *red = @"ff3d00";
    CGColorRef color = [UIColor tm_colorWithHexString:gre].CGColor;
    NSInteger showLineNums = k_JTNetSignalShowLines;
    NSString *msg = @"";
    switch (type) {
        case 0:
            color = [UIColor tm_colorWithHexString:gre].CGColor;
            showLineNums = k_JTNetSignalShowLines;
            msg = @"优良";
            break;
        case 1:
            color = [UIColor tm_colorWithHexString:gre].CGColor;
            showLineNums = k_JTNetSignalShowLines - 1;
            msg = @"很好";
            break;
        case 2:
            color = [UIColor tm_colorWithHexString:yel].CGColor;
            showLineNums = k_JTNetSignalShowLines - 2;
            msg = @"一般";
            break;
        case 3:
            color = [UIColor tm_colorWithHexString:yel].CGColor;
            showLineNums = k_JTNetSignalShowLines - 3;
            msg = @"较差";
            break;
        case 4:
            color = [UIColor tm_colorWithHexString:red].CGColor;
            showLineNums = k_JTNetSignalShowLines - 4;
            msg = @"非常差";
            break;
        case 5:
            color = [UIColor tm_colorWithHexString:red].CGColor;
            showLineNums = 1;
            msg = @"非常差";
            break;
        default:
            return;
    }
    [_maskLayer removeFromSuperlayer];
    _maskLayer = [self drawLayer:color :showLineNums];
    [self.layer addSublayer:_maskLayer];
    if (_isShowMsgPopView) {
        _msg = [NSString stringWithFormat:@" 网络状态：%@  %@",msg,videoBitrate];
        [self reloadMsg];
    }
}
- (void)reloadMsg{
    if (_isShowMsg) {
        CGFloat maxW = [UIScreen mainScreen].bounds.size.width;
        CGRect rect = [self.superview convertRect:self.frame toView:_vc.view];
        CGSize size = [_msg boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        size = CGSizeMake(size.width + 6, size.height + 10);
        CGFloat x = rect.origin.x;
        if (x + size.width > maxW) {
            x = x - (x + size.width - maxW);
        }
        self.msgL.font = [UIFont systemFontOfSize:14];
        self.msgL.text = _msg;
        self.msgL.frame = CGRectMake(x, CGRectGetMaxY(rect) + 2, size.width, size.height);
        [_vc.view addSubview:self.msgL];
        if (_isRetime) {
            [self performSelector:@selector(closePopView) withObject:nil afterDelay:8];
            _isRetime = NO;
        }
        
    }else{
        [self.msgL removeFromSuperview];
    }
}
- (void)closePopView{
    NSLog(@"关闭popView");
    [self.msgL removeFromSuperview];
    _isShowMsg = NO;
}
//点击事件
- (void)click{
    if (_isShowMsgPopView) {
        NSLog(@"点击");
        _isShowMsg = !_isShowMsg;
        _isRetime = _isShowMsg;
        if (!_isShowMsg) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closePopView) object:nil];
            
        }
        [self reloadMsg];
    }
}

//懒加载按钮
- (UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = self.bounds;
        [_coverBtn setBackgroundColor:[UIColor clearColor]];
        [_coverBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}
//懒加载消息框
- (UILabel *)msgL{
    if (!_msgL) {
        _msgL = [[UILabel alloc] init];
        _msgL.backgroundColor = [[UIColor tm_colorWithHexString:@"f2f2f2"] colorWithAlphaComponent:1];
        _msgL.textColor = [UIColor darkGrayColor];
        _msgL.textAlignment = NSTextAlignmentLeft;
        _msgL.numberOfLines = 0;
        _msgL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [_msgL addGestureRecognizer:tap];
        
        _msgL.layer.cornerRadius = 4;
        _msgL.layer.borderColor = [UIColor lightTextColor].CGColor;
        _msgL.layer.borderWidth = 0.6;
        _msgL.clipsToBounds = YES;
    }
    return _msgL;
}
//绘图
- (CAShapeLayer *)drawLayer:(CGColorRef)color :(NSInteger)showLineNums{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat lineWidth = 2.0;
    NSInteger lineNums = k_JTNetSignalShowLines;
    CGFloat padding = (width - lineWidth * lineNums) / (lineNums - 2);
    
    CGFloat minLineH = 3;
    CGFloat addH = (height - minLineH) / (lineNums - 1);
    
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = lineWidth;
    linePath.lineCapStyle = kCGLineCapRound;
    for (int i = 0; i < showLineNums; i++) {
        [linePath moveToPoint:CGPointMake(i * (lineWidth + padding) + roundf(lineWidth / 2), height)];
        [linePath addLineToPoint:CGPointMake(i * (lineWidth + padding) + roundf(lineWidth / 2), height - minLineH - i * addH)];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.path = linePath.CGPath;
    // 边框颜色
    shapeLayer.strokeColor = color;
    
    return shapeLayer;
}
@end
