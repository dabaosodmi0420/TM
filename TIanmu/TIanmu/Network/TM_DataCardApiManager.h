//
//:  TM_DataCardApiManager.h
//:  TIanmu
//
//:  Created by 郑连杰 on 2023/6/28.
//

#import "TM_NetworkTool.h"
#import "TM_DataCardDetalInfoModel.h"
#import "TM_DeviceIndexInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_DataCardApiManager : TM_NetworkTool
//MARK: 获取用户所有卡片信息
+ (void)sendQueryUserAllCardWithPhoneNum:(NSString *)phoneNum
                                 success:(TMAPISuccessBlock)successBlock
                                 failure:(TMAPIFailureBlock)failureBlock;
//MARK: 查询单卡信息
+ (void)sendQueryUserAllCardWithCardNo:(NSString *)cardNo
                               success:(void (^)(TM_DataCardDetalInfoModel *model))successBlock
                               failure:(TMAPIFailureBlock)failureBlock;
//MARK: 查询设备索引页信息 
+ (void)sendQueryDeviceIndexInfoWithCardNo:(NSString *)cardNo
                                   success:(void (^)(TM_DeviceIndexInfo *model))successBlock
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

//MARK: 订购套餐- 余额支付 生成预支付订单
+ (void)sendOrderTcByBalanceWithOpenId:(NSString *)openId
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

//MARK: 查询充值金额列表数据
+ (void)sendQueryMoneyListWithSuccess:(TMAPISuccessBlock)successBlock
                              failure:(TMAPIFailureBlock)failureBlock;

//MARK: 查询购买记录
+ (void)sendGetCardTradeWithCardNo:(NSString *)cardNo
                             month:(NSString *)month
                           success:(TMAPISuccessBlock)successBlock
                           failure:(TMAPIFailureBlock)failureBlock;

//MARK: 查询分身卡信息
+ (void)sendQueryTmfskInfoWithCardNo:(NSString *)cardNo
                             success:(TMAPISuccessBlock)successBlock
                             failure:(TMAPIFailureBlock)failureBlock;
//MARK: 电信内贴卡实名同步接口
+ (void)sendUpdateTmfskAuthWithCardNo:(NSString *)cardNo
                              success:(TMAPISuccessBlock)successBlock
                              failure:(TMAPIFailureBlock)failureBlock;
//MARK: 内贴卡查询实名链接
+ (void)sendSetTmfskAuthWithCardNo:(NSString *)cardNo
                             iccid:(NSString *)iccid
                            msisdn:(NSString *)msisdn
                           netType:(NSString *)netType
                           success:(TMAPISuccessBlock)successBlock
                           failure:(TMAPIFailureBlock)failureBlock ;

//MARK: 查询卡订购套餐类型

/// - Parameters:
///   - cardNo: 卡号
///   - type: //month:当月包；next次月包；(不包含累计包的情况);add累计包;cheap特惠包；all-设备用的套餐（除了next，加的都是当月生效的包）
+ (void)sendQueryTaoCanPackageTypeListWithCardNo:(NSString *)cardNo
                                         success:(TMAPISuccessBlock)successBlock
                                         failure:(TMAPIFailureBlock)failureBlock;

//MARK: 查询卡订购套餐列表

/// - Parameters:
///   - cardNo: 卡号
///   - type: //month:当月包；next次月包；(不包含累计包的情况);add累计包;cheap特惠包；all-设备用的套餐（除了next，加的都是当月生效的包）
+ (void)sendQueryTaoCanPackagesListWithCardNo:(NSString *)cardNo
                                         type:(NSString *)type
                                      success:(TMAPISuccessBlock)successBlock
                                      failure:(TMAPIFailureBlock)failureBlock;

//MARK: 查询实名接口
+ (void)sendSetAuthWithCardNo:(NSString *)cardNo
                      success:(TMAPISuccessBlock)successBlock
                      failure:(TMAPIFailureBlock)failureBlock;

//MARK: 注意事项查询

/// - Parameters:
///   - cardNo: 卡号
///   - type: balance充值；flow订购套餐
+ (void)sendQueryNoticesWithCardNo:(NSString *)cardNo
                              type:(NSString *)type
                           success:(TMAPISuccessBlock)successBlock
                           failure:(TMAPIFailureBlock)failureBlock;

//MARK: 销卡
+ (void)sendCancelCardWithCardNo:(NSString *)cardNo
                        realName:(NSString *)realName
                         success:(TMAPISuccessBlock)successBlock
                         failure:(TMAPIFailureBlock)failureBlock;

//MARK: 常见问题
+ (void)sendQueryHelpWithSuccess:(TMAPISuccessBlock)successBlock
                         failure:(TMAPIFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
