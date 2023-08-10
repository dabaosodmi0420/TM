//
//  UIView+TM_View.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TM_View)
+ (UIButton *)createButton:(CGRect)frame title:(NSString *)title titleColoe:(UIColor *)titleColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize sel:(SEL)sel target:(id)target;
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize placeholder:(NSString *)placeholder isSecure:(BOOL)isSecure delegate:(id)delegate;
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize placeholder:(NSString *)placeholder isSecure:(BOOL)isSecure delegate:(id)delegate leftImageName:(NSString *)leftImageName isShowBottomLine:(BOOL)isShowBottomLine;
+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize color:(UIColor *)color;

// 横向渐变
+ (void)setHorGradualChangingColor:(UIView *)view colorArr:(NSArray *)colorArr;
// 纵向渐变
+ (void)setVerGradualChangingColor:(UIView *)view colorArr:(NSArray *)colorArr;

- (void)setCornerRadius:(CGFloat)radius;
- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderLineW:(CGFloat)borderLineW;
@end

NS_ASSUME_NONNULL_END
