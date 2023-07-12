//
//  TM_CardTradeModel.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_CardTradeModel : NSObject<NSCoding>
/* 系统订单号 */
@property (copy, nonatomic) NSString *ord_no;
/* OPENID */
@property (copy, nonatomic) NSString *open_id;
/* 交易金额（元） */
@property (assign, nonatomic) double sum;
/* 订单状态：0-未支付、1-支付成功、2-加包成功、3-退订成功 */
@property (assign, nonatomic) int    status;
/* 创建日期 */
@property (copy, nonatomic) NSString *cre_time;
/* 真实号码 */
@property (copy, nonatomic) NSString *card_no;
@end

NS_ASSUME_NONNULL_END
