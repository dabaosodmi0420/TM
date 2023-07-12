//
//  TM_DataCardApiManager.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/28.
//

#import "TM_DataCardApiManager.h"

@implementation TM_DataCardApiManager

// 查询绑定所有卡
+ (void)sendQueryUserAllCardWithPhoneNum:(NSString *)phoneNum success:(TMAPISuccessBlock)successBlock failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryUserAllCard";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"] = phoneNum;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
// 查询单卡信息
+ (void)sendQueryUserAllCardWithCardNo:(NSString *)cardNo success:(TMAPISuccessBlock)successBlock failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryCardDetail";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"] = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

// 查询流量使用情况
+ (void)sendQueryUserFlowWithCardNo:(NSString *)cardNo success:(TMAPISuccessBlock)successBlock failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/getUsedFlow";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"] = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
// 用户绑定流量卡
+ (void)sendUserBindCardWithPhoneNum:(NSString *)phoneNum
                              CardNo:(NSString *)cardNo
                             success:(TMAPISuccessBlock)successBlock
                             failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/userBindCard";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"]    = phoneNum;
    params[@"card_define_no"] = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
// 用户解绑流量卡
+ (void)sendUserUnBindCardWithPhoneNum:(NSString *)phoneNum
                                CardNo:(NSString *)cardNo
                               success:(TMAPISuccessBlock)successBlock
                               failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/userUnbindCard";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"]    = phoneNum;
    params[@"card_define_no"] = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

// 账户充值 生成预支付订单
+ (void)sendGetWechatRechargePreWithPhoneNum:(NSString *)phoneNum
                                      CardNo:(NSString *)cardNo
                              recharge_money:(NSString *)recharge_money
                                     success:(TMAPISuccessBlock)successBlock
                                     failure:(TMAPIFailureBlock)failureBlock {

    if (!recharge_money || recharge_money.length == 0) return;
    
    NSString *url = @"/getWechatRechargePre";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"]    = phoneNum;
    params[@"card_define_no"] = cardNo;
    params[@"recharge_money"] = recharge_money;

    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

// 查询套餐列表
+ (void)sendQueryTaoCanListWithCardNo:(NSString *)cardNo
                                 type:(NSString *)type
                              success:(TMAPISuccessBlock)successBlock
                              failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryTaoCanList";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"]             = type;
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

// 查询购买记录
+ (void)sendGetCardTradeWithCardNo:(NSString *)cardNo
                             month:(NSString *)month
                           success:(TMAPISuccessBlock)successBlock
                           failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/getCardTrade";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"month"]            = month;
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
@end
