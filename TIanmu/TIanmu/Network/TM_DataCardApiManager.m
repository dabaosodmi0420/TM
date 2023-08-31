//
//:  TM_DataCardApiManager.m
//:  TIanmu
//
//:  Created by 郑连杰 on 2023/6/28.
//

#import "TM_DataCardApiManager.h"


@implementation TM_DataCardApiManager

//MARK: 查询绑定所有卡
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
//MARK: 查询单卡信息
+ (void)sendQueryUserAllCardWithCardNo:(NSString *)cardNo
                               success:(void (^)(TM_DataCardDetalInfoModel *model))successBlock
                               failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryCardDetail";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"] = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                TM_DataCardDetalInfoModel *model = [TM_DataCardDetalInfoModel mj_objectWithKeyValues:data];
                successBlock(model);
            }else {
                TM_ShowWindowToast(@"获取数据失败");
            }
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"msg"]];
            TM_ShowWindowToast(msg);
        }
    } failure:failureBlock];
}
//MARK: 查询设备索引页信息
+ (void)sendQueryDeviceIndexInfoWithCardNo:(NSString *)cardNo
                                   success:(void (^)(TM_DeviceIndexInfo *model))successBlock
                                   failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryDeviceIndexInfo";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"] = cardNo;

    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            id data = respondObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                TM_DeviceIndexInfo *model = [TM_DeviceIndexInfo mj_objectWithKeyValues:data];
                successBlock(model);
            }else {
                TM_ShowWindowToast(@"获取数据失败");
            }
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"msg"]];
            TM_ShowWindowToast(msg);
        }
    } failure:failureBlock];
}
//MARK: 查询流量使用情况
+ (void)sendQueryUserFlowWithCardNo:(NSString *)cardNo
                            success:(TMAPISuccessBlock)successBlock
                            failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/getUsedFlow";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"] = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
//MARK: 用户绑定流量卡
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
//MARK: 用户解绑流量卡
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

//MARK: 账户充值 生成预支付订单
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

//MARK: 订购套餐- 生成预支付订单
+ (void)sendOrderTcByWXWithPhoneNum:(NSString *)phoneNum
                             CardNo:(NSString *)cardNo              //卡号
                     recharge_money:(NSString *)recharge_money
                               type:(NSString *)type                //month:当月加包；next次月加包；
                         package_id:(NSString *)package_id          //订购套餐包体编号
                            success:(TMAPISuccessBlock)successBlock
                            failure:(TMAPIFailureBlock)failureBlock {

    if (!recharge_money || recharge_money.length == 0) return;
    
    NSString *url = @"/orderTcByWX";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"]        = phoneNum;
    params[@"card_define_no"]   = cardNo;
    params[@"type"]             = type;
    params[@"package_id"]       = package_id;
    params[@"package_price"]   = recharge_money;

    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 订购套餐- 余额支付 生成预支付订单
+ (void)sendOrderTcByBalanceWithOpenId:(NSString *)openId
                                CardNo:(NSString *)cardNo              //卡号
                        recharge_money:(NSString *)recharge_money
                                type:(NSString *)type                //month:当月加包；next次月加包；
                            package_id:(NSString *)package_id          //订购套餐包体编号
                                success:(TMAPISuccessBlock)successBlock
                                failure:(TMAPIFailureBlock)failureBlock {

    if (!recharge_money || recharge_money.length == 0) return;
    
    NSString *url = @"/orderTcByBalance";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"openId"]        = openId;
    params[@"card_define_no"]   = cardNo;
    params[@"package_id"]       = package_id;
    params[@"type"]             = type;
    params[@"package_price"]   = recharge_money;

    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 查询订购套餐列表

/// - Parameters:
///   - cardNo: 卡号
///   - type: //month:当月包；next次月包；(不包含累计包的情况);add累计包;cheap特惠包；all-设备用的套餐（除了next，加的都是当月生效的包）
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
//MARK: 查询充值金额列表数据
+ (void)sendQueryMoneyListWithSuccess:(TMAPISuccessBlock)successBlock
                              failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryMoneyList";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
//MARK: 查询购买记录
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
//MARK: 查询分身卡信息
+ (void)sendQueryTmfskInfoWithCardNo:(NSString *)cardNo
                             success:(TMAPISuccessBlock)successBlock
                             failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryTmfskInfo";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 电信内贴卡实名同步接口
+ (void)sendUpdateTmfskAuthWithCardNo:(NSString *)cardNo
                              success:(TMAPISuccessBlock)successBlock
                              failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/updateTmfskAuth";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 内贴卡查询实名链接
+ (void)sendSetTmfskAuthWithCardNo:(NSString *)cardNo
                             iccid:(NSString *)iccid
                            msisdn:(NSString *)msisdn
                           netType:(NSString *)netType
                           success:(TMAPISuccessBlock)successBlock
                           failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/setTmfskAuth";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = cardNo;
    params[@"iccid"]            = iccid;
    params[@"msisdn"]           = msisdn;
    params[@"netType"]          = netType;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 查询卡订购套餐类型

/// - Parameters:
///   - cardNo: 卡号
///   - type: //month:当月包；next次月包；(不包含累计包的情况);add累计包;cheap特惠包；all-设备用的套餐（除了next，加的都是当月生效的包）
+ (void)sendQueryTaoCanPackageTypeListWithCardNo:(NSString *)cardNo
                                         success:(TMAPISuccessBlock)successBlock
                                         failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryPackageType";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
//MARK: 查询卡订购套餐列表

/// - Parameters:
///   - cardNo: 卡号
///   - type: //month:当月包；next次月包；(不包含累计包的情况);add累计包;cheap特惠包；all-设备用的套餐（除了next，加的都是当月生效的包）
+ (void)sendQueryTaoCanPackagesListWithCardNo:(NSString *)cardNo
                                         type:(NSString *)type
                                      success:(TMAPISuccessBlock)successBlock
                                      failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryPackages";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"]             = type;
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 查询实名接口
+ (void)sendSetAuthWithCardNo:(NSString *)cardNo
                      success:(TMAPISuccessBlock)successBlock
                      failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/setAuth";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 注意事项查询

