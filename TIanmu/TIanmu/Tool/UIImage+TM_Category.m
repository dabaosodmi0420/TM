//
//  UIImage+TM_Category.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "UIImage+TM_Category.h"

@implementation UIImage (TM_Category)

+ (UIImage *)tm_circleImage:(UIImage *)image withParam:(CGFloat)inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)tm_compressImage:(UIImage *)imgSrc compressToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

- (UIImage *)tm_scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)tm_screenshot {
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(screenWindow.bounds.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

+ (UIImage *)tm_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
 375.000000 * 667.000000 7

 414.000000 * 736.000000 7p

 414.000000 * 896.000000 11

 375.000000 * 812.000000 11 pro

 414.000000 * 896.000000 11 pro max

 375.000000 * 812.000000 x
 
 320.000000 * 480.000000 ipad air
 
 */

//+ (UIImage *)tm_getAppLaunchImage {
    
//    CGSize viewSize = [UIScreen mainScreen].bounds.size;
//
//    NSString *viewOrientation = nil;
//    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
//        viewOrientation = @"Portrait";
//    } else {
//        viewOrientation = @"Landscape";
//    }
//
//
//    NSString *launchImage = nil;
//
//    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
//    for (NSDictionary* dict in imagesDict)
//    {
//        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
//
//        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
//        {
//            launchImage = dict[@"UILaunchImageName"];
//        }
//    }
//
//    return [UIImage imageNamed:launchImage];
//}

- (UIImage *)tm_TransformtoSize:(CGSize)Newsize
{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(Newsize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, Newsize.width, Newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}
- (NSString *)imageToBase64String:(long)size {
    float compressScale = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(self, compressScale);

    while (imageData.length > size && compressScale > 0) {
        compressScale -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compressScale);
    }
    return [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (UIImage *)tm_MiniProgramscreenshot{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(iPhoneWidth, iPhoneHeight), NO, 0);
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:CGRectMake(0, 0, iPhoneWidth,iPhoneHeight) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 裁剪图片大小
+ (UIImage*)tm_imageByScalingNotCroppingForSize:(UIImage*)image toReact:(CGRect)rect
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}
#pragma mark 确定图片裁剪的长宽比
+ (CGSize )tm_circleImage:(UIImage *)image radio:(CGFloat)radio {
    CGSize size = image.size;
    if (image.size.width > image.size.height *radio) {
        size = CGSizeMake(image.size.height *radio, image.size.height );
    }else{
        size = CGSizeMake(image.size.width, image.size.width/radio);
    }
    return size;
}

- (NSData *)tm_compressQualityWithMaxLength:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    
    if (data.length > maxLength) {
        UIImage *nImage = [self tm_TransformtoSize:CGSizeMake(self.size.width*0.5, self.size.height*0.5)];
        data = [nImage tm_compressQualityWithMaxLength:maxLength];
    }
    
    return data;
}
@end
