//
//  UIImageView+TM_Category.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "UIImageView+TM_Category.h"

@implementation UIImageView (TM_Category)
+ (UIImageView *)tm_createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imgName {
    if (imgName) {
        return [self tm_createImageViewWithFrame:frame Image:[UIImage imageNamed:imgName]];
    } else {
        return [self tm_createImageViewWithFrame:frame Image:nil];
    }
}

+ (UIImageView *)tm_createImageViewWithFrame:(CGRect)frame Image:(UIImage *)image {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    if (image) {
        imgView.image = image;
    }
    return imgView;
}

@end
