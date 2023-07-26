//
//:  TM_LoginApiManger.m
//:  TIanmu
//
//:  Created by 郑连杰 on 2023/6/21.
//

#import "TM_LoginApiManger.h"

@implementation TM_LoginApiManger

//MARK: 发送验证码
+ (void)sendCodeWithPhoneNum:(NSString *)phoneNum
                     success:(TMAPISuccessBlock)successBlock
                     failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"/getVerificationCode";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"] = phoneNum;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 登录
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
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 注册
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

//MARK: 修改密码
+ (void)sendFixPWWithPhoneNum:(NSString *)phoneNum
                     password:(NSString *)pw
                         code:(NSString *)code
                      success:(TMAPISuccessBlock)successBlock
                      failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"/updatePwd";
    
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

//MARK: 绑定微信登录
+ (void)sendBindWXLoginWithPhoneNum:(NSString *)phoneNum
                           password:(NSString *)pw
                               code:(NSString *)code
                             wxData:(NSDictionary *)wxData
                            success:(TMAPISuccessBlock)successBlock
                            failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"/bindUserWx";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"]        = phoneNum;
    params[@"wx_WXOpenID"]      = wxData[@"openid"];
    params[@"wx_HeadPic"]       = wxData[@"headimgurl"];
    params[@"wx_NickName"]      = @"";//wxData[@"nickname"];
    params[@"wx_Uinionid"]      = wxData[@"unionid"];
    params[@"wx_ClientId"]      = wxData[@"appid"];
    params[@"user_key"]         = pw;
    params[@"code"]             = code;
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}

//MARK: 查询是否绑定微信登录
+ (void)sendQueryBindWXLoginWithwxData:(NSDictionary *)wxData
                               success:(TMAPISuccessBlock)successBlock
                               failure:(TMAPIFailureBlock)failureBlock{
    
    NSString *url = @"/queryUserWxBind";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"wx_WXOpenID"]      = wxData[@"openid"];
    params[@"wx_HeadPic"]       = wxData[@"headimgurl"];
    params[@"wx_NickName"]      = @"";//wxData[@"nickname"];
    params[@"wx_Uinionid"]      = wxData[@"unionid"];
    params[@"wx_ClientId"]      = wxData[@"appid"];
    
    [[TM_NetworkTool sharedNetworkTool] sendPOST_RequestWithPath:url
                                                      parameters:params
                                                         headers:@{}
                                                         success:successBlock
                                                         failure:failureBlock];
}
@end
