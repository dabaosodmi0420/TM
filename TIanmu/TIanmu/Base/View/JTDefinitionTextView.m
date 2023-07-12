//
//  JTDefinitionTextView.m
//  IOS_108
//
//  Created by Apple on 2017/12/6.
//  Copyright © 2017年 csctest. All rights reserved.
//

#import "JTDefinitionTextView.h"
#define K_JTDefinitionTextView_ButtonTag 100

HandlerClick handlerClick;

@implementation JTDefinitionTextView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
+ (void)jt_showWithTitle:(NSString *)title Text:(NSString *)text type:(JTAlertType)type actionTextArr:(NSArray *)actionTextArr handler:(HandlerClick)handler{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        handlerClick = handler;
        JTDefinitionTextView *definitionView = [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
        definitionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:definitionView];
        
        //顶部图片
        NSString *imageName = @"";
        BOOL isHaveTopImage = NO;
        switch (type) {
            case JTAlertTypeNot:
                break;
            case JTAlertTypeSuccess:{
                imageName = @"JTAlertViewSuccess";
                isHaveTopImage = YES;
            }
                break;
            case JTAlertTypeError:{
                imageName = @"JTAlertViewError";
                isHaveTopImage = YES;
            }
                break;
            case JTAlertTypeGanTanHao:{
                imageName = @"JTAlertViewGanTanHao";
                isHaveTopImage = YES;
            }
                break;
            case JTAlertTypeWenHao:{
                imageName = @"JTAlertViewWenHao";
                isHaveTopImage = YES;
            }
                break;
            default:
                break;
        }
        
        // 顶部图片预览高度
        CGFloat topImageGap = 0;
        CGFloat rate = 0.3;
        CGFloat topImgView_w = 436 * rate;
        CGFloat topImgView_h = 310 * rate;
        if (isHaveTopImage) {
            topImageGap = topImgView_h * 0.5 + 10;
        }
        
        BOOL isHaveTitle = NO;
        if (title != nil && ![title isEqual:[NSNull null]] && title.length != 0 && ![title isEqualToString:@"(null)"]) {
            isHaveTitle = YES;
        }
        CGFloat titleH = isHaveTitle ? 50 : 10;
        CGFloat blankView_X = 25;
        CGFloat blankView_W = definitionView.frame.size.width - 2 * blankView_X;
        CGFloat blankView_H = 200 + titleH + topImageGap;
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(blankView_X, (definitionView.frame.size.height - blankView_H) * 0.5, blankView_W, blankView_H)];
        blankView.backgroundColor = [UIColor whiteColor];
        blankView.layer.cornerRadius = 5;
        blankView.clipsToBounds = YES;
        [definitionView addSubview:blankView];
        
        if (isHaveTopImage) {
            UIImageView * topImgView = [[UIImageView alloc] initWithFrame:CGRectMake((TM_iPhoneScreenPhysicalWidth - topImgView_w) * 0.5, blankView.frame.origin.y - topImgView_h * 0.5, topImgView_w, topImgView_h)];
            topImgView.contentMode = UIViewContentModeScaleAspectFit;
            topImgView.image = [UIImage imageNamed:imageName];
            [definitionView addSubview:topImgView];
        }
        
        if (isHaveTitle) {
            CGFloat y = topImageGap == 0 ? (titleH - 30) * 0.5 : topImgView_h * 0.5 + 4;
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(30, y, blankView_W - 60, 30)];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.text = title;
            titleL.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
            titleL.font = [UIFont systemFontOfSize:19];
            [blankView addSubview:titleL];
            
            [blankView addSubview:[JTDefinitionTextView createViewCGRect:CGRectMake(40, CGRectGetMaxY(titleL.frame) + 14, blankView_W - 80, 0.5)]];
        }
        
        CGFloat actionH = 40;
        CGFloat textView_X = 30;
        CGFloat textView_W = blankView.frame.size.width - 2 * textView_X;
        CGFloat textView_Top = 4 + titleH + topImageGap;
        CGFloat textView_H = blankView_H - actionH - textView_Top - 10;
        UIFont *font = [UIFont systemFontOfSize:16];
        
        CGSize size = [text boundingRectWithSize:CGSizeMake(textView_W, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
        if (size.height + 30 < textView_H) {
            CGRect frame = blankView.frame;
            frame.size.height -= (textView_H - size.height - 30);
            blankView.frame = frame;
            textView_H = size.height + 30;
        }
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(textView_X, textView_Top, textView_W,textView_H)];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        textView.editable = NO;
        textView.selectable = NO;
        textView.font = font;
        textView.text = text;
        [blankView addSubview:textView];
        
        CGFloat actionY = blankView.frame.size.height - actionH;
        UIColor *normalColor = [UIColor colorWithRed:38/255.0 green:197/255.0 blue:223/255.0 alpha:1];
        UIColor *cancelColor = [UIColor colorWithRed:38/255.0 green:197/255.0 blue:223/255.0 alpha:1];
        if (actionTextArr.count == 1) {
            [blankView addSubview:[JTDefinitionTextView createButtonCGRect:CGRectMake(20 , actionY + 5, blankView_W - 40, 30) title:actionTextArr[0] titleColor:normalColor tag:K_JTDefinitionTextView_ButtonTag]];
        }else if(actionTextArr.count > 1){
            for (NSInteger i = 0; i < 2; i++) {
                CGRect rect = CGRectMake(10 + i * blankView_W * 0.5, actionY + 5, blankView_W * 0.5 - 20, 30);
                [blankView addSubview:[JTDefinitionTextView createButtonCGRect:rect title:actionTextArr[i] titleColor: i == 0 ? cancelColor : normalColor tag:K_JTDefinitionTextView_ButtonTag + i]];
            }
            [blankView addSubview:[JTDefinitionTextView createViewCGRect:CGRectMake(blankView_W * 0.5, actionY, 0.5, 40)]];
        }else{
            [blankView addSubview:[JTDefinitionTextView createButtonCGRect:CGRectMake(20 , actionY + 5, blankView_W - 40, 30) title:@"确 定" titleColor:normalColor tag:K_JTDefinitionTextView_ButtonTag]];
        }
        [blankView addSubview:[JTDefinitionTextView createViewCGRect:CGRectMake(0, actionY, blankView_W, 0.5)]];
    });
}
+ (UIButton *)createButtonCGRect:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
//    button.layer.borderColor = [UIColor redColor].CGColor;
//    button.layer.borderWidth = 0.5;
//    button.layer.cornerRadius = 5;
    button.tag = tag;
    button.frame = rect;
    [button addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIView *)createViewCGRect:(CGRect)rect{
    UIView *lineView = [[UIView alloc]initWithFrame:rect];
    lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    return lineView;
}
+ (void)closeClick:(UIButton *)btn{
    if (handlerClick) {
        handlerClick(btn.tag - K_JTDefinitionTextView_ButtonTag);
        handlerClick = nil;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSEnumerator *subviewsEnum = [window.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[self class]]) {
            [subview removeFromSuperview];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
