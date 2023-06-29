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
@end
