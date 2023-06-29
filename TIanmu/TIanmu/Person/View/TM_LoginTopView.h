//
//  TM_LoginTopView.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TM_LoginTopViewEnum){
    TM_LoginTopViewEnumDefault = -1,
    TM_LoginTopViewEnumLogin,      // 登录
    TM_LoginTopViewEnumFlow,       // 流量卡
    TM_LoginTopViewEnumDiscount,   // 优惠券
    TM_LoginTopViewEnumFav,        // 我的收藏
};
NS_ASSUME_NONNULL_BEGIN

@interface TM_LoginTopView : UIView

/* 头像 */
@property (strong, nonatomic) UIButton              *headerBtn;
/* 手机号显示label */
@property (strong, nonatomic) UILabel               *phoneNumLabel;

@property (copy, nonatomic) void(^clickBlock)(TM_LoginTopViewEnum type);

- (void)reload;

@end

NS_ASSUME_NONNULL_END
