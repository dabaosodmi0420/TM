//
//  TM_imgLabelButton.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_imgLabelButton : UIButton


@property (strong, nonatomic) UIImageView *imageV;

@property (nonatomic, retain)   UIImage *image;      //上边圆型图片
@property (nonatomic, copy)    NSString *text;       //底部名称
@property (nonatomic, strong)    UIFont *bottomNameFont;       //底部名称字体
@property (nonatomic, strong)   UIColor *color;      //底部名称字体颜色
@property (nonatomic, assign)      BOOL  bClip;      //是否裁剪成圆形
@property (nonatomic, assign) NSInteger  funcNum;    //功能编号
@property (nonatomic, copy)    NSString *strFuncNum; //功能编号

@property (nonatomic, assign)   CGFloat  fImgBorderWidth;  //设置图片边框的宽

@property (nonatomic, strong)   UIColor *shadowColor;      //设置阴影的颜色
@property (nonatomic, assign)   CGFloat  fShadowWidth;     //设置阴影的宽

@property (nonatomic, assign)   CGFloat  fGap;       //label和img间缝隙大小

- (void)resetImageFarme:(CGRect)frame;  //修改image的大小以及坐标

- (void)resetLabelFrame:(CGRect)frame;  //重设label的frame

- (void)addimageShadow; // 中信建投我页面头像周围阴影。

//显示按钮红点
- (void)showRedDotOnBtn:(UIColor *)dotColor;

//隐藏按钮红点
- (void)hiddenRedDotOnBtn;
@end

NS_ASSUME_NONNULL_END
