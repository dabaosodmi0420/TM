//
//  UIView+TM_View.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/26.
//

#import "UIView+TM_View.h"

@interface TM_TextField : UITextField

@end

@implementation TM_TextField

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 30, 2);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 30, 2);
}

@end

@implementation UIView (TM_View)
#pragma mark - 创建控件
+ (UIButton *)createButton:(CGRect)frame title:(NSString *)title titleColoe:(UIColor *)titleColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize sel:(SEL)sel target:(id)target{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btn.titleEdgeInsets = UIEdgeInsetsZero;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor: titleColor forState:UIControlStateNormal];
    [btn setTitleColor: titleColor forState:UIControlStateHighlighted];
    if (selectedColor) {
        [btn setTitleColor: selectedColor forState:UIControlStateSelected];
    }
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize placeholder:(NSString *)placeholder isSecure:(BOOL)isSecure delegate:(id)delegate {
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.delegate = delegate;
    tf.font = [UIFont systemFontOfSize:fontSize];
    tf.textColor = [UIColor blackColor];
    tf.placeholder = placeholder;
    [tf setSecureTextEntry:isSecure];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:TM_ColorRGB(174, 174, 174),
                    NSFontAttributeName:tf.font
            }];
    tf.attributedPlaceholder = attrString;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, tf.height - 1, tf.width, 1)];
    lineView.backgroundColor = TM_ColorRGB(174, 174, 174);
    [tf addSubview:lineView];
    return tf;
}

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize placeholder:(NSString *)placeholder isSecure:(BOOL)isSecure delegate:(id)delegate leftImageName:(NSString *)leftImageName isShowBottomLine:(BOOL)isShowBottomLine{
    TM_TextField *tf = [[TM_TextField alloc] initWithFrame:frame];
    tf.delegate = delegate;
    tf.font = [UIFont systemFontOfSize:fontSize];
    tf.textColor = [UIColor blackColor];
    tf.placeholder = placeholder;
    [tf setSecureTextEntry:isSecure];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:TM_ColorRGB(174, 174, 174),
                    NSFontAttributeName:tf.font
            }];
    tf.attributedPlaceholder = attrString;
    
    if (leftImageName && leftImageName.length > 0) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, tf.height - 4, tf.height - 4)];
        img.image = [UIImage imageNamed:leftImageName];
        img.contentMode = UIViewContentModeScaleAspectFit;
        tf.leftView = img;
        tf.leftViewMode = UITextFieldViewModeAlways;
    }
    
    if (isShowBottomLine) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, tf.height - 1, tf.width, 1)];
        lineView.backgroundColor = TM_ColorRGB(174, 174, 174);
        [tf addSubview:lineView];
    }
    return tf;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize color:(UIColor *)color{
    UILabel *t = [[UILabel alloc] initWithFrame:frame];
    t.text = title;
    t.textColor = color;
    t.font = [UIFont systemFontOfSize:fontSize];
    t.adjustsFontSizeToFitWidth = YES;
    return t;
}

+ (void)setHorGradualChangingColor:(UIView *)view colorArr:(NSArray *)colorArr{
    [self setGradualChangingColor:view colorArr:colorArr isHor:YES];
}
+ (void)setVerGradualChangingColor:(UIView *)view colorArr:(NSArray *)colorArr {
    [self setGradualChangingColor:view colorArr:colorArr isHor:NO];
}

+ (void)setGradualChangingColor:(UIView *)view colorArr:(NSArray *)colorArr isHor:(BOOL)isHor{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    NSMutableArray *temps = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<colorArr.count; i++) {
        UIColor *tempColor = colorArr[i];
        [temps addObject:(__bridge id)tempColor.CGColor];
    }
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = temps;
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    if (isHor) {
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
    }else {
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
    }
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    [view.layer addSublayer:gradientLayer];
}
- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}
- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderLineW:(CGFloat)borderLineW {
    [self setCornerRadius:radius];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderLineW;
}

- (void)setCornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
