//
//  UIView+TM_Category.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "UIView+TM_Category.h"

@implementation UIView (TM_Category)

+ (UIView *)tm_setCornerRadius:(CGFloat)fRadius withBorderColor:(UIColor *)bColor WithView:(UIView *)view {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = fRadius;
    if (bColor) {
        view.layer.borderWidth = 1.0f;    //边框宽度
        view.layer.borderColor = bColor.CGColor;   //边框颜色
    }
    
    return view;
}

+ (UIView *)tm_setBorderWidth:(CGFloat)fWidth withBorderColor:(UIColor *)bColor WithView:(UIView *)view {
    if (bColor) {
        view.layer.borderWidth = fWidth;    //边框宽度
        view.layer.borderColor = bColor.CGColor;   //边框颜色
    }
    
    return view;
}

- (void)yt_removeAllSubViewsToNil {
    if (self.subviews.count < 1) {
        return ;
    }
    for (int i = 0; i < self.subviews.count; i++){
        UIView *view = self.subviews[i];
        [view removeFromSuperview];
    }
}

- (void)showExtendAnimation:(BOOL)animated{
    if(!animated) return;
    self.transform = CGAffineTransformScale(self.transform, 0.02, 0.02);
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }while (next != nil);
    return nil;
}

- (UIImage *)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}
@end