/// - Parameters:
///   - cardNo: 卡号
///   - type: balance充值；flow订购套餐
+ (void)sendQueryNoticesWithCardNo:(NSString *)cardNo
                              type:(NSString *)type
                           success:(TMAPISuccessBlock)successBlock
                           failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryNotices";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"]             = type;
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 销卡 queryHelp
+ (void)sendCancelCardWithCardNo:(NSString *)cardNo
                        realName:(NSString *)realName
                         success:(TMAPISuccessBlock)successBlock
                         failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/cancelCard";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"realName"]         = realName;
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 常见问题
+ (void)sendQueryHelpWithSuccess:(TMAPISuccessBlock)successBlock
                         failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryHelp";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 切换网络
//1：移动，2：联通，3：电信
+ (void)sendChangeNetWithCardNo:(NSString *)cardNo
                        network:(NSString *)network
                        success:(TMAPISuccessBlock)successBlock
                        failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/updateDeviceNet";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operator"]         = network;
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
//MARK: 远程控制
//1：移动，2：联通，3：电信
+ (void)sendSaveControlWithCardNo:(NSString *)cardNo
                        network:(NSString *)network
                        success:(TMAPISuccessBlock)successBlock
                        failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/saveDeviceControll";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operator"]         = network;
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
//MARK: 查询切换网络列表
+ (void)sendQueryDeviceNetWithCardNo:(NSString *)cardNo
                             success:(TMAPISuccessBlock)successBlock
                             failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryDeviceNet";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
//MARK: 修改wifi密码
+ (void)sendSaveWifiPasswordlWithCardNo:(NSString *)cardNo
                               wifiName:(NSString *)wifiName
                                 wifiPW:(NSString *)wifiPW
                                success:(TMAPISuccessBlock)successBlock
                                failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/saveDeviceWifi";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = cardNo;
    params[@"wifiPwd"]          = wifiPW;
    params[@"wifiName"]         = wifiName;

    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
//MARK: 查询设备实名链接
+ (void)sendQueryDeviceAuthUrlWithCardNo:(NSString *)cardNo
                                 success:(TMAPISuccessBlock)successBlock
                                 failure:(TMAPIFailureBlock)failureBlock {
    
    NSString *url = @"/queryDeviceAuthUrl";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = cardNo;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 激活设备
+ (void)sendDeviceActivityWithPhoneNum:(NSString *)phoneNum
                        card_define_no:(NSString *)card_define_no
                                  code:(NSString *)code
                               success:(TMAPISuccessBlock)successBlock
                               failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"/deviceSQActive";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"card_define_no"]   = card_define_no;
    params[@"mobile"]           = phoneNum;
    params[@"code"]             = code;

    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
@end
