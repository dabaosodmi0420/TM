//
//  UIColor+TM_HexToUIColor.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "UIColor+TM_HexToUIColor.h"

@implementation UIColor (TM_HexToUIColor)
#pragma mark - Private
// 根据NSInteger获取颜色值
+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

#pragma mark - Public
/// 获取部分色值串 如：@"FF"
/// @param ratio 如：1.0 范围为 [0-1]
+ (NSString *)tm_colorComponentStringWithRatio:(CGFloat)ratio {
    return [[NSString stringWithFormat:@"%.2x", ((int)roundf(MIN(ratio * 255, 255))) & 0xff] uppercaseString];
}

/// 获取色值串(八位数值带alpha) 如：@"#FFEE421B"
/// @param ratio 如：1.0 范围为 [0-1]
/// @param hexString 如：@"EE421B"或@"#EE421B"
+ (NSString *)tm_colorWholeStringWithRatio:(CGFloat)ratio hexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if ([colorString length] == 6) {
        return [[NSString stringWithFormat:@"#%.2x%@",((int)roundf(MIN(ratio * 255, 255))) & 0xff, colorString] uppercaseString];
    }
    return hexString;
}

/// 获取色值串(八位数值带alpha)的透明度
/// @param hexString  如：@"#FFEE421B"
+ (CGFloat)tm_colorAlphaValueWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if ([colorString length] == 8) {
        return tm_colorComponentWith(colorString, 0, 2);;
    }
    return 1.0;
}

/// 获取色值串(八位数值带alpha)的数值 ，如：@"EE421B"的"EE"转换为CGFloat为238 / 255.0
/// @param string @"EE421B"
/// @param start 0
/// @param length 2
CGFloat tm_colorComponentWith(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)tm_colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 8: { //#AARRGGBB,前两位是16进制的alpha
            CGFloat alpha = tm_colorComponentWith(colorString, 0, 2);
            colorString = [colorString substringWithRange:NSMakeRange(2, colorString.length - 2)];
            return [UIColor tm_colorWithHexString:colorString andAlpha:alpha];
        }
            break;
        default:
            return [UIColor tm_colorWithHexString:hexString andAlpha:1.0];
    }
    return [UIColor tm_colorWithHexString:hexString andAlpha:1.0];
}

+ (UIColor*)tm_colorWithHexString:(NSString*)hexString andAlpha:(float)alpha {
    UIColor *col;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [UIColor colorWithHex:hexValue alpha:alpha];
    } else {
        col = [UIColor blackColor];
    }
    return col;
}

+ (UIColor *)tm_colorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

@end
