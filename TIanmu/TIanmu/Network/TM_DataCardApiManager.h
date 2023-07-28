//
//:  TM_DataCardApiManager.h
//:  TIanmu
//
//:  Created by 郑连杰 on 2023/6/28.
//

#import "TM_NetworkTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_DataCardApiManager : TM_NetworkTool
//MARK: 获取用户所有卡片信息
+ (void)sendQueryUserAllCardWithPhoneNum:(NSString *)phoneNum
                                 success:(TMAPISuccessBlock)successBlock
                                 failure:(TMAPIFailureBlock)failureBlock;
//MARK: 查询单卡信息
+ (void)sendQueryUserAllCardWithCardNo:(NSString *)cardNo
                               success:(TMAPISuccessBlock)successBlock
                               failure:(TMAPIFailureBlock)failureBlock;
//MARK: 查询流量使用情况
+ (void)sendQueryUserFlowWithCardNo:(NSString *)cardNo
                            success:(TMAPISuccessBlock)successBlock
                            failure:(TMAPIFailureBlock)failureBlock;

//MARK: 用户绑定流量卡
+ (void)sendUserBindCardWithPhoneNum:(NSString *)phoneNum
                              CardNo:(NSString *)cardNo
                             success:(TMAPISuccessBlock)successBlock
                             failure:(TMAPIFailureBlock)failureBlock;

//MARK: 用户解绑流量卡
+ (void)sendUserUnBindCardWithPhoneNum:(NSString *)phoneNum
                                CardNo:(NSString *)cardNo
                               success:(TMAPISuccessBlock)successBlock
                               failure:(TMAPIFailureBlock)failureBlock;

//MARK: 账户充值 生成预支付订单
+ (void)sendGetWechatRechargePreWithPhoneNum:(NSString *)phoneNum
                                      CardNo:(NSString *)cardNo
                              recharge_money:(NSString *)recharge_money
                                     success:(TMAPISuccessBlock)successBlock
                                     failure:(TMAPIFailureBlock)failureBlock;

//MARK: 订购套餐- 生成预支付订单
+ (void)sendOrderTcByWXWithPhoneNum:(NSString *)phoneNum
                             CardNo:(NSString *)cardNo              //卡号
                     recharge_money:(NSString *)recharge_money
                               type:(NSString *)type                //month:当月加包；next次月加包；
                         package_id:(NSString *)package_id          //订购套餐包体编号
                            success:(TMAPISuccessBlock)successBlock
                            failure:(TMAPIFailureBlock)failureBlock;

//MARK: 查询套餐列表
+ (void)sendQueryTaoCanListWithCardNo:(NSString *)cardNo
                                 type:(NSString *)type
                              success:(TMAPISuccessBlock)successBlock
                              failure:(TMAPIFailureBlock)failureBlock;

//MARK: 查询购买记录
+ (void)sendGetCardTradeWithCardNo:(NSString *)cardNo
                             month:(NSString *)month
                           success:(TMAPISuccessBlock)successBlock
                           failure:(TMAPIFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
