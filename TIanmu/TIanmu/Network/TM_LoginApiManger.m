//
//  TM_LoginApiManger.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/21.
//

#import "TM_LoginApiManger.h"

@implementation TM_LoginApiManger

// 发送验证码
+ (void)sendCodeWithPhoneNum:(NSString *)phoneNum
                     success:(TMAPISuccessBlock)successBlock
                     failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"/getVerificationCode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"] = phoneNum;
    params[@"time_stamp"] = [[TM_NetworkTool sharedNetworkTool] getTimeStamp];
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

// 登录
+ (void)sendLoginWithPhoneNum:(NSString *)phoneNum
                     password:(NSString *)pw
                         code:(NSString *)code
                    isPwLogin:(BOOL)isPwLogin
                     success:(TMAPISuccessBlock)successBlock
                     failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"/appLogin";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"] = phoneNum;
    if (isPwLogin) {
        params[@"user_key"] = pw;
    }else {
        params[@"code"] = code;
    }
    
//    NSArray *sortKeys = @[@"user_name", @"user_key", @"time_stamp"];
//
//
//    NSMutableString *json = [NSMutableString stringWithString:@""];
//    for (int i = 0; i < sortKeys.count; i++) {
//        NSString *key = sortKeys[i];
//        NSString *value = params[key];
//        if (i == 0) {
//            [json appendString:@"{"];
//            [json appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"", key, value]];
//        }
//        if (i > 0) {
//            [json appendString:@","];
//            [json appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"", key, value]];
//        }
//        if (i == sortKeys.count - 1) {
//            [json appendString:@"}"];
//        }
//    }
//    NSString *token = [[TM_NetworkTool sharedNetworkTool] getTokenWithJson:json];
//    params[@"token"] = token;
//
//    [[TM_NetworkTool sharedNetworkTool] sendPOSTRequestWithPath:@"http://jdwlwm2m.com/custjdwl/apiApp/appLogin"
//                                                     parameters:params
//                                                        headers:@{}
//                                                        success:successBlock
//                                                        failure:failureBlock];
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

// 注册
+ (void)sendRegisterWithPhoneNum:(NSString *)phoneNum
                        password:(NSString *)pw
                            code:(NSString *)code
                         success:(TMAPISuccessBlock)successBlock
                         failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"/registerUser";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"]    = phoneNum;
    params[@"user_key"]     = pw;
    params[@"code"]         = code;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
@end
