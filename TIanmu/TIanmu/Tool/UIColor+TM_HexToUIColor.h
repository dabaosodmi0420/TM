//
//  UIColor+TM_HexToUIColor.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


#define tm_ColorWithHexStr(_hexString_) [UIColor tm_colorWithHexString:_hexString_]
/**
 *  十六进制颜色值转换成UIColor类型
 */
@interface UIColor (TM_HexToUIColor)

/// 获取部分色值串 如：@"FF"
/// @param ratio 如：1.0 范围为 [0-1]
+ (NSString *)tm_colorComponentStringWithRatio:(CGFloat)ratio;

/// 获取色值串(八位数值带alpha) 如：@"#FFEE421B"
/// @param ratio 如：1.0 范围为 [0-1]
/// @param hexString 如：@"EE421B"或@"#EE421B"
+ (NSString *)tm_colorWholeStringWithRatio:(CGFloat)ratio hexString:(NSString *)hexString;

/// 获取色值串(八位数值带alpha)的透明度
/// @param hexString  如：@"#FFEE421B"
+ (CGFloat)tm_colorAlphaValueWithHexString:(NSString *)hexString;

/// 获取色值串(八位数值带alpha)的数值 ，如：@"EE421B"的"EE"转换为CGFloat为238 / 255.0
/// @param string @"EE421B"
/// @param start 0
/// @param length 2
CGFloat tm_colorComponentWith(NSString *string, NSUInteger start, NSUInteger length);

/**
 *  将十六进制数 转化为 UIColor
 *
 *  @param hexString 十六进制数
 *
 *  @return UIColor
 */
+ (UIColor *)tm_colorWithHexString:(NSString *)hexString;

/**
 *  将十六进制数 转化为 UIColor
 *
 *  @param hexString 十六进制数
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor*)tm_colorWithHexString:(NSString*)hexString andAlpha:(float)alpha;

/**
 *  获取颜色
 *
 *  @param red   红
 *  @param green 绿
 *  @param blue  蓝
 *
 *  @return 颜色
 */
+ (UIColor *)tm_colorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue;

@end

NS_ASSUME_NONNULL_END
