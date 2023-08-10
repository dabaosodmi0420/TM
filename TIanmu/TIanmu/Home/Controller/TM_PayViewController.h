//
//  TM_PayViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/4.
//

#import "TM_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_PayViewController : TM_BaseViewController

/* 微信支付订单 */
@property (strong, nonatomic) NSDictionary *wxPayData;
/* 金额 */
@property (copy, nonatomic) NSString *money;

@end

NS_ASSUME_NONNULL_END
