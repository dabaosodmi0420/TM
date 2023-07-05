//
//  JTNetworkSignalView.h
//  ZXJTOpenAccountDemo
//
//  Created by 郑连杰 on 2020/7/24.
//  Copyright © 2020 你猜我是谁啊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JTNetSignalBlock)(void);

@interface JTNetworkSignalView : UIView

/// 初始化
/// @param position 在父视图上左上角位置
/// @param showPopView 是否显示信息框
- (instancetype)initWithPosition:(CGPoint)position showPopView:(BOOL)showPopView vc:(UIViewController *)vc block:(JTNetSignalBlock)block;

- (void)jt_start;
- (void)jt_stop;
/// 刷新当前网络状态
/// @param type 当前网络状态类别（0 ~ 5）返回值：0 优良，1 较好，2 一般，3 较差，4 非常差）
/// @param videoBitrate 码率
- (void)jt_reload:(NSInteger)type :(NSString *)videoBitrate;
@end

NS_ASSUME_NONNULL_END
