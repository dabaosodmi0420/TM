//
//  BasePickerView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/11.
//

//BasePickerView.m
#import "BasePickerView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation BasePickerView

- (instancetype)init {
    self = [super init];
    
    if(self) {
        _pickerViewHeight = 250;
        
        //设置此图层大小为主屏幕大小
        self.bounds = [UIScreen mainScreen].bounds;
        //设置背景为灰色
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        //定义手势，在点击空白区域时，移除此图层
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMiss)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        
        //将内容视图加入此图层以及将选择器、确定按钮、取消按钮加入内容视图
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.pickerView];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.confirmButton];
        
        //以便在子类中重写此方法，将pickerView所需的数据初始化
        [self initPickView];
    }
    
    return self;
}

- (void)initPickView {
    
}

//初始化内容视图
- (UIView *)contentView
{
    if (!_contentView) {
 
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, self.pickerViewHeight)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentView;
}

//初始化选择器
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
  
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,  0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
         
    }
    return _pickerView;
}
//初始化取消按钮
- (UIButton *)cancelButton {
    if (!_cancelButton) {
      
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 0, 44, 44)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
//初始化确定按钮
- (UIButton *)confirmButton {
    if (!_confirmButton) {
    
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - self.cancelButton.frame.size.width - self.cancelButton.frame.origin.x, self.cancelButton.frame.origin.y, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height)];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

//等待继承他的子类重写此方法
- (void)clickConfirmButton {
    [self disMiss];
}

- (void)clickCancelButton {
    [self disMiss];
}

//获取keyWindow
- (UIWindow *)getKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow)
                    {
                        return window;
                        break;
                    }
                }
            }
        }
    } else {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}
//移除此图层
- (void)disMiss {
    CGRect frameContent =  self.contentView.frame;
    
//    相当于把contentView的y坐标设置为ScreenHeight，达到一个隐藏的目的
    frameContent.origin.y += self.contentView.frame.size.height;
    //设置动画效果
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //将此图层不透明性设为0
        [self.layer setOpacity:0];
//        再将内容视图隐藏
        self.contentView.frame = frameContent;
    } completion:^(BOOL finished) {
        //将此图层从父视图中移除掉
        [self removeFromSuperview];
    }];
    
}

//推出此图层
- (void)show {
    [[self getKeyWindow] addSubview:self];
    [self setCenter:[self getKeyWindow].center];
    [[self getKeyWindow] bringSubviewToFront:self];
    
    CGRect frameContent =  self.contentView.frame;
 
    frameContent.origin.y -= self.contentView.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        self.contentView.frame = frameContent;
            
    } completion:nil];
}

@end
