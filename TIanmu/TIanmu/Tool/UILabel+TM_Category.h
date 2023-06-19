//
//  UILabel+TM_Category.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (TM_Category)
/**
 *  创建label
 *
 *  @param frame        位置
 *  @param aText        内容
 *  @param aTextAliType 对齐
 *  @param font         字体
 *  @param aColor       字体颜色
 *  @param bColor       背景颜色
 *
 *  @return label对象
 */
+ (UILabel *)tm_createLable:(CGRect)frame
                    Text:(nullable NSString *)aText
             TextAliType:(NSTextAlignment)aTextAliType
                    Font:(nullable UIFont *)font
                   Color:(nullable UIColor *)aColor
               BackColor:(nullable UIColor *)bColor;

/**
 *  创建label
 *
 *  @param frame        位置
 *  @param aText        内容
 *  @param aTextAliType 对齐
 *  @param font         字体
 *  @param aColor       字体颜色
 *  @param bColor       背景颜色
 *  @param bAdjust      是否自动适配宽度
 *
 *  @return label对象
 */
+ (UILabel *)tm_createLable:(CGRect)frame
                        Text:(nullable NSString *)aText
                 TextAliType:(NSTextAlignment)aTextAliType
                        Font:(nullable UIFont *)font
                       Color:(nullable UIColor *)aColor
                   BackColor:(nullable UIColor *)bColor
   adjustsFontSizeToFitWidth:(BOOL)bAdjust;
@end

NS_ASSUME_NONNULL_END
