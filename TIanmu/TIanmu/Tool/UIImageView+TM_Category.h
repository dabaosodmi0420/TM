//
//  UIImageView+TM_Category.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (TM_Category)

/*
 * 创建图片
 */
/**
 *  创建图片
 *
 *  @param frame   frame
 *  @param imgName 图片名称
 *
 *  @return imageView对象
 */
+ (UIImageView *)tm_createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imgName;

/**
 *  创建图片对象用 图片
 *
 *  @param frame  frame
 *  @param image  image
 *
 *  @return 对象
 */
+ (UIImageView *)tm_createImageViewWithFrame:(CGRect)frame Image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
