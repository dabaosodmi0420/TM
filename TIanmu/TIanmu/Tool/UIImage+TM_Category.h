//
//  UIImage+TM_Category.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TM_Category)

/**
 *  剪裁图片
 *
 *  @param image 原图片
 *  @param inset 剪裁比例
 *
 *  @return 剪裁后图片
 */
+ (UIImage *)tm_circleImage:(UIImage *)image withParam:(CGFloat)inset;

/**
 *  压缩图片
 *
 *  @param imgSrc 原图片
 *  @param size   压缩到的大小
 *
 *  @return 压缩后图片
 *
 */
+ (UIImage *)tm_compressImage:(UIImage *)imgSrc compressToSize:(CGSize)size;

/**
 去掉图片压缩导致锯齿
 */
- (UIImage *)tm_scaleToSize:(CGSize)size;

/**
 *  截屏
 *
 *  @return 返回图片
 */
+ (UIImage *)tm_screenshot;

/**
 *  颜色转成图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage *)tm_imageWithColor:(UIColor *)color;

/*  获取 app 启动图 */
/**
 5.8.0 不再使用这里，因为启动图改成了xib view
 */
//+ (UIImage *)tm_getAppLaunchImage;

/* 调整图片大小 */
- (UIImage *)tm_TransformtoSize:(CGSize)Newsize;
/**
 * 把图片转成Base64String
 * @param size 对需要转换的image做大的限制
 * @return
 */
- (NSString *)imageToBase64String:(long)size;

/**
 *  截屏
 *
 *  @return 返回图片
 */
+ (UIImage *)tm_MiniProgramscreenshot;

/**
 * @param size 对图片进行裁剪
 * @return
 */
+ (UIImage*)tm_imageByScalingNotCroppingForSize:(UIImage*)anImage toReact:(CGRect)partRect;

/**
 *
 *  根据长宽比确定裁切的大小
 * @return
 */
+ (CGSize )tm_circleImage:(UIImage *)image radio:(CGFloat)radio;


/// 压缩图片至指定大小内
/// @param maxLength 最大容量
- (NSData *)tm_compressQualityWithMaxLength:(NSInteger)maxLength;
@end

NS_ASSUME_NONNULL_END
