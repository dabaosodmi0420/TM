//
//  TM_imgLabelButton.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_imgLabelButton.h"

#define kLableMaxHeight     20
#define kLableHeightRatio   .3
#define kImageCapRatio      .1
@interface TM_imgLabelButton () {
    UIImageView *imageView_;
    UILabel     *label_;
    UIView      *badgeView;    //红点视图
    CGFloat      fLabelHeight_;    // label的高
    BOOL bImageView_Reset_;  //image是否进行修改
}
@end

@implementation TM_imgLabelButton
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        bImageView_Reset_ = YES;
        imageView_ = [UIImageView tm_createImageViewWithFrame:CGRectZero Image:nil];
        label_ = [UILabel tm_createLable:CGRectZero
                                     Text:nil
                              TextAliType:NSTextAlignmentLeft
                                     Font:nil
                                    Color:nil
                                BackColor:nil
                adjustsFontSizeToFitWidth:NO];
        self.imageV = imageView_;
        [self addSubview:imageView_];
        [self addSubview:label_];
        
        self.clipsToBounds = YES;
        
        CGFloat height = self.frame.size.height * kLableHeightRatio;
        fLabelHeight_ = MIN(height, kLableMaxHeight);
        self.fGap = fLabelHeight_/2;
        
        self.text = @" ";
        self.image = [self imageWithColor:[UIColor clearColor]];
        
    }
    return self;
}

//显示按钮红点
- (void)showRedDotOnBtn:(UIColor *)dotColor {
    
    if ([self.subviews containsObject:badgeView]) {
        [badgeView removeFromSuperview];
    }
    
    badgeView = [[UIView alloc]init];
    badgeView.backgroundColor = dotColor;//确定小红点的位置
    badgeView.frame = CGRectMake(CGRectGetMaxX(imageView_.bounds)+18, CGRectGetMinY(imageView_.bounds)+2,6, 6);
    badgeView.layer.cornerRadius = badgeView.height/2.0;
    [badgeView.layer setShouldRasterize:YES];
    [badgeView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    [self addSubview:badgeView];
}

//隐藏按钮红点
- (void)hiddenRedDotOnBtn {
    if ([self.subviews containsObject:badgeView]) {
        [badgeView removeFromSuperview];
    }
}

//重设frame
- (void)resetImageFarme:(CGRect)frame {
    imageView_.frame = frame;
    bImageView_Reset_ = NO;
}

//重设label的frame
- (void)resetLabelFrame:(CGRect)frame {
    label_.frame = frame;
    bImageView_Reset_ = NO;
}

#pragma mark setter
- (void)setImage:(UIImage *)image {
    _image = image;
    if (_text) {
        label_.adjustsFontSizeToFitWidth = YES;
        label_.minimumScaleFactor = 0.1;
        if (bImageView_Reset_) {
            label_.frame = CGRectMake(0, self.height-fLabelHeight_, self.width, fLabelHeight_);
            CGFloat x = MIN(self.width, self.height-fLabelHeight_);
            imageView_.frame = CGRectMake(0, 0, x*(1-2*kImageCapRatio), x*(1-2*kImageCapRatio));
        }
        CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        center.y -= _fGap;
        [imageView_ setCenter:center];
    } else {
        imageView_.frame = self.frame;
    }
    
    [imageView_ setImage:_image];
}

- (void)addimageShadow {
    imageView_ = (UIImageView *)[UIView tm_setCornerRadius:getAutoSize(75.0/2.0f) withBorderColor:nil WithView:imageView_];
    imageView_ = (UIImageView *)[UIView tm_setBorderWidth:4.0f withBorderColor:[UIColor whiteColor] WithView:imageView_];
}

- (void)setText:(NSString *)text {
    _text = text;
    
    if (_image) {
        label_.adjustsFontSizeToFitWidth = YES;
        label_.minimumScaleFactor = 0.1;
        if (bImageView_Reset_) {
            label_.frame = CGRectMake(0, self.height-fLabelHeight_, self.width, fLabelHeight_);
            CGFloat x = MIN(self.width, self.height-fLabelHeight_);
            imageView_.frame = CGRectMake(0, 0, x*(1-2*kImageCapRatio), x*(1-2*kImageCapRatio));
        }
        CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        center.y -= _fGap;
        [imageView_ setCenter:center];
    } else {
        label_.frame = self.frame;
    }
    label_.textAlignment = NSTextAlignmentCenter;
    label_.textColor = _color;
    label_.font = _bottomNameFont;

    [label_ setText:text];
}

- (void)setBottomNameFont:(UIFont *)bottomNameFont {
    _bottomNameFont = bottomNameFont;
    label_.font = bottomNameFont;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    label_.textColor = color;
}

- (void)setBClip:(BOOL)bClip {
    _bClip = bClip;
    [imageView_ setImage:_image];
    if (bClip) {
        imageView_ = (UIImageView *)[UIView tm_setCornerRadius:imageView_.width/2 withBorderColor:nil WithView:imageView_];
    } else {
        imageView_ = (UIImageView *)[UIView tm_setCornerRadius:0 withBorderColor:nil WithView:imageView_];
    }
    imageView_.contentMode = UIViewContentModeScaleAspectFill;
//    imageView_.layer.borderWidth = 1;
//    imageView_.layer.borderColor = [UIColor clearColor].CGColor;
//    imageView_.layer.cornerRadius = imageView_.width / 2.0;
//    imageView_.layer.masksToBounds = YES;
}

- (void)setFImgBorderWidth:(CGFloat)fImgBorderWidth {
    _fImgBorderWidth = fImgBorderWidth;
    imageView_ = (UIImageView *)[UIView tm_setBorderWidth:fImgBorderWidth withBorderColor:[UIColor whiteColor] WithView:imageView_];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;

    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = imageView_.frame;
    shadowLayer.backgroundColor = _shadowColor.CGColor;
    shadowLayer.shadowOffset = CGSizeMake(0, 0);
    shadowLayer.shadowRadius = _fShadowWidth;
    shadowLayer.shadowColor = _shadowColor.CGColor; //设置阴影的颜色为黑色
    shadowLayer.shadowOpacity = 1.0; //设置阴影的不透明度
    shadowLayer.cornerRadius = imageView_.width/2;

    [self.layer addSublayer:shadowLayer];
    [self bringSubviewToFront:imageView_];
}

- (void)setFShadowWidth:(CGFloat)fShadowWidth {
    _fShadowWidth = fShadowWidth;
    self.shadowColor = _shadowColor;
}
- (UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
