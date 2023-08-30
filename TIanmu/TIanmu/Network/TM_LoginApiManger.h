//
//:  TM_LoginApiManger.h
//:  TIanmu
//
//:  Created by 郑连杰 on 2023/6/21.
//

#import "TM_NetworkTool.h"
#import "TM_NetworkTool+TM_Extension.h"
NS_ASSUME_NONNULL_BEGIN

@interface TM_LoginApiManger : TM_NetworkTool
//MARK: 发送验证码
+ (void)sendCodeWithPhoneNum:(NSString *)phoneNum
                     success:(TMAPISuccessBlock)successBlock
                     failure:(TMAPIFailureBlock)failureBlock;

///MARK: 登录请求
///MARK: - Parameters:
///MARK:   - phoneNum: 手机号
///MARK:   - pw: 密码：传参为账号密码登录，code不传
///MARK:   - code: 验证码：传参即为快捷登录，pw不传
///MARK:   - isPwLogin: 是否是密码登录
///MARK:   - successBlock: 回调
///MARK:   - failureBlock: 回调
+ (void)sendLoginWithPhoneNum:(NSString *)phoneNum
                     password:(NSString *)pw
                         code:(NSString *)code
                    isPwLogin:(BOOL)isPwLogin
                     success:(TMAPISuccessBlock)successBlock
                      failure:(TMAPIFailureBlock)failureBlock;

//MARK: 注册接口
+ (void)sendRegisterWithPhoneNum:(NSString *)phoneNum
                        password:(NSString *)pw
                            code:(NSString *)code
                         success:(TMAPISuccessBlock)successBlock
                         failure:(TMAPIFailureBlock)failureBlock;

//MARK: 修改密码
+ (void)sendFixPWWithPhoneNum:(NSString *)phoneNum
                     password:(NSString *)pw
                         code:(NSString *)code
                      success:(TMAPISuccessBlock)successBlock
                      failure:(TMAPIFailureBlock)failureBlock;

//MARK: 绑定微信登录
+ (void)sendBindWXLoginWithPhoneNum:(NSString *)phoneNum
                           password:(NSString *)pw
                               code:(NSString *)code
                             wxData:(NSDictionary *)wxData
                            success:(TMAPISuccessBlock)successBlock
                            failure:(TMAPIFailureBlock)failureBlock;

//MARK: 查询是否绑定微信登录
+ (void)sendQueryBindWXLoginWithwxData:(NSDictionary *)wxData
                               success:(TMAPISuccessBlock)successBlock
                               failure:(TMAPIFailureBlock)failureBlock;

//MARK: 查询切换网络列表
+ (void)sendQueryAppVersionWithSuccess:(TMAPISuccessBlock)successBlock
                               failure:(TMAPIFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
