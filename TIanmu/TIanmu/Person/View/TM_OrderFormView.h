//
//  TM_OrderFormView.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TM_OrderFormViewEnum){
    TM_OrderFormViewEnumDefault = -1,
    TM_OrderFormViewEnumAllOrder,   // 所有订单
    TM_OrderFormViewEnumDFK,    // 代付款
    TM_OrderFormViewEnumDFH,    // 代发货
    TM_OrderFormViewEnumDSH,    // 待收货
    TM_OrderFormViewEnumDPJ,    // 待评价
    TM_OrderFormViewEnumSH      // 售后
};


NS_ASSUME_NONNULL_BEGIN

@interface TM_OrderFormView : UIView

/* block */
@property (copy, nonatomic) void(^clickBlock)(TM_OrderFormViewEnum type);

@end

NS_ASSUME_NONNULL_END
