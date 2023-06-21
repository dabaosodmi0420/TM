//
//  TM_LoginApiManger.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/21.
//

#import "TM_LoginApiManger.h"

@implementation TM_LoginApiManger

+ (void)sendCodeWithPhoneNum:(NSString *)phoneNum
                     success:(TMAPISuccessBlock)successBlock
                     failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"http://jdwlwm2m.com/custjdwl/apiApp/getVerificationCode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"] = phoneNum;
    params[@"time_stamp"] = [[TM_NetworkTool sharedNetworkTool] getTimeStamp];
    
    NSString *token = [[TM_NetworkTool sharedNetworkTool] getToken:params];
    params[@"token"] = token;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOSTRequestWithPath:url
                                                     parameters:params
                                                        headers:@{}
                                                        success:successBlock
                                                        failure:failureBlock];
}

+ (void)sendLoginWithPhoneNum:(NSString *)phoneNum
                     password:(NSString *)pw
                         code:(NSString *)code
                    isPwLogin:(BOOL)isPwLogin
                     success:(TMAPISuccessBlock)successBlock
                     failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"http://408dg24385.qicp.vip/custjdwl/apiApp/appLogin";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"] = phoneNum;
    params[@"time_stamp"] = [[TM_NetworkTool sharedNetworkTool] getTimeStamp];
    if (isPwLogin) {
        params[@"user_key"] = pw;
    }else {
        params[@"code"] = code;
    }
    
    NSString *token = [[TM_NetworkTool sharedNetworkTool] getToken:params];
    params[@"token"] = token;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOSTRequestWithPath:url
                                                     parameters:params
                                                        headers:@{}
                                                        success:successBlock
                                                        failure:failureBlock];
}

@end
