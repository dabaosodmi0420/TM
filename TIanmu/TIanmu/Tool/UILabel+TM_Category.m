//
//  UILabel+TM_Category.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "UILabel+TM_Category.h"

@implementation UILabel (TM_Category)

+ (UILabel *)tm_createLable:(CGRect)frame
                    Text:(nullable NSString *)aText
             TextAliType:(NSTextAlignment)aTextAliType
                    Font:(nullable UIFont *)font
                   Color:(nullable UIColor *)aColor
               BackColor:(nullable UIColor *)bColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:(bColor ? bColor:[UIColor clearColor])];
    [label setText:aText];
    [label setTextAlignment:aTextAliType];
    if (font) {
        label.font = font;
    }
    if (aColor) {
        [label setTextColor:aColor];
    }
    label.adjustsFontSizeToFitWidth = YES;  //设置字体大小是否适应label宽度
    label.minimumScaleFactor = 0.1;
    
    return label;
}

+ (UILabel *)tm_createLable:(CGRect)frame
                        Text:(nullable NSString *)aText
                 TextAliType:(NSTextAlignment)aTextAliType
                        Font:(nullable UIFont *)font
                       Color:(nullable UIColor *)aColor
                   BackColor:(nullable UIColor *)bColor
   adjustsFontSizeToFitWidth:(BOOL)bAdjust {
    UILabel *label = [self tm_createLable:frame
                                      Text:aText
                               TextAliType:aTextAliType
                                      Font:font
                                     Color:aColor
                                 BackColor:bColor];
    label.adjustsFontSizeToFitWidth = bAdjust;  //设置字体大小是否适应label宽度
    if (bAdjust) {
        label.minimumScaleFactor = 0.1;
    }

    return label;
}
@end
