//
//  UIView+TM_Category.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TM_Category)

/**
 *  设置角度
 *
 *  @param fRadius 弧度
 *  @param bColor 边框颜色
 *  @param view 针对的view
 *
 *  return view
 */
+ (UIView *)tm_setCornerRadius:(CGFloat)fRadius withBorderColor:(UIColor *)bColor WithView:(UIView *)view;

/**
 *  设置边框宽度及颜色
 *
 *  @param fWidth 完成
 *  @param bColor 颜色
 *  @param view   针对的view
 *
 *  @return view
 *
 */
+ (UIView *)tm_setBorderWidth:(CGFloat)fWidth withBorderColor:(UIColor *)bColor WithView:(UIView *)view;

- (void)yt_removeAllSubViewsToNil;

- (void)showExtendAnimation:(BOOL)animated;

- (UIViewController *)viewController ;

/**
 *      视图转图片
 */
- (UIImage *)snapshot;
@end

NS_ASSUME_NONNULL_END
