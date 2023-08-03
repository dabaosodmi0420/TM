//
//  JTDefinitionTextView.m
//  IOS_108
//
//  Created by Apple on 2017/12/6.
//  Copyright © 2017年 csctest. All rights reserved.
//

#import "JTDefinitionTextView.h"
#define K_JTDefinitionTextView_ButtonTag 100
#import "TM_AttributeTextView.h"




@interface JTDefinitionTextView ()<TM_AttributeTextViewDelegate>

/*  */
@property (copy, nonatomic)HandlerClick handlerClick;
@property (copy, nonatomic)LinkTextClickHandler linkTextHandler;

@end

@implementation JTDefinitionTextView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
+ (void)jt_showWithTitle:(NSString *)title
                    Text:(NSString *)text
                    type:(JTAlertType)type
           actionTextArr:(NSArray *)actionTextArr
                 handler:(HandlerClick)handler{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        JTDefinitionTextView *definitionView = [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
        definitionView.handlerClick = handler;
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
            
            [blankView addSubview:[definitionView createViewCGRect:CGRectMake(40, CGRectGetMaxY(titleL.frame) + 14, blankView_W - 80, 0.5)]];
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
        textView.textAlignment = NSTextAlignmentCenter;
        [blankView addSubview:textView];
        
        CGFloat actionY = blankView.frame.size.height - actionH;
        UIColor *normalColor = [UIColor colorWithRed:38/255.0 green:197/255.0 blue:223/255.0 alpha:1];
        UIColor *cancelColor = [UIColor colorWithRed:38/255.0 green:197/255.0 blue:223/255.0 alpha:1];
        if (actionTextArr.count == 1) {
            [blankView addSubview:[definitionView createButtonCGRect:CGRectMake(20 , actionY + 5, blankView_W - 40, 30) title:actionTextArr[0] titleColor:normalColor tag:K_JTDefinitionTextView_ButtonTag]];
        }else if(actionTextArr.count > 1){
            for (NSInteger i = 0; i < 2; i++) {
                CGRect rect = CGRectMake(10 + i * blankView_W * 0.5, actionY + 5, blankView_W * 0.5 - 20, 30);
                [blankView addSubview:[definitionView createButtonCGRect:rect title:actionTextArr[i] titleColor: i == 0 ? cancelColor : normalColor tag:K_JTDefinitionTextView_ButtonTag + i]];
            }
            [blankView addSubview:[definitionView createViewCGRect:CGRectMake(blankView_W * 0.5, actionY, 0.5, 40)]];
        }else{
            [blankView addSubview:[definitionView createButtonCGRect:CGRectMake(20 , actionY + 5, blankView_W - 40, 30) title:@"确 定" titleColor:normalColor tag:K_JTDefinitionTextView_ButtonTag]];
        }
        [blankView addSubview:[definitionView createViewCGRect:CGRectMake(0, actionY, blankView_W, 0.5)]];
    });
}
+ (void)jt_showWithTitle:(NSString *)title
                    text:(NSString *)text
             linkTextArr:(NSArray *)linkTextArr
       linkTextSchemeArr:(NSArray *)linkTextSchemeArr
           actionTextArr:(NSArray *)actionTextArr
                 handler:(HandlerClick)handle
    linkTextClickHandler:(LinkTextClickHandler)linkTextClickHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        JTDefinitionTextView *definitionView = [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
        definitionView.handlerClick = handle;
        definitionView.linkTextHandler = linkTextClickHandler;
        definitionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:definitionView];
        
        BOOL isHaveTitle = NO;
        if (title != nil && ![title isEqual:[NSNull null]] && title.length != 0 && ![title isEqualToString:@"(null)"]) {
            isHaveTitle = YES;
        }
        CGFloat titleH = isHaveTitle ? 30 : 0;
        
        CGFloat blankView_X = 25;
        CGFloat blankView_W = definitionView.frame.size.width - 2 * blankView_X;
        CGFloat blankView_minY = 80;
        CGFloat blankView_maxH = [UIScreen mainScreen].bounds.size.height - blankView_minY - 40;
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(blankView_X, 0, blankView_W, 0)];
        blankView.backgroundColor = [UIColor whiteColor];
        blankView.layer.cornerRadius = 5;
        blankView.clipsToBounds = YES;
        [definitionView addSubview:blankView];
        
        if (isHaveTitle) {
            CGFloat y = 10;
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(30, y, blankView_W - 60, titleH)];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.text = title;
            titleL.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
            titleL.font = [UIFont systemFontOfSize:19];
            [blankView addSubview:titleL];
            
            CGFloat lineY = CGRectGetMaxY(titleL.frame) + 5;
            [blankView addSubview:[definitionView createViewCGRect:CGRectMake(40, lineY, blankView_W - 80, 0.5)]];
            
            titleH = lineY;
        }
        
        CGFloat actionH = 40;
        CGFloat textView_Top = 6 + titleH;
        CGFloat textView_X = 30;
        CGFloat textView_W = blankView.frame.size.width - 2 * textView_X;
        UIFont *font = [UIFont systemFontOfSize:14];
        
        TM_AttributeTextView *attributeTV = [[TM_AttributeTextView alloc] initWithFrame:CGRectMake(textView_X, textView_Top, textView_W, 0)];
        attributeTV.text = text;
        attributeTV.font = font;
        attributeTV.textColor = TM_ColorHex(@"#888888");
        attributeTV.linkColor = TM_SpecialGlobalColor;
        attributeTV.linkTextArr = linkTextArr;
        attributeTV.linkTextSchemeArr = linkTextSchemeArr;
        attributeTV.delegate = definitionView;
        attributeTV.isSizeToFit = YES;
        [blankView addSubview:attributeTV];
        
        CGFloat textView_H = attributeTV.height;
        
        CGFloat totalH = textView_Top + textView_H + actionH + 5;
        // 整体高度没有超过限定的最大高度
        if (totalH <= blankView_maxH) {
            CGRect frame = blankView.frame;
            frame.size.height = totalH;
            frame.origin.y = ([UIScreen mainScreen].bounds.size.height - totalH) * 0.5;
            blankView.frame = frame;
        }else {
            CGRect frame = blankView.frame;
            frame.size.height = blankView_maxH;
            frame.origin.y = blankView_minY;
            blankView.frame = frame;
            attributeTV.height = blankView_maxH - textView_Top - actionH - 5;
        }
        
        CGFloat actionY = CGRectGetMaxY(attributeTV.frame) + 8;
        UIColor *cancelColor = [UIColor colorWithRed:38/255.0 green:197/255.0 blue:223/255.0 alpha:1];
        UIColor *normalColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
        if (actionTextArr.count == 1) {
            [blankView addSubview:[definitionView createButtonCGRect:CGRectMake(20 , actionY, blankView_W - actionH, actionH) title:actionTextArr[0] titleColor:normalColor tag:K_JTDefinitionTextView_ButtonTag]];
        }else if(actionTextArr.count > 1){
            for (NSInteger i = 0; i < 2; i++) {
                CGRect rect = CGRectMake(10 + i * blankView_W * 0.5, actionY, blankView_W * 0.5 - 20, actionH);
                [blankView addSubview:[definitionView createButtonCGRect:rect title:actionTextArr[i] titleColor: i == 0 ? cancelColor : normalColor tag:K_JTDefinitionTextView_ButtonTag + i]];
            }
            [blankView addSubview:[definitionView createViewCGRect:CGRectMake(blankView_W * 0.5, actionY, 0.5, actionH)]];
        }else{
            [blankView addSubview:[definitionView createButtonCGRect:CGRectMake(20 , actionY, blankView_W - actionH, actionH) title:@"确 定" titleColor:normalColor tag:K_JTDefinitionTextView_ButtonTag]];
        }
        [blankView addSubview:[definitionView createViewCGRect:CGRectMake(0, actionY, blankView_W, 0.5)]];
    });
}
- (UIButton *)createButtonCGRect:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag{
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
- (UIView *)createViewCGRect:(CGRect)rect{
    UIView *lineView = [[UIView alloc]initWithFrame:rect];
    lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    return lineView;
}
- (void)closeClick:(UIButton *)btn{
    if (self.handlerClick) {
        self.handlerClick(btn.tag - K_JTDefinitionTextView_ButtonTag);
        self.handlerClick = nil;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSEnumerator *subviewsEnum = [window.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[self class]]) {
            [subview removeFromSuperview];
        }
    }
}
#pragma mark - TM_AttributeTextViewDelegate
- (void)tm_attributeTextView:(TM_AttributeTextView *)attributeTextView linkScheme:(NSString *)scheme {
    NSLog(@"%@",scheme);
    if (self.linkTextHandler) {
        self.linkTextHandler(scheme);
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
